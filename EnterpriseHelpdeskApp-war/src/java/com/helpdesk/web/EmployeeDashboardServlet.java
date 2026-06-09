package com.helpdesk.web;

import java.io.IOException;
import java.util.List;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.helpdesk.domain.core.Ticket;
import com.helpdesk.ejb.TicketManagerBean;

@WebServlet(name = "EmployeeDashboard", urlPatterns = { "/EmployeeDashboard" })
public class EmployeeDashboardServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManagerBean;

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("TestLogin?role=Employee");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Get tickets belonging to logged in user
        List<Ticket> tickets = ticketManagerBean.getTicketsByUser(userId);

        request.setAttribute("tickets", tickets);

        request.getRequestDispatcher("/employee.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}