package com.helpdesk.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * TEMPORARY SERVLET - DELETE THIS BEFORE FINAL SUBMISSION!
 * 
 * This servlet fakes a login session so team members can test
 * their pages without waiting for the Login module to be completed.
 * 
 * Usage:
 *   Login as Admin:    http://localhost:8080/EnterpriseHelpdeskApp-war/TestLogin?role=Admin
 *   Login as Employee: http://localhost:8080/EnterpriseHelpdeskApp-war/TestLogin?role=Employee
 */
@WebServlet(name = "TestLoginServlet", urlPatterns = {"/TestLogin"})
public class TestLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");

        // Default to Employee if no role is specified
        if (role == null || role.isEmpty()) {
            role = "Employee";
        }

        // Create a fake session with test user data from script.sql
        HttpSession session = request.getSession(true);

        if ("Admin".equalsIgnoreCase(role)) {
            session.setAttribute("userId", 1);
            session.setAttribute("userName", "Admin User");
            session.setAttribute("userEmail", "admin@unikl.edu.my");
            session.setAttribute("userRole", "Admin");
            response.sendRedirect("AdminDashboardServlet");
        } else {
            session.setAttribute("userId", 2);
            session.setAttribute("userName", "Test Employee");
            session.setAttribute("userEmail", "employee@unikl.edu.my");
            session.setAttribute("userRole", "Employee");
            // Redirect to employee dashboard (Option 2 will create this)
            // For now, just show a confirmation message
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h2>Logged in as: " + role + "</h2>");
            response.getWriter().println("<p>User ID: " + session.getAttribute("userId") + "</p>");
            response.getWriter().println("<p>Name: " + session.getAttribute("userName") + "</p>");
            response.getWriter().println("<p>Session is now active. You can navigate to your pages.</p>");
            response.getWriter().println("<br>");
            response.getWriter().println("<a href='AdminDashboardServlet'>Go to Admin Dashboard</a><br>");
            response.getWriter().println("<a href='EmployeeDashboardServlet'>Go to Employee Dashboard</a><br>");
            response.getWriter().println("<a href='ViewTicketServlet?ticketId=1'>Go to Ticket Details (ID=1)</a>");
            response.getWriter().println("</body></html>");
        }
    }
}
