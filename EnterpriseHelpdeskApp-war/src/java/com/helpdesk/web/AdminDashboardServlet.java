package com.helpdesk.web;

import com.helpdesk.domain.core.Ticket;
import com.helpdesk.ejb.TicketManagerBean;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/AdminDashboardServlet"})
public class AdminDashboardServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManager;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Security Check: Kick them out if they aren't logged in as an Admin
        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("index.jsp"); 
            return;
        }

        // 2. Fetch all tickets using the EJB
        List<Ticket> allTickets = ticketManager.getAllTicketsSortedByDate();

        // 3. Attach the list to the request and send it to the JSP
        System.out.println("DEBUG: allTickets size = " + (allTickets != null ? allTickets.size() : "null"));
        request.setAttribute("ticketList", allTickets);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
