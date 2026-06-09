package com.helpdesk.web;

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.helpdesk.domain.core.User;
import com.helpdesk.ejb.UserManagerBean;

@WebServlet(name = "Login", urlPatterns = { "/Login" })
public class LoginServlet extends HttpServlet {

    @EJB
    private UserManagerBean userManagerBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // 1. Check database for valid user
        User loggedInUser = userManagerBean.authenticate(email, password, role);

        if (loggedInUser != null) {
            // 2. User found, create session
            HttpSession session = request.getSession();
            session.setAttribute("email", loggedInUser.getEmail());
            session.setAttribute("role", loggedInUser.getRole());
            session.setAttribute("userId", loggedInUser.getId()); // Good practice to store ID
            session.setAttribute("name", loggedInUser.getName());

            // 3. Redirect based on role
            if ("Admin".equals(loggedInUser.getRole())) {
                response.sendRedirect("AdminDashboard");
            } else {
                response.sendRedirect("EmployeeDashboard");
            }

        } else {
            // 4. Invalid credentials
            request.setAttribute("error", "Invalid Email, Password, or Role mismatch.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
