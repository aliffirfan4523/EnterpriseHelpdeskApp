package com.helpdesk.web;

import com.helpdesk.ejb.TicketManagerBean;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RateTicketServlet", urlPatterns = {"/RateTicket"})
public class RateTicketServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManager;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        try {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String feedback = request.getParameter("feedback");

            if (rating < 1) rating = 1;
            if (rating > 5) rating = 5;

            ticketManager.submitTicketRating(ticketId, rating, feedback);
            response.sendRedirect(request.getContextPath() + "/ViewTicket?ticketId=" + ticketId + "&rated=true");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/EmployeeDashboard");
        }
    }
}
