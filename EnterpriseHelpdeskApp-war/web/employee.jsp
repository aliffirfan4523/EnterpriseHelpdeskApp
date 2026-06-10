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
        </ul>

        <%--<div class="sidebar-footer">
            <button class="create-ticket-btn">
                + Create Ticket
            </button>
        </div>--%>

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

                <div class="user-menu-container" style="position: relative;">
                    <div class="avatar" onclick="toggleUserMenu()">
                        <%
                            String userName = (String) session.getAttribute("name");
                            String initial = (userName != null && !userName.isEmpty()) ? userName.substring(0, 1).toUpperCase() : "E";
                        %>
                        <%= initial %>
                    </div>
                    <div class="user-dropdown" id="employeeUserDropdown">
                        <a href="Logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
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

                    <form action="SubmitTicket" method="post">

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

                    <jsp:include page="tickets-list.jsp" />

                </div>

            </div>

        </div>

    </div>

    <script>
        function toggleUserMenu() {
            document.getElementById("employeeUserDropdown").classList.toggle("show");
        }
        
        window.onclick = function(event) {
            if (!event.target.matches('.avatar') && !event.target.closest('.avatar')) {
                var dropdowns = document.getElementsByClassName("user-dropdown");
                for (var i = 0; i < dropdowns.length; i++) {
                    var openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('show')) {
                        openDropdown.classList.remove('show');
                    }
                }
            }
        }
    </script>
</body>
</html>