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

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">SD</div>
            <div class="brand-text">Service Desk</div>
        </div>
        <div class="sub-brand">Enterprise IT</div>

        <button class="btn-create">
            <i class="fas fa-plus"></i> Create Ticket
        </button>

        <ul class="nav-menu">
            <li><a href="#" class="nav-item active"><i class="fas fa-border-all"></i> Dashboard</a></li>
            <li><a href="#" class="nav-item"><i class="fas fa-ticket-alt"></i> Tickets</a></li>
        </ul>
    </aside>

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
                <i class="far fa-bell"></i>
                <i class="far fa-question-circle"></i>
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
                        <button class="filter-btn">Status: All Active <i class="fas fa-chevron-down"></i></button>
                        <button class="filter-btn">Priority: All <i class="fas fa-chevron-down"></i></button>
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
            let input = document.getElementById("ticketSearch").value.toLowerCase();
            let tbody = document.getElementById("ticketTableBody");
            let tr = tbody.getElementsByTagName("tr");

            for (let i = 0; i < tr.length; i++) {
                // Skip the "No active tickets found" row if present
                if (tr[i].getElementsByTagName("td").length === 1) continue;
                
                // Get all text content from the row
                let textContent = tr[i].textContent || tr[i].innerText;
                
                // Toggle display based on match
                if (textContent.toLowerCase().indexOf(input) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>
