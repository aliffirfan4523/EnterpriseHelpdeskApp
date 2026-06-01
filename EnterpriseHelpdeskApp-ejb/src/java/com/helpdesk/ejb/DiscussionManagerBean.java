package com.helpdesk.ejb;

import com.helpdesk.domain.core.Ticket;
import com.helpdesk.domain.meta.Comment;
import com.helpdesk.domain.meta.Tag;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class DiscussionManagerBean {

    // This injects the database connection from your persistence.xml
    @PersistenceContext(unitName = "HelpdeskPU")
    private EntityManager em;

    /**
     * Saves a new comment to the database and links it to the ticket.
     */
    public void addComment(Comment newComment) {
        em.persist(newComment);
    }

    /**
     * Fetches all tags from the database for the Admin dropdown menu.
     */
    public List<Tag> getAllTags() {
        return em.createQuery("SELECT t FROM Tag t", Tag.class).getResultList();
    }

    /**
     * Assigns a specific tag to a ticket (Handles the Many-to-Many relationship).
     */
    public void assignTagToTicket(int ticketId, int tagId) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        Tag tag = em.find(Tag.class, tagId);
        
        if (ticket != null && tag != null) {
            // Add the tag to the ticket's list
            ticket.getTags().add(tag);
            // JPA automatically updates the ticket_tags junction table!
            em.merge(ticket);
        }
    }
}