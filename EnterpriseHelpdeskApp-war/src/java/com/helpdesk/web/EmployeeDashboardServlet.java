package com.helpdesk.web;

import java.io.IOException;
import java.util.HashMap;
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
import com.helpdesk.ejb.HelpdeskBean;
import com.helpdesk.ejb.TicketManagerBean;
import com.helpdesk.ejb.UserManagerBean;

@WebServlet(name = "EmployeeDashboard", urlPatterns = { "/EmployeeDashboard" })
public class EmployeeDashboardServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManagerBean;

    @EJB
    private UserManagerBean userManagerBean;

    @EJB
    private HelpdeskBean helpdeskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Get tickets belonging to logged in user
        List<Ticket> tickets = ticketManagerBean.getTicketsByUser(userId);
        List<Priority> priorities = userManagerBean.getAllPriorities();
        List<Department> departments = userManagerBean.getAllDepartments();

        // Calculate employee-specific stats
        long openCount = 0;
        long inProgressCount = 0;
        long resolvedCount = 0;

        if (tickets != null) {
            for (Ticket t : tickets) {
                String st = t.getStatus() != null ? t.getStatus().toLowerCase() : "";
                if ("open".equals(st)) {
                    openCount++;
                } else if ("in progress".equals(st)) {
                    inProgressCount++;
                } else if ("closed".equals(st) || "resolved".equals(st)) {
                    resolvedCount++;
                }
            }
        }

        Map<String, Long> userStats = new HashMap<>();
        userStats.put("total", tickets != null ? (long) tickets.size() : 0L);
        userStats.put("open", openCount);
        userStats.put("inProgress", inProgressCount);
        userStats.put("resolved", resolvedCount);

        request.setAttribute("tickets", tickets);
        request.setAttribute("priorities", priorities);
        request.setAttribute("departments", departments);
        request.setAttribute("userStats", userStats);
        request.setAttribute("helpdeskBean", helpdeskBean);

        request.getRequestDispatcher("/employee.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}