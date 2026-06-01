package com.helpdesk.web;

import com.helpdesk.domain.core.Ticket;
import java.io.IOException;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/AdminDashboardServlet"})
public class AdminDashboardServlet extends HttpServlet {

    // Automatically connects to your persistence.xml
    @PersistenceContext(unitName = "HelpdeskPU")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Security Check: Kick them out if they aren't logged in as an Admin
        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("index.jsp"); 
            return;
        }

        // 2. The JPQL Query: Fetch all tickets, newest first
        String jpql = "SELECT t FROM Ticket t ORDER BY t.dateCreated DESC";
        TypedQuery<Ticket> query = em.createQuery(jpql, Ticket.class);
        List<Ticket> allTickets = query.getResultList();

        // 3. Attach the list to the request and send it to the JSP
        request.setAttribute("ticketList", allTickets);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}