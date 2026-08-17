<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="com.helpdesk.domain.core.Ticket"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>#INC-${ticket.id} - ${ticket.title} | Enterprise Helpdesk</title>
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/ticket-details.css?v=2.0">
</head>
<body class="workbench-body">

    <!-- Topbar Navigation -->
    <header class="app-topbar" style="border-bottom: 1px solid var(--border-color); background:#ffffff;">
        <div class="topbar-left">
            <c:set var="backUrl" value="${sessionScope.role == 'Admin' ? '/AdminDashboard' : '/EmployeeDashboard'}" />
            <a href="${pageContext.request.contextPath}${backUrl}" class="btn-header-action btn-outline" style="padding: 6px 12px; font-size: 13px;">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            <div class="ticket-id-breadcrumbs">
                <span class="ticket-mono-id">#INC-${ticket.id}</span>
                <span>/</span>
                <span style="font-weight: 600; color: var(--text-primary); max-width: 400px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                    ${ticket.title}
                </span>
            </div>
        </div>

        <div class="topbar-right">
            <c:set var="statusLower" value="${fn:toLowerCase(ticket.status)}" />
            <c:choose>
                <c:when test="${statusLower == 'open'}">
                    <span class="badge badge-status-open"><i class="fas fa-dot-circle"></i> Open</span>
                </c:when>
                <c:when test="${statusLower == 'in progress'}">
                    <span class="badge badge-status-progress"><i class="fas fa-spinner fa-spin"></i> In Progress</span>
                </c:when>
                <c:otherwise>
                    <span class="badge badge-status-closed"><i class="fas fa-check-circle"></i> ${ticket.status}</span>
                </c:otherwise>
            </c:choose>

            <a href="javascript:window.print()" class="btn-header-action btn-outline" title="Print Ticket Summary">
                <i class="fas fa-print"></i>
            </a>

            <a href="${pageContext.request.contextPath}/Logout" class="btn-header-action btn-outline" title="Sign Out">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </header>

    <!-- Workbench 2-Pane Split -->
    <div class="workbench-layout">
        
        <!-- Left Main Panel: Discussion & Description -->
        <main class="workbench-main">
            <!-- Header -->
            <div class="workbench-header">
                <div class="ticket-header-meta">
                    <h1 class="ticket-main-title">${ticket.title}</h1>
                    <div style="display: flex; align-items: center; gap: 12px; font-size: 12px; color: var(--text-muted);">
                        <span><i class="far fa-calendar-alt"></i> Created on <fmt:formatDate value="${ticket.dateCreated}" pattern="MMM d, yyyy 'at' h:mm a"/></span>
                        <span>&bull;</span>
                        <span><i class="far fa-user"></i> Reported by <strong>${ticket.user.name}</strong></span>
                        <c:if test="${not empty ticket.user.department}">
                            <span>(${ticket.user.department.name})</span>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Scrollable Discussion Stream -->
            <div class="workbench-stream" id="discussionStream">
                
                <!-- Original Description Card -->
                <div class="description-banner">
                    <div class="description-header">
                        <div class="description-title">
                            <i class="fas fa-align-left" style="color: var(--primary);"></i>
                            <span>Incident Description</span>
                        </div>
                        <span style="font-size: 11px; color: var(--text-muted); font-weight: 500;">Original Submission</span>
                    </div>
                    <div class="description-body">${ticket.description}</div>
                </div>

                <!-- Timeline Separator -->
                <div class="system-event">
                    <div class="system-event-line"></div>
                    <div class="system-event-text">
                        <i class="fas fa-history"></i> Ticket Opened via Portal &bull; <fmt:formatDate value="${ticket.dateCreated}" pattern="h:mm a"/>
                    </div>
                    <div class="system-event-line"></div>
                </div>

                <!-- Comments & Internal Notes -->
                <c:forEach var="c" items="${ticket.comments}">
                    <!-- Only show internal notes to Admins -->
                    <c:if test="${!c.isInternal || sessionScope.role == 'Admin'}">
                        <div class="comment-card ${c.isInternal ? 'internal-note' : ''}">
                            <div class="comment-avatar ${c.user.role == 'Admin' ? 'admin-avatar' : ''}">
                                ${fn:toUpperCase(fn:substring(c.user.name, 0, 1))}
                            </div>
                            
                            <div class="comment-content-box">
                                <div class="comment-header">
                                    <div class="comment-author-group">
                                        <span class="comment-author-name">${c.user.name}</span>
                                        <c:choose>
                                            <c:when test="${c.user.role == 'Admin'}">
                                                <span class="role-pill it-staff">IT Specialist</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="role-pill requester">Employee</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${c.isInternal}">
                                            <span class="internal-note-badge">
                                                <i class="fas fa-lock"></i> Internal Note
                                            </span>
                                        </c:if>
                                    </div>
                                    <span class="comment-time">
                                        <fmt:formatDate value="${c.postedAt}" pattern="MMM d, h:mm a"/>
                                    </span>
                                </div>
                                <div class="comment-body">${c.message}</div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>

            </div>

            <!-- Reply Composer -->
            <div class="reply-composer-wrap">
                <form action="${pageContext.request.contextPath}/AddComment" method="POST" id="replyForm">
                    <input type="hidden" name="ticketId" value="${ticket.id}">
                    <input type="hidden" name="isInternal" id="isInternalInput" value="false">

                    <!-- Admin Tabs (Public Reply vs Internal Note) -->
                    <c:if test="${sessionScope.role == 'Admin'}">
                        <div class="reply-type-tabs">
                            <button type="button" class="reply-tab-btn active" id="tabPublic" onclick="setReplyMode('public')">
                                <i class="fas fa-comment"></i> Public Customer Reply
                            </button>
                            <button type="button" class="reply-tab-btn" id="tabInternal" onclick="setReplyMode('internal')">
                                <i class="fas fa-lock"></i> Internal Diagnostic Note
                            </button>
                        </div>
                    </c:if>

                    <div class="reply-input-container" id="replyContainer">
                        <textarea name="commentText" id="commentText" class="reply-textarea" placeholder="Type your response to the requester here..." required></textarea>
                        
                        <div class="reply-toolbar">
                            <div style="font-size: 12px; color: var(--text-muted);" id="replyHelpText">
                                <i class="fas fa-globe"></i> Visible to employee and IT team
                            </div>
                            <button type="submit" class="btn-send-reply" id="btnSubmitReply">
                                <span>Send Reply</span>
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>

        </main>

        <!-- Right Meta Sidebar -->
        <aside class="workbench-sidebar">
            
            <!-- SLA Target Card -->
            <div class="meta-card">
                <div class="meta-card-title">
                    <span>SLA Resolution Target</span>
                    <i class="fas fa-clock" style="color: var(--primary);"></i>
                </div>
                <div>
                    <div style="display: flex; align-items: baseline; justify-content: space-between; margin-bottom: 8px;">
                        <span style="font-size: 12px; color: var(--text-muted);">Deadline Status:</span>
                        <c:choose>
                            <c:when test="${slaStatus == 'BREACHED'}">
                                <span class="sla-badge breached"><i class="fas fa-exclamation-triangle"></i> SLA Breached</span>
                            </c:when>
                            <c:when test="${slaStatus == 'AT_RISK'}">
                                <span class="sla-badge at-risk"><i class="fas fa-hourglass-half"></i> At Risk</span>
                            </c:when>
                            <c:when test="${slaStatus == 'RESOLVED'}">
                                <span class="sla-badge resolved"><i class="fas fa-check"></i> Completed</span>
                            </c:when>
                            <c:otherwise>
                                <span class="sla-badge on-track"><i class="fas fa-shield-alt"></i> On Track</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="font-size: 18px; font-weight: 800; color: var(--text-primary); margin-bottom: 4px;">
                        ${slaRemaining}
                    </div>

                    <div style="font-size: 12px; color: var(--text-muted);">
                        Target: <fmt:formatDate value="${slaDeadline}" pattern="MMM d, yyyy h:mm a"/>
                    </div>
                </div>
            </div>

            <!-- Ticket Properties Card -->
            <div class="meta-card">
                <div class="meta-card-title">
                    <span>Incident Properties</span>
                    <i class="fas fa-sliders-h"></i>
                </div>

                <div class="meta-property-list">
                    
                    <!-- Status -->
                    <div class="meta-property-row">
                        <span class="meta-property-label">Incident Status</span>
                        <c:choose>
                            <c:when test="${sessionScope.role == 'Admin'}">
                                <form action="${pageContext.request.contextPath}/UpdateTicket" method="POST">
                                    <input type="hidden" name="ticketId" value="${ticket.id}">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <select name="status" class="meta-select" onchange="this.form.submit()">
                                        <option value="Open" ${ticket.status == 'Open' ? 'selected' : ''}>Open</option>
                                        <option value="In Progress" ${ticket.status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                                        <option value="Resolved" ${ticket.status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                                        <option value="Closed" ${ticket.status == 'Closed' ? 'selected' : ''}>Closed</option>
                                    </select>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div style="font-size: 14px; font-weight: 600;">${ticket.status}</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Priority -->
                    <div class="meta-property-row">
                        <span class="meta-property-label">Priority / Urgency</span>
                        <c:choose>
                            <c:when test="${sessionScope.role == 'Admin'}">
                                <form action="${pageContext.request.contextPath}/UpdateTicket" method="POST">
                                    <input type="hidden" name="ticketId" value="${ticket.id}">
                                    <input type="hidden" name="action" value="updatePriority">
                                    <select name="priorityId" class="meta-select" onchange="this.form.submit()">
                                        <c:forEach var="pri" items="${allPriorities}">
                                            <option value="${pri.id}" ${ticket.priority.id == pri.id ? 'selected' : ''}>
                                                ${pri.levelName} (${pri.resolveHours}h SLA)
                                            </option>
                                        </c:forEach>
                                    </select>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div style="font-size: 14px; font-weight: 600;">${ticket.priority.levelName} (${ticket.priority.resolveHours}h SLA)</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Assignee -->
                    <div class="meta-property-row">
                        <span class="meta-property-label">Assigned Technician</span>
                        <c:choose>
                            <c:when test="${sessionScope.role == 'Admin'}">
                                <form action="${pageContext.request.contextPath}/UpdateTicket" method="POST">
                                    <input type="hidden" name="ticketId" value="${ticket.id}">
                                    <input type="hidden" name="action" value="assignTicket">
                                    <select name="adminId" class="meta-select" onchange="this.form.submit()">
                                        <option value="0">Unassigned</option>
                                        <c:forEach var="adm" items="${allAdmins}">
                                            <option value="${adm.id}" ${ticket.assignedTo != null && ticket.assignedTo.id == adm.id ? 'selected' : ''}>
                                                ${adm.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div style="font-size: 14px; font-weight: 600;">
                                    ${ticket.assignedTo != null ? ticket.assignedTo.name : 'Unassigned (General Queue)'}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>

            <!-- Requester Card -->
            <div class="meta-card">
                <div class="meta-card-title">
                    <span>Requester Details</span>
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="requester-profile-row">
                    <div class="requester-avatar-lg">
                        ${fn:toUpperCase(fn:substring(ticket.user.name, 0, 1))}
                    </div>
                    <div class="requester-details">
                        <div class="name">${ticket.user.name}</div>
                        <div class="email">${ticket.user.email}</div>
                        <div class="dept">
                            <i class="fas fa-building" style="margin-right: 4px;"></i>
                            ${ticket.user.department != null ? ticket.user.department.name : 'General Staff'}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tags Section -->
            <div class="meta-card">
                <div class="meta-card-title">
                    <span>Incident Tags</span>
                    <i class="fas fa-tags"></i>
                </div>
                
                <div class="tag-chips-container">
                    <c:choose>
                        <c:when test="${not empty ticket.tags}">
                            <c:forEach var="tag" items="${ticket.tags}">
                                <span class="tag-chip">
                                    <span>${tag.name}</span>
                                    <c:if test="${sessionScope.role == 'Admin'}">
                                        <form action="${pageContext.request.contextPath}/UpdateTicket" method="POST" style="display:inline;">
                                            <input type="hidden" name="ticketId" value="${ticket.id}">
                                            <input type="hidden" name="action" value="removeTag">
                                            <input type="hidden" name="tagId" value="${tag.id}">
                                            <button type="submit" class="tag-remove-btn" title="Remove Tag">&times;</button>
                                        </form>
                                    </c:if>
                                </span>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <span style="font-size: 12px; color: var(--text-muted);">No tags assigned</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${sessionScope.role == 'Admin'}">
                    <div style="margin-top: 14px; display: flex; gap: 8px;">
                        <form action="${pageContext.request.contextPath}/UpdateTicket" method="POST" style="display: flex; gap: 6px; width: 100%;">
                            <input type="hidden" name="ticketId" value="${ticket.id}">
                            <input type="hidden" name="action" value="createTag">
                            <input type="text" name="newTagName" placeholder="+ Add tag..." class="form-control no-icon" style="padding: 6px 10px; font-size: 12px;" required>
                            <button type="submit" class="btn-header-action btn-outline" style="padding: 6px 10px; font-size: 12px;">Add</button>
                        </form>
                    </div>
                </c:if>
            </div>

            <!-- CSAT Rating Card (Employee - for resolved/closed tickets) -->
            <c:set var="statusLowerSide" value="${fn:toLowerCase(ticket.status)}" />
            <c:if test="${(statusLowerSide == 'resolved' || statusLowerSide == 'closed') && sessionScope.role != 'Admin'}">
                <div class="meta-card" style="border-color: #fef3c7;">
                    <div class="meta-card-title" style="color: #d97706;">
                        <span>Rate This Support</span>
                        <i class="fas fa-star"></i>
                    </div>

                    <c:choose>
                        <c:when test="${not empty ticketRating}">
                            <!-- Already rated - show existing -->
                            <div style="text-align: center; padding: 8px 0;">
                                <div style="font-size: 24px; font-weight: 800; color: #d97706; margin-bottom: 4px;">
                                    ${ticketRating.rating}/5
                                </div>
                                <div style="font-size: 22px; color: #fbbf24; letter-spacing: 2px; margin-bottom: 10px;">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${star <= ticketRating.rating}">&#9733;</c:when>
                                            <c:otherwise>&#9734;</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <div style="font-size: 12px; color: var(--text-muted);">
                                    Thank you for your feedback!
                                </div>
                                <c:if test="${not empty ticketRating.feedback}">
                                    <div style="font-size: 12px; color: var(--text-secondary); margin-top: 8px; font-style: italic; padding: 8px; background: #fffbeb; border-radius: 6px; text-align: left;">
                                        "${ticketRating.feedback}"
                                    </div>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Rating form -->
                            <c:if test="${param.rated == 'true'}">
                                <div style="background:#ecfdf5; border:1px solid #a7f3d0; color:#065f46; padding:8px 12px; border-radius:8px; font-size:12px; font-weight:600; margin-bottom:12px;">
                                    <i class="fas fa-check-circle"></i> Rating submitted. Thank you!
                                </div>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/RateTicket" method="POST">
                                <input type="hidden" name="ticketId" value="${ticket.id}">

                                <div style="margin-bottom: 12px;">
                                    <label style="font-size: 12px; color: var(--text-muted); display: block; margin-bottom: 8px; font-weight: 500;">How would you rate this support?</label>
                                    <div style="display: flex; gap: 6px; justify-content: center; margin-bottom: 12px;">
                                        <c:forEach begin="1" end="5" var="star">
                                            <label style="cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 2px;">
                                                <input type="radio" name="rating" value="${star}" style="display:none;"
                                                       onchange="updateStarDisplay(${star})"
                                                       ${star == 5 ? 'checked' : ''}>
                                                <span id="star-${star}" style="font-size: 24px; color: #fbbf24; transition: transform 0.1s ease; cursor: pointer;"
                                                      onclick="selectStar(${star})">&#9733;</span>
                                                <span style="font-size: 10px; color: var(--text-muted);">${star}</span>
                                            </label>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <textarea name="feedback" class="form-control no-icon" rows="2"
                                              placeholder="Optional: Leave a comment about this support experience..."
                                              style="font-size: 12px; resize: none;"></textarea>
                                </div>

                                <button type="submit" class="btn-header-action btn-accent" style="width: 100%; justify-content: center; font-size: 12px;">
                                    <i class="fas fa-paper-plane"></i> Submit Rating
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- Admin Danger Zone -->
            <c:if test="${sessionScope.role == 'Admin'}">
                <div class="meta-card" style="border-color: #fee2e2;">
                    <div class="meta-card-title" style="color: #dc2626;">
                        <span>Danger Zone</span>
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <form action="${pageContext.request.contextPath}/UpdateTicket" method="POST" onsubmit="return confirm('Are you sure you want to permanently delete this ticket and all its comments?');">
                        <input type="hidden" name="ticketId" value="${ticket.id}">
                        <input type="hidden" name="action" value="deleteTicket">
                        <button type="submit" class="btn-sidebar-danger">
                            <i class="fas fa-trash-alt"></i> Delete Incident
                        </button>
                    </form>
                </div>
            </c:if>



        </aside>

    </div>

    <!-- Client-side script for Reply Composer & auto-scroll -->
    <script>
        function setReplyMode(mode) {
            let tabPublic = document.getElementById('tabPublic');
            let tabInternal = document.getElementById('tabInternal');
            let container = document.getElementById('replyContainer');
            let textarea = document.getElementById('commentText');
            let hiddenInput = document.getElementById('isInternalInput');
            let btnSubmit = document.getElementById('btnSubmitReply');
            let helpText = document.getElementById('replyHelpText');

            if (mode === 'internal') {
                tabPublic.classList.remove('active');
                tabInternal.classList.add('internal-active');
                container.classList.add('internal-mode');
                hiddenInput.value = "true";
                textarea.placeholder = "Write an internal diagnostic note (only visible to IT Support)...";
                btnSubmit.classList.add('btn-internal-send');
                btnSubmit.innerHTML = '<span>Save Internal Note</span> <i class="fas fa-lock"></i>';
                helpText.innerHTML = '<i class="fas fa-lock" style="color:#d97706;"></i> <strong>Private</strong> - Visible only to IT personnel';
            } else {
                tabInternal.classList.remove('internal-active');
                tabPublic.classList.add('active');
                container.classList.remove('internal-mode');
                hiddenInput.value = "false";
                textarea.placeholder = "Type your response to the requester here...";
                btnSubmit.classList.remove('btn-internal-send');
                btnSubmit.innerHTML = '<span>Send Reply</span> <i class="fas fa-paper-plane"></i>';
                helpText.innerHTML = '<i class="fas fa-globe"></i> Visible to employee and IT team';
            }
        }

        // Auto scroll to bottom of stream on load
        window.onload = function() {
            let stream = document.getElementById('discussionStream');
            if (stream) {
                stream.scrollTop = stream.scrollHeight;
            }
        };

        // CSAT Star Rating interaction
        function selectStar(rating) {
            let radios = document.querySelectorAll('input[name="rating"]');
            radios.forEach(r => {
                if (parseInt(r.value) === rating) r.checked = true;
            });
            updateStarDisplay(rating);
        }

        function updateStarDisplay(rating) {
            for (let i = 1; i <= 5; i++) {
                let star = document.getElementById('star-' + i);
                if (star) {
                    if (i <= rating) {
                        star.style.color = '#f59e0b';
                        star.style.transform = 'scale(1.2)';
                    } else {
                        star.style.color = '#d1d5db';
                        star.style.transform = 'scale(1)';
                    }
                }
            }
        }
    </script>
</body>
</html>
