package com.helpdesk.web;

import com.helpdesk.domain.core.Ticket;
import java.io.IOException;
import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.UserTransaction;

@WebServlet(name = "UpdateTicketServlet", urlPatterns = {"/UpdateTicketServlet"})
public class UpdateTicketServlet extends HttpServlet {

    @PersistenceContext(unitName = "HelpdeskPU")
    private EntityManager em;

    // Required to manually commit changes to the database in a Servlet
    @Resource
    private UserTransaction utx; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Grab the data sent from the HTML form in admin.jsp
        String ticketIdStr = request.getParameter("ticketId");
        String newStatus = request.getParameter("status");

        if (ticketIdStr != null && newStatus != null) {
            try {
                int ticketId = Integer.parseInt(ticketIdStr);
                
                // Begin the database transaction
                utx.begin();
                
                // Find the specific ticket, update the status, and merge it back
                Ticket ticket = em.find(Ticket.class, ticketId);
                if (ticket != null) {
                    ticket.setStatus(newStatus);
                    em.merge(ticket);
                }
                
                // Save the changes
                utx.commit();
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Refresh the page by redirecting back to the Dashboard Servlet
        response.sendRedirect("AdminDashboardServlet");
    }
}