package com.helpdesk.web;

import com.helpdesk.ejb.TicketManagerBean;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateTicketServlet", urlPatterns = {"/UpdateTicketServlet"})
public class UpdateTicketServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManager;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Grab the data sent from the HTML form in admin.jsp
        String ticketIdStr = request.getParameter("ticketId");
        String newStatus = request.getParameter("status");

        if (ticketIdStr != null && newStatus != null) {
            try {
                int ticketId = Integer.parseInt(ticketIdStr);
                
                // Update the ticket status using the EJB
                ticketManager.updateTicketStatus(ticketId, newStatus);
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Refresh the page by redirecting back to the Dashboard Servlet
        response.sendRedirect("AdminDashboardServlet");
    }
}