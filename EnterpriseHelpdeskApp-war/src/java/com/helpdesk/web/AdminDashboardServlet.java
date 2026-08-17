package com.helpdesk.web;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.helpdesk.domain.core.Department;
import com.helpdesk.domain.core.Priority;
import com.helpdesk.domain.core.Ticket;
import com.helpdesk.domain.core.User;
import com.helpdesk.domain.meta.Tag;
import com.helpdesk.ejb.DiscussionManagerBean;
import com.helpdesk.ejb.HelpdeskBean;
import com.helpdesk.ejb.TicketManagerBean;
import com.helpdesk.ejb.UserManagerBean;

@WebServlet(name = "AdminDashboard", urlPatterns = { "/AdminDashboard" })
public class AdminDashboardServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManager;

    @EJB
    private UserManagerBean userManager;

    @EJB
    private DiscussionManagerBean discussionManager;

    @EJB
    private HelpdeskBean helpdeskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check: Kick them out if they aren't logged in as an Admin
        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // 2. Fetch all tickets, stats, admins, departments, tags
        List<Ticket> allTickets = ticketManager.getAllTicketsSortedByDate();
        Map<String, Long> stats = ticketManager.getTicketStats();
        List<User> admins = userManager.getAllAdmins();
        List<Department> departments = userManager.getAllDepartments();
        List<Priority> priorities = userManager.getAllPriorities();
        List<Tag> tags = discussionManager.getAllTags();

        // 3. Attach data to request
        request.setAttribute("ticketList", allTickets);
        request.setAttribute("tickets", allTickets);
        request.setAttribute("stats", stats);
        request.setAttribute("admins", admins);
        request.setAttribute("allUsers", userManager.getAllUsers());
        request.setAttribute("departments", departments);
        request.setAttribute("priorities", priorities);
        request.setAttribute("tags", tags);
        request.setAttribute("helpdeskBean", helpdeskBean);

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}

