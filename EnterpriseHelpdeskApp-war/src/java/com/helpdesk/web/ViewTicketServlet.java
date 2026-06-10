package com.helpdesk.web;

import com.helpdesk.domain.core.Ticket;
import com.helpdesk.ejb.TicketManagerBean;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ViewTicketServlet", urlPatterns = {"/ViewTicket"})
public class ViewTicketServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManagerBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String ticketIdStr = request.getParameter("ticketId");
        if (ticketIdStr != null && !ticketIdStr.isEmpty()) {
            try {
                int ticketId = Integer.parseInt(ticketIdStr);
                Ticket ticket = ticketManagerBean.findTicketById(ticketId);
                
                if (ticket != null) {
                    request.setAttribute("ticket", ticket);
                    request.getRequestDispatcher("/ticket-details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        // If ticket not found or invalid ID, redirect back
        String role = (String) session.getAttribute("role");
        if ("Admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/EmployeeDashboard");
        }
    }
}