package com.helpdesk.web;

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

        String ticketIdStr = request.getParameter("ticketId");
        String action = request.getParameter("action");

        try {
            int ticketId = Integer.parseInt(ticketIdStr);

            if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("status");
                ticketManagerBean.updateTicketStatus(ticketId, newStatus);
            } else if ("addTag".equals(action)) {
                String tagIdStr = request.getParameter("tagId");
                int tagId = Integer.parseInt(tagIdStr);
                discussionManager.assignTagToTicket(ticketId, tagId);
            }

            response.sendRedirect(request.getContextPath() + "/ViewTicket?ticketId=" + ticketId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
        }
    }
}