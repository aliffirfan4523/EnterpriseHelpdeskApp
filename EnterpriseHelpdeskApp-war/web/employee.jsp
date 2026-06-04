<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.helpdesk.domain.core.Ticket"%>

<%
    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");

    if (tickets == null) {
        tickets = new ArrayList<Ticket>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Dashboard</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/style/employee.css">
</head>

<body>

    <!-- SIDEBAR -->
    <div class="sidebar">

        <div class="brand">
            <h2>Service Desk</h2>
            <p>Enterprise IT</p>
        </div>

        <ul class="nav-menu">
            <li>
                <a href="#" class="active">Dashboard</a>
            </li>

            <li>
                <a href="#">Tickets</a>
            </li>

            <li>
                <a href="#">Settings</a>
            </li>
        </ul>

        <div class="sidebar-footer">
            <button class="create-ticket-btn">
                + Create Ticket
            </button>
        </div>

    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">

        <!-- TOPBAR -->
        <div class="topbar">

            <div class="topbar-title">
                IT Helpdesk
            </div>

            <div class="topbar-actions">

                <div class="topbar-icon-btn">
                    🔔
                </div>

                <div class="topbar-icon-btn">
                    ?
                </div>

                <div class="avatar">
                    E
                </div>

            </div>

        </div>

        <!-- CONTENT -->
        <div class="content-area">

            <div class="header">

                <h1>Good Morning.</h1>

                <p>
                    Here is an overview of your IT requests.
                </p>

            </div>

            <div class="dashboard-grid">

                <!-- NEW TICKET -->
                <div class="card">

                    <h2>New Ticket</h2>

                    <form action="SubmitTicketServlet" method="post">

                        <div class="form-group">

                            <label>Issue Title</label>

                            <input
                                type="text"
                                name="title"
                                placeholder="Briefly describe the issue..."
                                required>

                        </div>

                        <div class="form-group">

                            <label>Priority Level</label>

                            <select name="priorityId">

                                <option value="1">
                                    Low - General Inquiry
                                </option>

                                <option value="2">
                                    Medium - Normal Issue
                                </option>

                                <option value="3">
                                    High - Critical Issue
                                </option>

                            </select>

                        </div>

                        <div class="form-group">

                            <label>Description</label>

                            <textarea
                                name="description"
                                rows="7"
                                placeholder="Provide detailed steps to reproduce the issue..."
                                required></textarea>

                        </div>

                        <button type="submit" class="submit-btn">
                            Submit Request
                        </button>

                    </form>

                </div>

                <!-- RECENT TICKETS -->
                <div class="card">

                    <div class="card-header">

                        <h2>My Recent Tickets</h2>

                        <a href="#" class="view-all-link">
                            View All →
                        </a>

                    </div>

                    <table class="ticket-table">

                        <thead>

                            <tr>
                                <th>Ticket ID</th>
                                <th>Title</th>
                                <th>Status</th>
                                <th>Date Submitted</th>
                            </tr>

                        </thead>

                        <tbody>

                            <%
                                for (Ticket ticket : tickets) {
                            %>

                            <tr>

                                <td class="ticket-id">
                                    #INC-<%= ticket.getId()%>
                                </td>

                                <td class="ticket-title">
                                    <%= ticket.getTitle()%>
                                </td>

                                <td>

                                    <%
                                        String status = ticket.getStatus();

                                        if ("Open".equalsIgnoreCase(status)) {
                                    %>

                                    <span class="badge badge-open">
                                        OPEN
                                    </span>

                                    <%
                                    } else if ("In Progress".equalsIgnoreCase(status)) {
                                    %>

                                    <span class="badge badge-progress">
                                        IN PROGRESS
                                    </span>

                                    <%
                                    } else {
                                    %>

                                    <span class="badge badge-closed">
                                        <%= status%>
                                    </span>

                                    <%
                                        }
                                    %>

                                </td>

                                <td class="ticket-date">

                                    <%
                                        if (ticket.getDateCreated() != null) {
                                            out.print(ticket.getDateCreated());
                                        }
                                    %>

                                </td>

                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

    </div>

</body>
</html>