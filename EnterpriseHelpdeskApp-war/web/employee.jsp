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



    <!-- MAIN CONTENT -->
    <div class="main-content">

        <!-- TOPBAR -->
        <div class="topbar">

            <div class="topbar-title">
                IT Helpdesk
            </div>

            <div class="topbar-actions">
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

                    <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">

                        <h2>My Recent Tickets</h2>

                        <div class="card-filters" style="display: flex; gap: 12px; align-items: center;">
                            <select id="statusFilter" class="filter-btn" onchange="filterTickets()" style="padding: 6px 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 13px;">
                                <option value="all">Status: All</option>
                                <option value="open">Status: Open</option>
                                <option value="in progress">Status: In Progress</option>
                                <option value="closed">Status: Closed</option>
                            </select>
                            <select id="priorityFilter" class="filter-btn" onchange="filterTickets()" style="padding: 6px 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 13px;">
                                <option value="all">Priority: All</option>
                                <option value="low">Priority: Low</option>
                                <option value="medium">Priority: Medium</option>
                                <option value="high">Priority: High</option>
                                <option value="critical">Priority: Critical</option>
                            </select>
                            
                            <a href="#" class="view-all-link" id="viewAllBtn" onclick="toggleViewAll(event)" style="margin-left: 12px; font-size: 14px; color: #4338ca; font-weight: 600; text-decoration: none;">
                                View All &rarr;
                            </a>
                        </div>

                    </div>

                    <div class="table-responsive">
                        <jsp:include page="tickets-list.jsp" />
                    </div>

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

        let isViewAll = false;

        function toggleViewAll(e) {
            e.preventDefault();
            isViewAll = !isViewAll;
            let btn = document.getElementById('viewAllBtn');
            btn.innerHTML = isViewAll ? "Show Less &larr;" : "View All &rarr;";
            filterTickets();
        }

        function filterTickets() {
            let statusSelect = document.getElementById("statusFilter").value.toLowerCase();
            let prioritySelect = document.getElementById("priorityFilter").value.toLowerCase();
            
            let tbody = document.getElementById("ticketTableBody");
            if (!tbody) return;
            let tr = tbody.getElementsByTagName("tr");

            let visibleCount = 0;

            for (let i = 0; i < tr.length; i++) {
                if (tr[i].getElementsByTagName("td").length === 1) continue;
                
                let priorityText = tr[i].getElementsByTagName("td")[2].innerText.toLowerCase();
                let statusText = tr[i].getElementsByTagName("td")[3].innerText.toLowerCase();
                
                let matchStatus = statusSelect === "all" || statusText.indexOf(statusSelect) > -1;
                let matchPriority = prioritySelect === "all" || priorityText.indexOf(prioritySelect) > -1;
                
                if (matchStatus && matchPriority) {
                    // Apply 'View All' limit (show max 5 if not View All)
                    if (!isViewAll && visibleCount >= 5) {
                        tr[i].style.display = "none";
                    } else {
                        tr[i].style.display = "";
                        visibleCount++;
                    }
                } else {
                    tr[i].style.display = "none";
                }
            }
        }

        // Run initially to apply the 5 item limit
        window.onload = function() {
            filterTickets();
        };
    </script>
</body>
</html>