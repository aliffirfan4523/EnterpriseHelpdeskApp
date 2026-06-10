package com.helpdesk.web;

import com.helpdesk.domain.core.Ticket;
import com.helpdesk.domain.core.User;
import com.helpdesk.domain.meta.Comment;
import com.helpdesk.ejb.DiscussionManagerBean;
import com.helpdesk.ejb.TicketManagerBean;
import com.helpdesk.ejb.UserManagerBean;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddCommentServlet", urlPatterns = {"/AddComment"})
public class AddCommentServlet extends HttpServlet {

    @EJB
    private DiscussionManagerBean discussionManager;

    @EJB
    private TicketManagerBean ticketManager;

    @EJB
    private UserManagerBean userManager;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String ticketIdStr = request.getParameter("ticketId");
        String message = request.getParameter("commentText");

        if (ticketIdStr != null && message != null && !message.trim().isEmpty()) {
            try {
                int ticketId = Integer.parseInt(ticketIdStr);
                User user = userManager.findUserById(userId);
                Ticket ticket = ticketManager.findTicketById(ticketId);

                if (user != null && ticket != null) {
                    Comment comment = new Comment();
                    comment.setUser(user);
                    comment.setTicket(ticket);
                    comment.setMessage(message);

                    discussionManager.addComment(comment);
                }
            } catch (NumberFormatException e) {
                // Invalid ticket ID format
                e.printStackTrace();
            }
        }

        // Redirect back to the previous page or dashboard based on role
        String referer = request.getHeader("Referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            String role = (String) session.getAttribute("role");
            if ("Admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/AdminDashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/EmployeeDashboard");
            }
        }
    }
}