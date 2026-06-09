package com.helpdesk.web;

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.helpdesk.domain.core.User;
import com.helpdesk.domain.core.Department;
import com.helpdesk.ejb.UserManagerBean;
import java.util.List;

@WebServlet(name = "Register", urlPatterns = { "/Register" })
public class RegisterServlet extends HttpServlet {

    @EJB
    private UserManagerBean userManagerBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Department> departments = userManagerBean.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String departmentIdStr = request.getParameter("departmentId");

        // 1. Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            // 2. Create new User entity
            User newUser = new User();
            newUser.setName(fullname);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setRole("Employee"); // Default role for registration

            if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
                int deptId = Integer.parseInt(departmentIdStr);
                Department dept = userManagerBean.findDepartmentById(deptId);
                newUser.setDepartment(dept);
            }

            // 3. Save to database
            userManagerBean.registerUser(newUser);

            System.out.println("Registered User: " + fullname + " | Email: " + email);
            response.sendRedirect("index.jsp?success=registered");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to register user. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
