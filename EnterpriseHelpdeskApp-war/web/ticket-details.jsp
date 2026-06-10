<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="com.helpdesk.domain.core.Ticket"%>
<%
    Ticket ticket = (Ticket) request.getAttribute("ticket");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ticket Details - #INC-${ticket.id}</title>
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Using admin.css for the sidebar and topbar base styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin.css">
    <!-- Specific styles for the ticket details layout -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/ticket-details.css">
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">SD</div>
            <div class="brand-text">Service Desk</div>
        </div>
        <div class="sub-brand">Enterprise IT</div>

        <ul class="nav-menu" style="margin-top: 32px;">
            <li><a href="${pageContext.request.contextPath}/AdminDashboard" class="nav-item"><i class="fas fa-border-all"></i> Dashboard</a></li>
            <li><a href="#" class="nav-item active"><i class="fas fa-ticket-alt"></i> Tickets</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Topbar -->
        <header class="topbar">
            <div class="topbar-title">IT Helpdesk</div>
            
            <div class="search-bar">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search tickets, articles...">
            </div>

            <div class="topbar-actions">
                <i class="far fa-bell"></i>
                <i class="far fa-question-circle"></i>
                <div class="user-menu-container" style="position: relative;">
                    <div class="avatar" onclick="toggleUserMenu()" style="cursor: pointer;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.name}">
                                ${fn:substring(sessionScope.name, 0, 1)}
                            </c:when>
                            <c:otherwise>U</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="user-dropdown" id="userDropdown">
                        <a href="${pageContext.request.contextPath}/Logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Content Area -->
        <div class="content-area ticket-details-layout">
            <c:if test="${not empty ticket}">
                <!-- Left Panel -->
                <div class="ticket-info-panel card">
                    <div class="panel-header">
                        <span class="ticket-id">INC-${ticket.id}</span>
                        <c:set var="pri" value="${fn:toLowerCase(ticket.priority.levelName)}" />
                        <span class="badge ${pri == 'critical' || pri == 'high' ? 'high' : 'medium'}">${ticket.priority.levelName} Priority</span>
                    </div>
                    
                    <h1 class="ticket-title-large">${ticket.title}</h1>
                    
                    <div class="requester-profile">
                        <div class="avatar large">${fn:substring(ticket.user.name, 0, 1)}</div>
                        <div class="requester-info">
                            <div class="requester-name">${ticket.user.name}</div>
                            <div class="requester-role">${not empty ticket.user.department ? ticket.user.department.name : 'User'}</div>
                        </div>
                    </div>
                    
                    <div class="metadata-grid">
                        <div class="meta-item">
                            <div class="meta-label">Ticket Date</div>
                            <div class="meta-value"><fmt:formatDate value="${ticket.dateCreated}" pattern="M/d/yyyy"/></div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">Assignee</div>
                            <div class="meta-value">David Chen</div>
                        </div>
                    </div>
                    
                    <div class="tags-section">
                        <div class="meta-label">Tags</div>
                        <div class="tags-list">
                            <c:choose>
                                <c:when test="${not empty ticket.tags}">
                                    <c:forEach var="tag" items="${ticket.tags}">
                                        <span class="tag-badge">${tag.name}</span>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="tag-badge">None</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="description-card">
                        <div class="meta-label">Original Description</div>
                        <div class="description-text">
                            ${fn:replace(ticket.description, '\\n', '<br/>')}
                        </div>
                    </div>
                </div>

                <!-- Right Panel (Activity Thread) -->
                <div class="activity-thread-panel card">
                    <div class="thread-header">
                        <h2><i class="far fa-comments"></i> Activity Thread</h2>
                        <button class="btn-internal-note">Internal Note</button>
                    </div>
                    
                    <div class="thread-content">
                        <div class="system-message">
                            <span>Ticket created via Portal - <fmt:formatDate value="${ticket.dateCreated}" pattern="MMM d, hh:mm a"/></span>
                        </div>
                        
                        <c:forEach var="comment" items="${ticket.comments}">
                            <c:choose>
                                <c:when test="${comment.user.id != sessionScope.userId}">
                                    <!-- Other User's Comment (Left) -->
                                    <div class="chat-message left">
                                        <div class="chat-avatar">${fn:substring(comment.user.name, 0, 1)}</div>
                                        <div class="chat-body">
                                            <div class="chat-header">
                                                <span class="chat-name">${comment.user.name}
                                                    <c:if test="${comment.user.role == 'Admin'}"><span class="role-badge">(IT)</span></c:if>
                                                </span>
                                                <span class="chat-time"><fmt:formatDate value="${comment.postedAt}" pattern="hh:mm a"/></span>
                                            </div>
                                            <div class="chat-bubble">
                                                ${fn:replace(comment.message, '\\n', '<br/>')}
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Current Logged-in User's Comment (Right) -->
                                    <div class="chat-message right">
                                        <div class="chat-body">
                                            <div class="chat-header">
                                                <span class="chat-time"><fmt:formatDate value="${comment.postedAt}" pattern="hh:mm a"/></span>
                                                <span class="chat-name">${comment.user.name}
                                                    <c:if test="${comment.user.role == 'Admin'}"><span class="role-badge">(IT)</span></c:if>
                                                </span>
                                            </div>
                                            <div class="chat-bubble highlight">
                                                ${fn:replace(comment.message, '\\n', '<br/>')}
                                            </div>
                                        </div>
                                        <div class="chat-avatar agent">${fn:substring(comment.user.name, 0, 1)}</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                    
                    <div class="thread-footer">
                        <form action="${pageContext.request.contextPath}/AddComment" method="POST" style="width: 100%;">
                            <input type="hidden" name="ticketId" value="${ticket.id}">
                            <div class="reply-box">
                                <textarea name="commentText" placeholder="Type a reply..." required></textarea>
                                <div class="reply-actions">
                                    <div class="action-icons">
                                        <i class="fas fa-paperclip"></i>
                                        <i class="far fa-list-alt"></i>
                                    </div>
                                    <button type="submit" class="btn-reply">Reply <i class="fas fa-paper-plane" style="margin-left: 4px;"></i></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </c:if>
            <c:if test="${empty ticket}">
                <div class="card" style="padding: 40px; text-align: center;">
                    <h2>Ticket not found</h2>
                    <a href="javascript:history.back()" style="display: inline-block; margin-top: 20px; color: var(--primary-dark);">Go Back</a>
                </div>
            </c:if>
        </div>
    </main>

    <script>
        function toggleUserMenu() {
            document.getElementById("userDropdown").classList.toggle("show");
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
        
        // Auto scroll thread to bottom
        window.onload = function() {
            var thread = document.querySelector('.thread-content');
            if (thread) {
                thread.scrollTop = thread.scrollHeight;
            }
        }
    </script>
</body>
</html>
