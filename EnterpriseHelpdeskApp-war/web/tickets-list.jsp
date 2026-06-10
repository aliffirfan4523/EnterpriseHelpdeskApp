<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.helpdesk.domain.core.Ticket"%>
<%
    // Ensure "tickets" is set in the request scope before including this file
    List<Ticket> ticketsList = (List<Ticket>) request.getAttribute("tickets");
    if (ticketsList != null && !ticketsList.isEmpty()) {
%>
<table class="ticket-table">
    <thead>
        <tr>
            <th>Ticket ID</th>
            <th>Title</th>
            <th>Priority</th>
            <th>Status</th>
            <th>Date Submitted</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody id="ticketTableBody">
        <% for (Ticket t : ticketsList) { %>
        <tr>
            <td class="ticket-id">#INC-<%= t.getId() %></td>
            <td class="ticket-title"><%= t.getTitle() %></td>
            <td class="ticket-priority"><%= t.getPriority() != null ? t.getPriority().getLevelName() : "None" %></td>
            <td>
                <% if ("Open".equalsIgnoreCase(t.getStatus())) { %>
                    <span class="badge badge-open">OPEN</span>
                <% } else if ("In Progress".equalsIgnoreCase(t.getStatus())) { %>
                    <span class="badge badge-progress">IN PROGRESS</span>
                <% } else { %>
                    <span class="badge badge-closed"><%= t.getStatus() %></span>
                <% } %>
            </td>
            <td class="ticket-date"><%= t.getDateCreated() != null ? t.getDateCreated() : "" %></td>
            <td>
                <a href="${pageContext.request.contextPath}/ViewTicket?ticketId=<%= t.getId() %>" style="color: #0056b3; text-decoration: none; font-weight: bold;">View</a>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
<% } else { %>
    <p style="padding: 20px; color: #666; text-align: center; font-style: italic;">No tickets available.</p>
<% } %>
