<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - IT Helpdesk</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin.css">
</head>
<body>



    <!-- Main Content -->
    <main class="main-content">
        <!-- Topbar -->
        <header class="topbar">
            <div class="topbar-title">IT Helpdesk</div>
            
            <div class="search-bar">
                <i class="fas fa-search"></i>
                <input type="text" id="ticketSearch" placeholder="Search tickets..." onkeyup="filterTickets()">
            </div>

            <div class="topbar-actions">
                <div class="user-menu-container" style="position: relative;">
                    <div class="avatar" onclick="toggleUserMenu()" style="cursor: pointer;">
                        <!-- Display first letter of logged in user -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.userName}">
                                ${fn:substring(sessionScope.userName, 0, 1)}
                            </c:when>
                            <c:otherwise>
                                U
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="user-dropdown" id="adminUserDropdown">
                        <a href="Logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Content Area -->
        <div class="content-area">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Active Tickets</h2>
                    <div class="card-filters">
                        <select id="statusFilter" class="filter-btn" onchange="filterTickets()" style="padding-right: 20px;">
                            <option value="all">Status: All</option>
                            <option value="open">Status: Open</option>
                            <option value="in progress">Status: In Progress</option>
                            <option value="closed">Status: Closed</option>
                        </select>
                        <select id="priorityFilter" class="filter-btn" onchange="filterTickets()" style="padding-right: 20px;">
                            <option value="all">Priority: All</option>
                            <option value="low">Priority: Low</option>
                            <option value="medium">Priority: Medium</option>
                            <option value="high">Priority: High</option>
                            <option value="critical">Priority: Critical</option>
                        </select>
                    </div>
                </div>

                <div class="table-responsive">
                    <% request.setAttribute("tickets", request.getAttribute("ticketList")); %>
                    <jsp:include page="tickets-list.jsp" />
                </div>

                <div class="card-footer">
                    <c:choose>
                        <c:when test="${empty ticketList}">
                            Showing 0 of 0 tickets
                        </c:when>
                        <c:otherwise>
                            Showing 1-${fn:length(ticketList)} of ${fn:length(ticketList)} tickets
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="pagination">
                        <i class="fas fa-chevron-left"></i>
                        <span style="color: var(--text-main); font-weight: 500;">1</span>
                        <i class="fas fa-chevron-right"></i>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function toggleUserMenu() {
            document.getElementById("adminUserDropdown").classList.toggle("show");
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

        // Search Filter Function
        function filterTickets() {
            let searchInput = document.getElementById("ticketSearch") ? document.getElementById("ticketSearch").value.toLowerCase() : "";
            let statusSelect = document.getElementById("statusFilter") ? document.getElementById("statusFilter").value.toLowerCase() : "all";
            let prioritySelect = document.getElementById("priorityFilter") ? document.getElementById("priorityFilter").value.toLowerCase() : "all";
            
            let tbody = document.getElementById("ticketTableBody");
            if (!tbody) return;
            let tr = tbody.getElementsByTagName("tr");

            for (let i = 0; i < tr.length; i++) {
                if (tr[i].getElementsByTagName("td").length === 1) continue;
                
                let textContent = tr[i].textContent || tr[i].innerText;
                let priorityText = tr[i].getElementsByTagName("td")[2].innerText.toLowerCase();
                let statusText = tr[i].getElementsByTagName("td")[3].innerText.toLowerCase();
                
                let matchSearch = searchInput === "" || textContent.toLowerCase().indexOf(searchInput) > -1;
                let matchStatus = statusSelect === "all" || statusText.indexOf(statusSelect) > -1;
                let matchPriority = prioritySelect === "all" || priorityText.indexOf(prioritySelect) > -1;
                
                if (matchSearch && matchStatus && matchPriority) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>
