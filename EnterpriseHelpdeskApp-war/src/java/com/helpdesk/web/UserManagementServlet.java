package com.helpdesk.web;

import com.helpdesk.ejb.UserManagerBean;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/UserManagement"})
public class UserManagementServlet extends HttpServlet {

    @EJB
    private UserManagerBean userManagerBean;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdStr);

                if ("deleteUser".equals(action)) {
                    userManagerBean.deleteUser(userId);
                } else if ("updateRole".equals(action)) {
                    String newRole = request.getParameter("newRole");
                    if ("Admin".equals(newRole) || "Employee".equals(newRole)) {
                        userManagerBean.updateUserRole(userId, newRole);
                    }
                } else if ("resetPassword".equals(action)) {
                    String newPassword = request.getParameter("newPassword");
                    if (newPassword != null && !newPassword.trim().isEmpty()) {
                        userManagerBean.resetUserPassword(userId, newPassword.trim());
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/AdminDashboard?userUpdated=true");
    }
}
