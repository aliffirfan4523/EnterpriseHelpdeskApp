package com.helpdesk.web;

import com.helpdesk.domain.meta.Tag;
import com.helpdesk.ejb.TicketManagerBean;
import com.helpdesk.ejb.DiscussionManagerBean;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UpdateTicket", urlPatterns = {"/UpdateTicket"})
public class UpdateTicketServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManagerBean;

    @EJB
    private DiscussionManagerBean discussionManager;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admins can update tickets.");
            return;
        }

        Integer actorUserId = (Integer) session.getAttribute("userId");
        String ticketIdStr = request.getParameter("ticketId");
        String action = request.getParameter("action");

        try {
            int ticketId = Integer.parseInt(ticketIdStr);

            if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("status");
                if (newStatus != null && !newStatus.trim().isEmpty()) {
                    ticketManagerBean.updateTicketStatus(ticketId, newStatus.trim(), actorUserId);
                }
            } else if ("updatePriority".equals(action)) {
                String priorityIdStr = request.getParameter("priorityId");
                if (priorityIdStr != null && !priorityIdStr.isEmpty()) {
                    int priorityId = Integer.parseInt(priorityIdStr);
                    ticketManagerBean.updateTicketPriority(ticketId, priorityId, actorUserId);
                }
            } else if ("assignTicket".equals(action)) {
                String adminIdStr = request.getParameter("adminId");
                Integer adminId = (adminIdStr != null && !adminIdStr.isEmpty() && !adminIdStr.equals("0")) ? Integer.parseInt(adminIdStr) : null;
                ticketManagerBean.assignTicket(ticketId, adminId, actorUserId);
            } else if ("addTag".equals(action)) {
                String tagIdStr = request.getParameter("tagId");
                if (tagIdStr != null && !tagIdStr.isEmpty()) {
                    int tagId = Integer.parseInt(tagIdStr);
                    discussionManager.assignTagToTicket(ticketId, tagId);
                    ticketManagerBean.logAudit(ticketId, actorUserId, "Tag Added", "Assigned tag ID " + tagId);
                }
            } else if ("createTag".equals(action)) {
                String newTagName = request.getParameter("newTagName");
                if (newTagName != null && !newTagName.trim().isEmpty()) {
                    Tag created = discussionManager.createTag(newTagName.trim());
                    if (created != null) {
                        discussionManager.assignTagToTicket(ticketId, created.getId());
                        ticketManagerBean.logAudit(ticketId, actorUserId, "Tag Created & Added", "Created tag '" + newTagName.trim() + "'");
                    }
                }
            } else if ("removeTag".equals(action)) {
                String tagIdStr = request.getParameter("tagId");
                if (tagIdStr != null && !tagIdStr.isEmpty()) {
                    int tagId = Integer.parseInt(tagIdStr);
                    ticketManagerBean.removeTagFromTicket(ticketId, tagId);
                }
            } else if ("deleteTicket".equals(action)) {
                ticketManagerBean.deleteTicket(ticketId);
                response.sendRedirect(request.getContextPath() + "/AdminDashboard?deleted=true");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/ViewTicket?ticketId=" + ticketId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
        }
    }
}