package com.helpdesk.web;

import com.helpdesk.domain.core.Priority;
import com.helpdesk.domain.core.Ticket;
import com.helpdesk.domain.core.User;
import com.helpdesk.ejb.TicketManagerBean;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "SubmitTicketServlet",
        urlPatterns = {"/SubmitTicketServlet"})
public class SubmitTicketServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManagerBean;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("TestLogin?role=Employee");
            return;
        }

        try {

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int priorityId = Integer.parseInt(
                    request.getParameter("priorityId"));

            int userId = (Integer) session.getAttribute("userId");

            User user = new User();
            user.setId(userId);

            Priority priority = new Priority();
            priority.setId(priorityId);

            Ticket ticket = new Ticket();
            ticket.setTitle(title);
            ticket.setDescription(description);
            ticket.setStatus("Open");
            ticket.setUser(user);
            ticket.setPriority(priority);

            ticketManagerBean.createTicket(ticket);

            response.sendRedirect("EmployeeDashboardServlet");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().println(
                    "Error submitting ticket: "
                    + ex.getMessage());
        }
    }
}