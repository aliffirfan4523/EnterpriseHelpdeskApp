package com.helpdesk.web;

import com.helpdesk.domain.core.Priority;
import com.helpdesk.domain.core.Ticket;
import com.helpdesk.domain.core.User;
import com.helpdesk.ejb.DiscussionManagerBean;
import com.helpdesk.ejb.TicketManagerBean;
import com.helpdesk.ejb.UserManagerBean;

import java.io.IOException;
import java.util.ArrayList;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "SubmitTicket", urlPatterns = {"/SubmitTicket"})
public class SubmitTicketServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManagerBean;

    @EJB
    private UserManagerBean userManagerBean;

    @EJB
    private DiscussionManagerBean discussionManager;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String priorityIdStr = request.getParameter("priorityId");
            int priorityId = (priorityIdStr != null && !priorityIdStr.isEmpty()) ? Integer.parseInt(priorityIdStr) : 2;

            int userId = (Integer) session.getAttribute("userId");
            User user = userManagerBean.findUserById(userId);
            Priority priority = userManagerBean.findPriorityById(priorityId);

            if (user == null || priority == null || title == null || title.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/EmployeeDashboard?error=invalid_data");
                return;
            }

            String category = request.getParameter("category");
            if (category == null || category.trim().isEmpty()) {
                category = "General Support";
            }

            Ticket ticket = new Ticket();
            ticket.setTitle(title.trim());
            ticket.setDescription(description != null ? description.trim() : "");
            ticket.setStatus("Open");
            ticket.setCategory(category.trim());
            ticket.setUser(user);
            ticket.setPriority(priority);
            ticket.setTags(new ArrayList<>());

            ticketManagerBean.createTicket(ticket);

            // If tag was specified
            String tagIdStr = request.getParameter("tagId");
            if (tagIdStr != null && !tagIdStr.isEmpty()) {
                try {
                    int tagId = Integer.parseInt(tagIdStr);
                    discussionManager.assignTagToTicket(ticket.getId(), tagId);
                } catch (Exception e) {
                    // Ignore tag assignment error
                }
            }

            String role = (String) session.getAttribute("role");
            if ("Admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/AdminDashboard?created=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/EmployeeDashboard?created=true");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EmployeeDashboard?error=failed");
        }
    }
}