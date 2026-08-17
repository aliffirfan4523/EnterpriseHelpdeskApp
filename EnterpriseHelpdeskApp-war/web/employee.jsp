<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Service Portal - Enterprise Helpdesk</title>
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/employee.css?v=2.0">
</head>
<body class="employee-body">

    <!-- Sticky Navbar -->
    <header class="portal-navbar">
        <a href="${pageContext.request.contextPath}/EmployeeDashboard" class="portal-brand">
            <div class="portal-logo-badge">
                <i class="fas fa-headset"></i>
            </div>
            <div class="portal-title">Enterprise Helpdesk</div>
        </a>

        <div class="portal-nav-actions">
            <a href="${pageContext.request.contextPath}/KnowledgeBase" class="btn-header-action btn-outline" style="padding: 6px 14px; font-size: 12px;">
                <i class="fas fa-book-open"></i> Knowledge Base
            </a>
            <a href="${pageContext.request.contextPath}/ExportTickets" class="btn-header-action btn-outline" style="padding: 6px 14px; font-size: 12px;">
                <i class="fas fa-download"></i> My Tickets (CSV)
            </a>
            
            <div class="user-menu-container">
                <div class="user-profile-btn" onclick="toggleEmployeeMenu()">
                    <div class="user-avatar-circle">
                        <c:choose>
                            <c:when test="${not empty sessionScope.name}">
                                ${fn:toUpperCase(fn:substring(sessionScope.name, 0, 1))}
                            </c:when>
                            <c:otherwise>E</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="user-name-text">${not empty sessionScope.name ? sessionScope.name : 'Employee'}</span>
                    <i class="fas fa-chevron-down" style="font-size: 10px; color: var(--text-muted);"></i>
                </div>

                <div class="user-dropdown" id="employeeUserDropdown">
                    <div style="padding: 10px 14px; border-bottom: 1px solid var(--border-color); font-size: 12px; color: var(--text-muted);">
                        Signed in as <strong>${sessionScope.email}</strong>
                    </div>
                    <a href="${pageContext.request.contextPath}/Logout" class="user-dropdown-item danger">
                        <i class="fas fa-sign-out-alt"></i> Sign Out
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Hero Banner -->
    <section class="portal-hero">
        <div class="hero-inner">
            <div class="hero-tag">
                <i class="fas fa-sparkles"></i> 24/7 IT Support Service
            </div>
            <h1 class="hero-title">
                Welcome back, ${not empty sessionScope.name ? sessionScope.name : 'Colleague'}.
            </h1>
            <p class="hero-subtitle">
                How can the IT Helpdesk team support your workflow today?
            </p>
            <div class="hero-actions-row">
                <a href="#newRequestCard" class="btn-hero-action btn-primary-hero">
                    <i class="fas fa-plus"></i> Submit New Request
                </a>
                <a href="#myRequestsSection" class="btn-hero-action btn-secondary-hero">
                    <i class="fas fa-list-check"></i> Track My Incidents
                </a>
            </div>
        </div>
    </section>

    <!-- Main Container -->
    <main class="portal-container">

        <!-- Toast Notifications -->
        <c:if test="${param.created == 'true'}">
            <div style="background:#ecfdf5; border:1px solid #a7f3d0; color:#065f46; padding:14px 20px; border-radius:12px; font-size:14px; font-weight:600; display:flex; align-items:center; gap:12px; box-shadow: var(--shadow-sm);">
                <i class="fas fa-check-circle" style="font-size: 18px;"></i> 
                <span>Your request has been submitted successfully! An IT specialist has been notified.</span>
            </div>
        </c:if>

        <!-- KPI Metrics Grid -->
        <div class="portal-stats-grid">
            <div class="portal-stat-card">
                <div class="stat-content">
                    <div class="stat-label">Total Requests</div>
                    <div class="stat-number">${not empty userStats ? userStats.total : fn:length(tickets)}</div>
                </div>
                <div class="stat-icon blue"><i class="fas fa-ticket-alt"></i></div>
            </div>

            <div class="portal-stat-card">
                <div class="stat-content">
                    <div class="stat-label">Under Review / Open</div>
                    <div class="stat-number">${not empty userStats ? userStats.open : 0}</div>
                </div>
                <div class="stat-icon emerald"><i class="fas fa-hourglass-start"></i></div>
            </div>

            <div class="portal-stat-card">
                <div class="stat-content">
                    <div class="stat-label">In Progress</div>
                    <div class="stat-number">${not empty userStats ? userStats.inProgress : 0}</div>
                </div>
                <div class="stat-icon amber"><i class="fas fa-wrench"></i></div>
            </div>

            <div class="portal-stat-card">
                <div class="stat-content">
                    <div class="stat-label">Resolved</div>
                    <div class="stat-number">${not empty userStats ? userStats.resolved : 0}</div>
                </div>
                <div class="stat-icon slate"><i class="fas fa-check-double"></i></div>
            </div>
        </div>

        <!-- 2-Column Portal Layout -->
        <div class="portal-layout-grid">
            
            <!-- Left Side: New Request Form & FAQ -->
            <div style="display: flex; flex-direction: column; gap: 24px;">
                
                <!-- Submit Request Card -->
                <div class="service-card" id="newRequestCard">
                    <div class="service-card-header">
                        <h2><i class="fas fa-paper-plane" style="color:var(--primary); margin-right:8px;"></i> Raise a Request</h2>
                        <p>Need hardware, software, or account assistance? Let us know.</p>
                    </div>
                    <div class="service-card-body">
                        <form action="${pageContext.request.contextPath}/SubmitTicket" method="POST">
                            
                            <div class="form-field">
                                <label class="field-label" for="reqTitle">Issue Summary</label>
                                <input type="text" id="reqTitle" name="title" class="field-input" placeholder="e.g. Cannot access VPN client on macOS" required>
                            </div>

                            <div class="form-field">
                                <label class="field-label" for="reqPriority">Urgency / Priority</label>
                                <select id="reqPriority" name="priorityId" class="field-select" required>
                                    <c:forEach var="p" items="${priorities}">
                                        <option value="${p.id}" ${p.id == 2 ? 'selected' : ''}>
                                            ${p.levelName} (${p.resolveHours}h target resolution)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="field-hint">Select Critical only if work is completely blocked.</div>
                            </div>

                            <div class="form-field">
                                <label class="field-label" for="reqDesc">Detailed Description</label>
                                <textarea id="reqDesc" name="description" class="field-textarea" placeholder="Please describe the steps to reproduce the issue or specific error messages..." required></textarea>
                            </div>

                            <button type="submit" class="btn-submit-request">
                                <span>Submit IT Request</span>
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Self-Service Knowledge Base Accordion -->
                <div class="faq-card">
                    <div class="faq-title">
                        <i class="fas fa-lightbulb" style="color: #f59e0b;"></i> Quick Solutions & FAQs
                    </div>
                    
                    <div class="faq-item active" onclick="toggleFaq(this)">
                        <div class="faq-question">
                            <span>How do I reset my company password?</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Visit the self-service authentication portal or contact the helpdesk directly if locked out.
                        </div>
                    </div>

                    <div class="faq-item" onclick="toggleFaq(this)">
                        <div class="faq-question">
                            <span>How do I connect to the corporate VPN?</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Open Cisco AnyConnect or GlobalProtect on your laptop and authenticate using your Single Sign-On (SSO) credentials.
                        </div>
                    </div>

                    <div class="faq-item" onclick="toggleFaq(this)">
                        <div class="faq-question">
                            <span>What are standard SLA resolution times?</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Critical incidents are addressed within 4 hours. High priority within 8 hours. Standard requests within 24-48 hours.
                        </div>
                    </div>
                </div>

            </div>

            <!-- Right Side: My Requests List -->
            <div class="data-table-card" id="myRequestsSection">
                <div class="table-toolbar">
                    <div class="toolbar-title-group">
                        <h2 class="toolbar-title">My Recent Requests</h2>
                        <span class="toolbar-count-badge" id="employeeRowCount">${fn:length(tickets)} requests</span>
                    </div>

                    <div class="toolbar-filters">
                        <input type="text" id="employeeSearchInput" class="filter-select" placeholder="Filter requests..." onkeyup="filterEmployeeTable()" style="width: 180px;">
                        <select id="employeeStatusFilter" class="filter-select" onchange="filterEmployeeTable()">
                            <option value="all">Status: All</option>
                            <option value="open">Open</option>
                            <option value="in progress">In Progress</option>
                            <option value="closed">Resolved / Closed</option>
                        </select>
                    </div>
                </div>

                <div class="table-responsive">
                    <jsp:include page="tickets-list.jsp" />
                </div>

                <div class="table-footer">
                    <div>Click any request to view activity or reply to IT staff.</div>
                    <div style="font-size:12px; color:var(--text-muted);">Auto-refreshed</div>
                </div>
            </div>

        </div>

    </main>

    <!-- Interactive Script -->
    <script>
        function toggleEmployeeMenu() {
            document.getElementById('employeeUserDropdown').classList.toggle('show');
        }

        function toggleFaq(element) {
            element.classList.toggle('active');
        }

        window.onclick = function(event) {
            if (!event.target.closest('.user-menu-container')) {
                let dropdown = document.getElementById('employeeUserDropdown');
                if (dropdown && dropdown.classList.contains('show')) {
                    dropdown.classList.remove('show');
                }
            }
        };

        function filterEmployeeTable() {
            let search = document.getElementById('employeeSearchInput').value.toLowerCase().trim();
            let status = document.getElementById('employeeStatusFilter').value.toLowerCase();

            let tbody = document.getElementById('ticketTableBody');
            if (!tbody) return;
            let rows = tbody.getElementsByTagName('tr');

            let visibleCount = 0;

            for (let i = 0; i < rows.length; i++) {
                let row = rows[i];
                let rowStatus = (row.getAttribute('data-status') || '').toLowerCase();
                let rowText = row.innerText.toLowerCase();

                let matchSearch = (search === "" || rowText.indexOf(search) > -1);
                let matchStatus = (status === "all" || rowStatus.indexOf(status) > -1);

                if (matchSearch && matchStatus) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            }

            let countBadge = document.getElementById('employeeRowCount');
            if (countBadge) {
                countBadge.innerText = visibleCount + ' requests';
            }
        }
    </script>
</body>
</html>