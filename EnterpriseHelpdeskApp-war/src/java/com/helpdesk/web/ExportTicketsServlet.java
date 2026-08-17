package com.helpdesk.web;

import com.helpdesk.domain.core.Ticket;
import com.helpdesk.ejb.HelpdeskBean;
import com.helpdesk.ejb.TicketManagerBean;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ExportTicketsServlet", urlPatterns = {"/ExportTickets"})
public class ExportTicketsServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManagerBean;

    @EJB
    private HelpdeskBean helpdeskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        List<Ticket> tickets;
        if ("Admin".equals(role)) {
            tickets = ticketManagerBean.getAllTicketsSortedByDate();
        } else {
            tickets = ticketManagerBean.getTicketsByUser(userId);
        }

        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String filename = "helpdesk_tickets_" + timestamp + ".csv";

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        PrintWriter writer = response.getWriter();
        // UTF-8 BOM for Excel compatibility
        writer.write('\ufeff');

        // CSV Header
        writer.println("Ticket ID,Title,Requester,Department,Priority,Status,Assignee,Date Created,SLA Deadline,SLA Status");

        if (tickets != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            for (Ticket t : tickets) {
                String id = "#INC-" + t.getId();
                String title = escapeCsv(t.getTitle());
                String requester = t.getUser() != null ? escapeCsv(t.getUser().getName()) : "Unknown";
                String dept = (t.getUser() != null && t.getUser().getDepartment() != null) ? escapeCsv(t.getUser().getDepartment().getName()) : "N/A";
                String priority = t.getPriority() != null ? escapeCsv(t.getPriority().getLevelName()) : "Standard";
                String status = escapeCsv(t.getStatus());
                String assignee = t.getAssignedTo() != null ? escapeCsv(t.getAssignedTo().getName()) : "Unassigned";
                String created = t.getDateCreated() != null ? sdf.format(t.getDateCreated()) : "";

                int resolveHours = t.getPriority() != null ? t.getPriority().getResolveHours() : 24;
                Date deadline = helpdeskBean.calculateDeadline(t.getDateCreated(), resolveHours);
                String deadlineStr = deadline != null ? sdf.format(deadline) : "";
                String slaStatus = helpdeskBean.getSlaStatus(t.getDateCreated(), resolveHours, t.getStatus());

                writer.println(String.join(",", id, title, requester, dept, priority, status, assignee, created, deadlineStr, slaStatus));
            }
        }
        writer.flush();
    }

    private String escapeCsv(String value) {
        if (value == null) return "\"\"";
        String clean = value.replace("\"", "\"\"");
        return "\"" + clean + "\"";
    }
}
