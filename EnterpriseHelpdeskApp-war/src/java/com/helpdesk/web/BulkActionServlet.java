package com.helpdesk.web;

import com.helpdesk.ejb.TicketManagerBean;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BulkActionServlet", urlPatterns = {"/BulkAction"})
public class BulkActionServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManager;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"Admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Integer actorUserId = (Integer) session.getAttribute("userId");
        int userId = actorUserId != null ? actorUserId : 0;

        String[] selectedTicketIds = request.getParameterValues("selectedTickets");
        String bulkActionType = request.getParameter("bulkActionType");

        if (selectedTicketIds != null && selectedTicketIds.length > 0 && bulkActionType != null) {
            List<Integer> ids = new ArrayList<>();
            for (String idStr : selectedTicketIds) {
                try {
                    ids.add(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException ignored) {}
            }

            if (!ids.isEmpty()) {
                switch (bulkActionType) {
                    case "status":
                        String newStatus = request.getParameter("bulkStatus");
                        if (newStatus != null && !newStatus.isEmpty()) {
                            ticketManager.bulkUpdateStatus(ids, newStatus, userId);
                        }
                        break;
                    case "assign":
                        try {
                            int adminId = Integer.parseInt(request.getParameter("bulkAdminId"));
                            ticketManager.bulkAssign(ids, adminId, userId);
                        } catch (NumberFormatException ignored) {}
                        break;
                    case "priority":
                        try {
                            int priorityId = Integer.parseInt(request.getParameter("bulkPriorityId"));
                            ticketManager.bulkUpdatePriority(ids, priorityId, userId);
                        } catch (NumberFormatException ignored) {}
                        break;
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/AdminDashboard?bulkUpdated=true");
    }
}
