package com.helpdesk.ejb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.helpdesk.domain.core.Priority;
import com.helpdesk.domain.core.Ticket;
import com.helpdesk.domain.core.User;
import com.helpdesk.domain.meta.Article;
import com.helpdesk.domain.meta.Comment;
import com.helpdesk.domain.meta.Tag;
import com.helpdesk.domain.meta.TicketAuditLog;
import com.helpdesk.domain.meta.TicketRating;

@Stateless
public class TicketManagerBean {

    @PersistenceContext(unitName = "HelpdeskPU")
    private EntityManager em;

    public List<Ticket> getAllTicketsSortedByDate() {
        String jpql = "SELECT t FROM Ticket t ORDER BY t.dateCreated DESC";
        TypedQuery<Ticket> query = em.createQuery(jpql, Ticket.class);
        return query.getResultList();
    }

    public void updateTicketStatus(int ticketId, String newStatus) {
        updateTicketStatus(ticketId, newStatus, null);
    }

    public void updateTicketStatus(int ticketId, String newStatus, Integer actorUserId) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        if (ticket != null) {
            String oldStatus = ticket.getStatus();
            ticket.setStatus(newStatus);
            em.merge(ticket);
            logAudit(ticketId, actorUserId, "Status Changed", "Status transitioned from '" + oldStatus + "' to '" + newStatus + "'");
        }
    }

    public void updateTicketPriority(int ticketId, int priorityId) {
        updateTicketPriority(ticketId, priorityId, null);
    }

    public void updateTicketPriority(int ticketId, int priorityId, Integer actorUserId) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        Priority priority = em.find(Priority.class, priorityId);
        if (ticket != null && priority != null) {
            String oldPri = ticket.getPriority() != null ? ticket.getPriority().getLevelName() : "None";
            ticket.setPriority(priority);
            em.merge(ticket);
            logAudit(ticketId, actorUserId, "Priority Changed", "Priority updated from '" + oldPri + "' to '" + priority.getLevelName() + "' (" + priority.getResolveHours() + "h SLA)");
        }
    }

    public void assignTicket(int ticketId, Integer adminId) {
        assignTicket(ticketId, adminId, null);
    }

    public void assignTicket(int ticketId, Integer adminId, Integer actorUserId) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        if (ticket != null) {
            if (adminId != null && adminId > 0) {
                User admin = em.find(User.class, adminId);
                ticket.setAssignedTo(admin);
                logAudit(ticketId, actorUserId, "Technician Assigned", "Assigned to " + (admin != null ? admin.getName() : "ID " + adminId));
            } else {
                ticket.setAssignedTo(null);
                logAudit(ticketId, actorUserId, "Unassigned", "Ticket moved to unassigned general queue");
            }
            em.merge(ticket);
        }
    }

    public void deleteTicket(int ticketId) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        if (ticket != null) {
            if (ticket.getComments() != null) {
                for (Comment c : ticket.getComments()) {
                    em.remove(c);
                }
            }
            if (ticket.getTags() != null) {
                ticket.getTags().clear();
            }
            em.remove(ticket);
        }
    }

    public void removeTagFromTicket(int ticketId, int tagId) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        Tag tag = em.find(Tag.class, tagId);
        if (ticket != null && tag != null && ticket.getTags() != null) {
            ticket.getTags().remove(tag);
            em.merge(ticket);
            logAudit(ticketId, null, "Tag Removed", "Removed tag '" + tag.getName() + "'");
        }
    }
    
    public List<Ticket> getTicketsByUser(int userId) {
        String jpql =
        "SELECT t FROM Ticket t " +
        "WHERE t.user.id = :userId " +
        "ORDER BY t.dateCreated DESC";

        return em.createQuery(jpql, Ticket.class)
            .setParameter("userId", userId)
            .getResultList();
    }
    
    public void createTicket(Ticket ticket) {
        em.persist(ticket);
        em.flush();
        em.refresh(ticket);
        logAudit(ticket.getId(), ticket.getUser() != null ? ticket.getUser().getId() : null, "Ticket Logged", "Ticket created via portal with category '" + ticket.getCategory() + "'");
    }

    public Ticket findTicketById(int id) {
        Ticket ticket = em.find(Ticket.class, id);
        if (ticket != null) {
            em.refresh(ticket);
            if (ticket.getComments() != null) {
                ticket.getComments().size();
            }
            if (ticket.getTags() != null) {
                ticket.getTags().size();
            }
            if (ticket.getAuditLogs() != null) {
                ticket.getAuditLogs().size();
            }
        }
        return ticket;
    }

    // =========================================================================
    // Feature: Audit Trail Logging
    // =========================================================================
    public void logAudit(int ticketId, Integer userId, String action, String details) {
        try {
            Ticket ticket = em.find(Ticket.class, ticketId);
            User user = (userId != null && userId > 0) ? em.find(User.class, userId) : null;
            if (ticket != null) {
                TicketAuditLog audit = new TicketAuditLog(ticket, user, action, details);
                em.persist(audit);
            }
        } catch (Exception e) {
            // Non-blocking audit failure
            System.err.println("Audit log error: " + e.getMessage());
        }
    }

    public List<TicketAuditLog> getAuditLogsForTicket(int ticketId) {
        String jpql = "SELECT a FROM TicketAuditLog a WHERE a.ticket.id = :ticketId ORDER BY a.loggedAt DESC";
        return em.createQuery(jpql, TicketAuditLog.class)
            .setParameter("ticketId", ticketId)
            .getResultList();
    }

    // =========================================================================
    // Feature: Customer Satisfaction (CSAT) Rating
    // =========================================================================
    public void submitTicketRating(int ticketId, int rating, String feedback) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        if (ticket != null) {
            // Check if rating already exists
            TicketRating existing = getRatingForTicket(ticketId);
            if (existing != null) {
                existing.setRating(rating);
                existing.setFeedback(feedback);
                em.merge(existing);
            } else {
                TicketRating tr = new TicketRating(ticket, rating, feedback);
                em.persist(tr);
            }
            logAudit(ticketId, ticket.getUser() != null ? ticket.getUser().getId() : null, "CSAT Feedback Submitted", "Rating: " + rating + " / 5 stars");
        }
    }

    public TicketRating getRatingForTicket(int ticketId) {
        try {
            String jpql = "SELECT r FROM TicketRating r WHERE r.ticket.id = :ticketId";
            List<TicketRating> list = em.createQuery(jpql, TicketRating.class)
                .setParameter("ticketId", ticketId)
                .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            return null;
        }
    }

    // =========================================================================
    // Feature: Knowledge Base Articles
    // =========================================================================
    public List<Article> getAllArticles() {
        String jpql = "SELECT a FROM Article a ORDER BY a.id ASC";
        return em.createQuery(jpql, Article.class).getResultList();
    }

    public void addArticle(String title, String category, String content, Integer authorId) {
        Article article = new Article(title, category, content);
        article.setAuthorId(authorId);
        em.persist(article);
    }

    public void deleteArticle(int articleId) {
        Article article = em.find(Article.class, articleId);
        if (article != null) {
            em.remove(article);
        }
    }

    public List<Article> searchArticles(String keyword, String category) {
        StringBuilder jpql = new StringBuilder("SELECT a FROM Article a WHERE 1=1");
        if (category != null && !category.isEmpty() && !category.equalsIgnoreCase("all")) {
            jpql.append(" AND LOWER(a.category) = :category");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            jpql.append(" AND (LOWER(a.title) LIKE :keyword OR LOWER(a.content) LIKE :keyword)");
        }
        jpql.append(" ORDER BY a.id ASC");

        TypedQuery<Article> query = em.createQuery(jpql.toString(), Article.class);
        if (category != null && !category.isEmpty() && !category.equalsIgnoreCase("all")) {
            query.setParameter("category", category.toLowerCase());
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.toLowerCase().trim() + "%");
        }
        return query.getResultList();
    }

    // =========================================================================
    // Feature: Bulk Ticket Operations
    // =========================================================================
    public int bulkUpdateStatus(List<Integer> ticketIds, String newStatus, int actorUserId) {
        int count = 0;
        for (Integer id : ticketIds) {
            updateTicketStatus(id, newStatus, actorUserId);
            count++;
        }
        return count;
    }

    public int bulkAssign(List<Integer> ticketIds, int adminId, int actorUserId) {
        int count = 0;
        for (Integer id : ticketIds) {
            assignTicket(id, adminId, actorUserId);
            count++;
        }
        return count;
    }

    public int bulkUpdatePriority(List<Integer> ticketIds, int priorityId, int actorUserId) {
        int count = 0;
        for (Integer id : ticketIds) {
            updateTicketPriority(id, priorityId, actorUserId);
            count++;
        }
        return count;
    }

    // =========================================================================
    // Feature: Analytics & KPI Data
    // =========================================================================
    public Map<String, Object> getAnalyticsData() {
        Map<String, Object> analytics = new HashMap<>();
        try {
            Long total = em.createQuery("SELECT COUNT(t) FROM Ticket t", Long.class).getSingleResult();
            Long open = em.createQuery("SELECT COUNT(t) FROM Ticket t WHERE LOWER(t.status) = 'open'", Long.class).getSingleResult();
            Long inProgress = em.createQuery("SELECT COUNT(t) FROM Ticket t WHERE LOWER(t.status) = 'in progress'", Long.class).getSingleResult();
            Long closed = em.createQuery("SELECT COUNT(t) FROM Ticket t WHERE LOWER(t.status) = 'closed' OR LOWER(t.status) = 'resolved'", Long.class).getSingleResult();
            Long critical = em.createQuery("SELECT COUNT(t) FROM Ticket t WHERE LOWER(t.priority.levelName) = 'critical' OR LOWER(t.priority.levelName) = 'high'", Long.class).getSingleResult();

            // CSAT Average
            Double avgRating = em.createQuery("SELECT AVG(r.rating) FROM TicketRating r", Double.class).getSingleResult();
            Long totalRatings = em.createQuery("SELECT COUNT(r) FROM TicketRating r", Long.class).getSingleResult();

            analytics.put("total", total != null ? total : 0L);
            analytics.put("open", open != null ? open : 0L);
            analytics.put("inProgress", inProgress != null ? inProgress : 0L);
            analytics.put("closed", closed != null ? closed : 0L);
            analytics.put("critical", critical != null ? critical : 0L);
            analytics.put("avgRating", avgRating != null ? String.format("%.1f", avgRating) : "5.0");
            analytics.put("totalRatings", totalRatings != null ? totalRatings : 0L);

            // Calculate Resolution Rate %
            int resolutionRate = total != null && total > 0 ? (int) Math.round(((double) (closed != null ? closed : 0) / total) * 100) : 100;
            analytics.put("resolutionRate", resolutionRate);

        } catch (Exception e) {
            analytics.put("total", 0L);
            analytics.put("open", 0L);
            analytics.put("inProgress", 0L);
            analytics.put("closed", 0L);
            analytics.put("critical", 0L);
            analytics.put("avgRating", "5.0");
            analytics.put("totalRatings", 0L);
            analytics.put("resolutionRate", 100);
        }
        return analytics;
    }

    public Map<String, Long> getTicketStats() {
        Map<String, Long> stats = new HashMap<>();
        Map<String, Object> analytics = getAnalyticsData();
        stats.put("total", (Long) analytics.get("total"));
        stats.put("open", (Long) analytics.get("open"));
        stats.put("inProgress", (Long) analytics.get("inProgress"));
        stats.put("closed", (Long) analytics.get("closed"));
        stats.put("critical", (Long) analytics.get("critical"));
        return stats;
    }
}
