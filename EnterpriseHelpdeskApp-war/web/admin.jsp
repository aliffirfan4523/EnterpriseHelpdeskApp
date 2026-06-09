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
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Requester</th>
                                <th>Title</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Assigned To</th>
                                <th>Tags</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="ticketTableBody">
                            <!-- Iterate over tickets passed from servlet -->
                            <c:forEach var="ticket" items="${ticketList}">
                                <tr>
                                    <td class="ticket-id">#INC-${ticket.id}</td>
                                    
                                    <td>
                                        <div class="requester">
                                            <div class="requester-initials">
                                                <!-- Attempt to get first 2 letters, safely -->
                                                ${fn:substring(ticket.user.name, 0, 2)}
                                            </div>
                                            <span>${ticket.user.name}</span>
                                        </div>
                                    </td>
                                    
                                    <td class="ticket-title">${ticket.title}</td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${fn:toLowerCase(ticket.priority.levelName) == 'high'}">
                                                <span class="badge high">High</span>
                                            </c:when>
                                            <c:when test="${fn:toLowerCase(ticket.priority.levelName) == 'critical'}">
                                                <span class="badge critical">Critical</span>
                                            </c:when>
                                            <c:when test="${fn:toLowerCase(ticket.priority.levelName) == 'low'}">
                                                <span class="badge low">Low</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge medium">${ticket.priority.levelName}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <div class="status">
                                            <c:choose>
                                                <c:when test="${fn:toLowerCase(ticket.status) == 'open'}">
                                                    <span class="status-dot open"></span>
                                                    Open
                                                </c:when>
                                                <c:when test="${fn:toLowerCase(ticket.status) == 'in progress'}">
                                                    <span class="status-dot in-progress"></span>
                                                    In Progress
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-dot closed"></span>
                                                    ${ticket.status}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    
                                    <!-- Display the user's department -->
                                    <td style="color: var(--text-muted);">
                                        <c:choose>
                                            <c:when test="${not empty ticket.user.department}">
                                                ${ticket.user.department.name}
                                            </c:when>
                                            <c:otherwise>
                                                Unassigned
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- Display Tags -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ticket.tags}">
                                                <c:forEach var="tag" items="${ticket.tags}">
                                                    <span class="badge" style="background-color: #e2e8f0; color: #475569; margin-right: 4px; font-weight: 500;">#${tag.name}</span>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted); font-size: 12px;">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <div class="actions">
                                            <i class="fas fa-exchange-alt" title="Change Status"></i>
                                            <i class="fas fa-tag" title="Edit Tags"></i>
                                            <a href="ViewTicket?ticketId=${ticket.id}" style="color: inherit; text-decoration: none;">
                                                <i class="far fa-eye" title="View Details"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <!-- Placeholder if list is empty -->
                            <c:if test="${empty ticketList}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        No active tickets found.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
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
