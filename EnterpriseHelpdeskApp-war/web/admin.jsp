<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT Operations Center - Enterprise Helpdesk</title>
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin.css?v=2.0">
</head>
<body class="admin-body">

    <!-- App Sidebar -->
    <aside class="app-sidebar">
        <div class="sidebar-header">
            <div class="brand-icon">
                <i class="fas fa-shield-alt"></i>
            </div>
            <div>
                <div class="brand-title">Helpdesk Admin</div>
                <div class="brand-subtitle">IT Operations Suite</div>
            </div>
        </div>

        <div class="sidebar-content">
            <!-- Main Navigation -->
            <div class="sidebar-nav-section">
                <div class="nav-section-label">Incident Management</div>
                <a href="#" class="nav-link active" onclick="setQuickFilter('all', event)">
                    <i class="fas fa-ticket-alt"></i>
                    <span>All Incidents</span>
                    <span class="nav-badge">${not empty stats ? stats.total : fn:length(ticketList)}</span>
                </a>
                <a href="#" class="nav-link" onclick="setQuickFilter('open', event)">
                    <i class="fas fa-inbox"></i>
                    <span>Open Queue</span>
                    <span class="nav-badge" style="background:#065f46; color:#a7f3d0;">${not empty stats ? stats.open : 0}</span>
                </a>
                <a href="#" class="nav-link" onclick="setQuickFilter('in progress', event)">
                    <i class="fas fa-spinner"></i>
                    <span>In Progress</span>
                    <span class="nav-badge" style="background:#1e40af; color:#bfdbfe;">${not empty stats ? stats.inProgress : 0}</span>
                </a>
                <a href="#" class="nav-link" onclick="setQuickFilter('critical', event)">
                    <i class="fas fa-radiation"></i>
                    <span>Critical SLA</span>
                    <span class="nav-badge" style="background:#991b1b; color:#fecaca;">${not empty stats ? stats.critical : 0}</span>
                </a>
                <a href="#" class="nav-link" onclick="setQuickFilter('closed', event)">
                    <i class="fas fa-check-circle"></i>
                    <span>Resolved Archive</span>
                </a>
            </div>

            <!-- Management Tools -->
            <div class="sidebar-nav-section">
                <div class="nav-section-label">Tools & Reports</div>
                <a href="${pageContext.request.contextPath}/KnowledgeBase" class="nav-link">
                    <i class="fas fa-book-open"></i>
                    <span>Knowledge Base</span>
                </a>
                <a href="#" class="nav-link" onclick="openUsersModal(); return false;">
                    <i class="fas fa-users-cog"></i>
                    <span>User Accounts</span>
                </a>
                <a href="${pageContext.request.contextPath}/ExportTickets" class="nav-link">
                    <i class="fas fa-file-csv"></i>
                    <span>Export Tickets (CSV)</span>
                </a>
                <a href="#" class="nav-link" onclick="openNewTicketModal(); return false;">
                    <i class="fas fa-plus-circle"></i>
                    <span>Log New Ticket</span>
                </a>
            </div>
        </div>

        <!-- Sidebar Footer -->
        <div class="sidebar-footer">
            <div class="user-snippet">
                <div class="avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.name}">
                            ${fn:toUpperCase(fn:substring(sessionScope.name, 0, 1))}
                        </c:when>
                        <c:otherwise>A</c:otherwise>
                    </c:choose>
                </div>
                <div class="info">
                    <div class="name">${not empty sessionScope.name ? sessionScope.name : 'IT Administrator'}</div>
                    <div class="role-tag">${not empty sessionScope.department ? sessionScope.department : 'IT Support'}</div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/Logout" class="logout-btn-icon" title="Sign Out">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </aside>

    <!-- Main Content Area -->
    <div class="main-content-wrapper">
        <!-- Topbar -->
        <header class="app-topbar">
            <div class="topbar-left">
                <h1 class="page-heading">IT Incident Operations</h1>
                <div class="topbar-search">
                    <i class="fas fa-search"></i>
                    <input type="text" id="globalTicketSearch" placeholder="Search by ID, keyword, requester..." onkeyup="filterTicketsTable()">
                </div>
            </div>

            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/ExportTickets" class="btn-header-action btn-outline">
                    <i class="fas fa-download"></i>
                    <span>Export CSV</span>
                </a>
                <button type="button" class="btn-header-action btn-accent" onclick="openNewTicketModal()">
                    <i class="fas fa-plus"></i>
                    <span>New Incident</span>
                </button>
            </div>
        </header>

        <!-- Content Area -->
        <main class="content-scrollable">
            
            <!-- Toast Notifications -->
            <c:if test="${param.created == 'true'}">
                <div style="background:#ecfdf5; border:1px solid #a7f3d0; color:#065f46; padding:12px 18px; border-radius:10px; font-size:13px; font-weight:600; display:flex; align-items:center; gap:10px;">
                    <i class="fas fa-check-circle"></i> Incident successfully created and added to the queue!
                </div>
            </c:if>
            <c:if test="${param.deleted == 'true'}">
                <div style="background:#ecfdf5; border:1px solid #a7f3d0; color:#065f46; padding:12px 18px; border-radius:10px; font-size:13px; font-weight:600; display:flex; align-items:center; gap:10px;">
                    <i class="fas fa-check-circle"></i> Incident has been permanently removed.
                </div>
            </c:if>

            <!-- KPI Metric Cards -->
            <div class="kpi-grid">
                <!-- Total Incidents -->
                <div class="kpi-card blue">
                    <div class="kpi-info">
                        <span class="kpi-label">Total Incidents</span>
                        <span class="kpi-value">${not empty stats ? stats.total : 0}</span>
                        <span class="kpi-trend" style="color: #4f46e5;">
                            <i class="fas fa-database"></i> All Recorded Tickets
                        </span>
                    </div>
                    <div class="kpi-icon-wrap">
                        <i class="fas fa-layer-group"></i>
                    </div>
                </div>

                <!-- Open Queue -->
                <div class="kpi-card emerald">
                    <div class="kpi-info">
                        <span class="kpi-label">Open / Unassigned</span>
                        <span class="kpi-value">${not empty stats ? stats.open : 0}</span>
                        <span class="kpi-trend" style="color: #059669;">
                            <i class="fas fa-bolt"></i> Action Required
                        </span>
                    </div>
                    <div class="kpi-icon-wrap">
                        <i class="fas fa-envelope-open-text"></i>
                    </div>
                </div>

                <!-- In Progress -->
                <div class="kpi-card amber">
                    <div class="kpi-info">
                        <span class="kpi-label">In Progress</span>
                        <span class="kpi-value">${not empty stats ? stats.inProgress : 0}</span>
                        <span class="kpi-trend" style="color: #d97706;">
                            <i class="fas fa-user-cog"></i> Under Active Work
                        </span>
                    </div>
                    <div class="kpi-icon-wrap">
                        <i class="fas fa-tasks"></i>
                    </div>
                </div>

                <!-- Critical Risk -->
                <div class="kpi-card rose">
                    <div class="kpi-info">
                        <span class="kpi-label">High / Critical Priority</span>
                        <span class="kpi-value">${not empty stats ? stats.critical : 0}</span>
                        <span class="kpi-trend" style="color: #dc2626;">
                            <i class="fas fa-exclamation-circle"></i> Strict SLA Target
                        </span>
                    </div>
                    <div class="kpi-icon-wrap">
                        <i class="fas fa-shield-virus"></i>
                    </div>
                </div>
            </div>

            <!-- Main Data Table Card -->
            <div class="data-table-card">
                <!-- Toolbar -->
                <div class="table-toolbar">
                    <div class="toolbar-title-group">
                        <h2 class="toolbar-title" id="activeFilterHeading">All Incidents</h2>
                        <span class="toolbar-count-badge" id="visibleRowCount">
                            ${fn:length(ticketList)} tickets
                        </span>
                    </div>

                    <div class="toolbar-filters">
                        <!-- Status Filter -->
                        <select id="statusFilter" class="filter-select" onchange="filterTicketsTable()">
                            <option value="all">Status: All</option>
                            <option value="open">Status: Open</option>
                            <option value="in progress">Status: In Progress</option>
                            <option value="closed">Status: Closed / Resolved</option>
                        </select>

                        <!-- Priority Filter -->
                        <select id="priorityFilter" class="filter-select" onchange="filterTicketsTable()">
                            <option value="all">Priority: All</option>
                            <option value="critical">Critical</option>
                            <option value="high">High</option>
                            <option value="medium">Medium</option>
                            <option value="low">Low</option>
                        </select>

                        <!-- Department Filter -->
                        <select id="deptFilter" class="filter-select" onchange="filterTicketsTable()">
                            <option value="all">Department: All</option>
                            <c:forEach var="d" items="${departments}">
                                <option value="${fn:toLowerCase(d.name)}">${d.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Table View -->
                <div class="table-responsive">
                    <jsp:include page="tickets-list.jsp" />
                </div>

                <!-- Footer -->
                <div class="table-footer">
                    <div>
                        Showing active incident records
                    </div>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <span style="font-size:12px; color:var(--text-muted);">Real-time SLA Monitoring Active</span>
                        <i class="fas fa-circle" style="font-size:8px; color:#10b981;"></i>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- Log New Ticket Modal Dialog -->
    <div id="newTicketModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h2><i class="fas fa-plus-circle" style="color:var(--primary); margin-right:8px;"></i> Log Support Incident</h2>
                <button type="button" class="modal-close-btn" onclick="closeNewTicketModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <form action="${pageContext.request.contextPath}/SubmitTicket" method="POST">
                <div class="modal-body">
                    <!-- Title -->
                    <div style="margin-bottom: 16px;">
                        <label style="display:block; font-size:13px; font-weight:600; margin-bottom:6px;">Issue Title / Summary</label>
                        <input type="text" name="title" class="form-control no-icon" placeholder="e.g. Core Database Replication Lag in Production" required>
                    </div>

                    <!-- Priority & Category -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 16px;">
                        <div>
                            <label style="display:block; font-size:13px; font-weight:600; margin-bottom:6px;">Priority Level</label>
                            <select name="priorityId" class="form-control no-icon" required>
                                <c:forEach var="p" items="${priorities}">
                                    <option value="${p.id}" ${p.id == 2 ? 'selected' : ''}>${p.levelName} (${p.resolveHours}h SLA)</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label style="display:block; font-size:13px; font-weight:600; margin-bottom:6px;">Initial Tag</label>
                            <select name="tagId" class="form-control no-icon">
                                <option value="">No Tag</option>
                                <c:forEach var="tg" items="${tags}">
                                    <option value="${tg.id}">${tg.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Description -->
                    <div style="margin-bottom: 16px;">
                        <label style="display:block; font-size:13px; font-weight:600; margin-bottom:6px;">Detailed Description & Steps</label>
                        <textarea name="description" class="form-control no-icon" rows="5" placeholder="Provide full diagnostic details, logs, or error codes..." required></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-header-action btn-outline" onclick="closeNewTicketModal()">Cancel</button>
                    <button type="submit" class="btn-header-action btn-accent">Submit Incident</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Client-Side Filtering & Interactive Script -->
    <script>
        function openNewTicketModal() {
            document.getElementById('newTicketModal').classList.add('active');
        }

        function closeNewTicketModal() {
            document.getElementById('newTicketModal').classList.remove('active');
        }

        window.onclick = function(event) {
            let modal = document.getElementById('newTicketModal');
            if (event.target === modal) {
                closeNewTicketModal();
            }
        };

        document.addEventListener('keydown', function(e) {
            if (e.key === "Escape") {
                closeNewTicketModal();
            }
        });

        function setQuickFilter(statusType, event) {
            if (event) {
                event.preventDefault();
                document.querySelectorAll('.app-sidebar .nav-link').forEach(link => link.classList.remove('active'));
                event.currentTarget.classList.add('active');
            }

            let statusSelect = document.getElementById('statusFilter');
            let priSelect = document.getElementById('priorityFilter');
            let heading = document.getElementById('activeFilterHeading');

            if (statusType === 'all') {
                statusSelect.value = 'all';
                priSelect.value = 'all';
                heading.innerText = 'All Incidents';
            } else if (statusType === 'open') {
                statusSelect.value = 'open';
                priSelect.value = 'all';
                heading.innerText = 'Open Queue';
            } else if (statusType === 'in progress') {
                statusSelect.value = 'in progress';
                priSelect.value = 'all';
                heading.innerText = 'In Progress Workload';
            } else if (statusType === 'critical') {
                statusSelect.value = 'all';
                priSelect.value = 'critical';
                heading.innerText = 'Critical SLA Incidents';
            } else if (statusType === 'closed') {
                statusSelect.value = 'closed';
                priSelect.value = 'all';
                heading.innerText = 'Resolved Archive';
            }

            filterTicketsTable();
        }

        function filterTicketsTable() {
            let search = document.getElementById('globalTicketSearch').value.toLowerCase().trim();
            let status = document.getElementById('statusFilter').value.toLowerCase();
            let priority = document.getElementById('priorityFilter').value.toLowerCase();
            let dept = document.getElementById('deptFilter').value.toLowerCase();

            let tbody = document.getElementById('ticketTableBody');
            if (!tbody) return;
            let rows = tbody.getElementsByTagName('tr');

            let visibleCount = 0;

            for (let i = 0; i < rows.length; i++) {
                let row = rows[i];
                let rowStatus = (row.getAttribute('data-status') || '').toLowerCase();
                let rowPri = (row.getAttribute('data-priority') || '').toLowerCase();
                let rowDept = (row.getAttribute('data-dept') || '').toLowerCase();
                let rowText = row.innerText.toLowerCase();

                let matchSearch = (search === "" || rowText.indexOf(search) > -1);
                let matchStatus = (status === "all" || rowStatus.indexOf(status) > -1);
                let matchPri = (priority === "all" || rowPri === priority);
                let matchDept = (dept === "all" || rowDept.indexOf(dept) > -1);

                if (matchSearch && matchStatus && matchPri && matchDept) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            }

            let countBadge = document.getElementById('visibleRowCount');
            if (countBadge) {
                countBadge.innerText = visibleCount + ' tickets';
            }
        }

        // User Management Modal functions & Live Search for 100+ Users
        function openUsersModal() {
            let modal = document.getElementById('usersModal');
            if (modal) {
                modal.style.display = 'flex';
                filterUsersTable();
            }
        }

        function closeUsersModal() {
            let modal = document.getElementById('usersModal');
            if (modal) modal.style.display = 'none';
        }

        function toggleResetForm(userId) {
            let form = document.getElementById('reset-form-' + userId);
            if (form) {
                form.style.display = (form.style.display === 'none' || form.style.display === '') ? 'block' : 'none';
            }
        }

        function togglePasswordVisibility(userId) {
            let input = document.getElementById('pass-input-' + userId);
            let icon = document.getElementById('pass-icon-' + userId);
            if (input && icon) {
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.className = 'fas fa-eye-slash';
                } else {
                    input.type = 'password';
                    icon.className = 'fas fa-eye';
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            let urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('userUpdated')) {
                openUsersModal();
            }
        });

        function filterUsersTable() {
            let search = (document.getElementById('userSearchInput').value || '').toLowerCase().trim();
            let roleFilter = (document.getElementById('userRoleFilter').value || '').toLowerCase();

            let tbody = document.getElementById('userTableBody');
            if (!tbody) return;
            let rows = tbody.getElementsByTagName('tr');
            let visibleCount = 0;

            for (let i = 0; i < rows.length; i++) {
                let row = rows[i];
                let userRole = (row.getAttribute('data-role') || '').toLowerCase();
                let text = row.innerText.toLowerCase();

                let matchSearch = (search === "" || text.indexOf(search) > -1);
                let matchRole = (roleFilter === "all" || userRole === roleFilter);

                if (matchSearch && matchRole) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            }

            let badge = document.getElementById('userCountBadge');
            if (badge) {
                badge.innerText = visibleCount + ' accounts';
            }
        }
    </script>

    <!-- Scalable User Accounts Management Modal -->
    <div id="usersModal" class="modal-overlay" style="display:none;">
        <div class="modal-card" style="max-width: 900px; width: 92%;">
            <div class="modal-header">
                <div style="display:flex; align-items:center; gap:10px;">
                    <h2><i class="fas fa-users-cog" style="color:var(--primary);"></i> User Directory Management</h2>
                    <span id="userCountBadge" class="nav-badge" style="background:#e0e7ff; color:#4338ca; font-size:12px; font-weight:600; padding:3px 10px; border-radius:12px;">${fn:length(allUsers)} accounts</span>
                </div>
                <button type="button" class="close-btn" onclick="closeUsersModal()"><i class="fas fa-times"></i></button>
            </div>
            
            <div class="modal-body" style="padding:20px;">
                <!-- Live Search & Filter Bar for 100+ Users -->
                <div style="display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:16px; flex-wrap:wrap;">
                    <div style="position:relative; flex:1; min-width:240px;">
                        <i class="fas fa-search" style="position:absolute; left:12px; top:50%; transform:translateY(-50%); color:var(--text-muted); font-size:13px;"></i>
                        <input type="text" id="userSearchInput" onkeyup="filterUsersTable()" class="form-control" placeholder="Search by name, email, or department..." style="padding-left:36px; height:38px; font-size:13px; border-radius:8px;">
                    </div>
                    <div style="display:flex; gap:10px; align-items:center;">
                        <label style="font-size:12px; font-weight:600; color:var(--text-muted);">Role:</label>
                        <select id="userRoleFilter" onchange="filterUsersTable()" class="form-control" style="height:38px; font-size:13px; border-radius:8px; width:140px;">
                            <option value="all">All Roles</option>
                            <option value="Admin">Admins</option>
                            <option value="Employee">Employees</option>
                        </select>
                    </div>
                </div>

                <!-- Scrollable Table Container with Sticky Header -->
                <div style="max-height: 420px; overflow-y: auto; border: 1px solid var(--border-color); border-radius: 8px;">
                    <table class="tickets-table" style="width: 100%; border-collapse: separate; border-spacing: 0;">
                        <thead style="position: sticky; top: 0; z-index: 10; background: #f8fafc;">
                            <tr>
                                <th style="background:#f8fafc; border-bottom:1px solid var(--border-color); padding:10px 14px;">User</th>
                                <th style="background:#f8fafc; border-bottom:1px solid var(--border-color); padding:10px 14px;">Email</th>
                                <th style="background:#f8fafc; border-bottom:1px solid var(--border-color); padding:10px 14px;">Role</th>
                                <th style="background:#f8fafc; border-bottom:1px solid var(--border-color); padding:10px 14px;">Department</th>
                                <th style="background:#f8fafc; border-bottom:1px solid var(--border-color); padding:10px 14px; text-align:right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="userTableBody">
                            <c:forEach var="u" items="${allUsers}">
                                <tr data-role="${u.role}">
                                    <td style="padding:10px 14px;">
                                        <div style="display:flex; align-items:center; gap:8px;">
                                            <div style="width:28px; height:28px; border-radius:50%; background:var(--primary-light); color:var(--primary); font-weight:700; font-size:12px; display:flex; align-items:center; justify-content:center;">
                                                ${fn:toUpperCase(fn:substring(u.name, 0, 1))}
                                            </div>
                                            <div>
                                                <div style="font-weight:600; font-size:13px; color:var(--text-primary);">${u.name}</div>
                                                <div style="font-size:11px; color:var(--text-muted);">ID: #${u.id}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="padding:10px 14px; font-size:13px;">${u.email}</td>
                                    <td style="padding:10px 14px;">
                                        <span class="status-badge ${u.role == 'Admin' ? 'status-in-progress' : 'status-open'}">${u.role}</span>
                                    </td>
                                    <td style="padding:10px 14px; font-size:13px;">${not empty u.department ? u.department.name : '-'}</td>
                                    <td style="padding:10px 14px; text-align:right;">
                                        <div style="display:flex; justify-content:flex-end; gap:6px; align-items:center;">
                                            <button type="button" class="btn-action" onclick="toggleResetForm(${u.id})">
                                                <i class="fas fa-key"></i> Reset Password
                                            </button>
                                            <form action="${pageContext.request.contextPath}/UserManagement" method="POST" style="display:inline;">
                                                <input type="hidden" name="action" value="updateRole">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <input type="hidden" name="newRole" value="${u.role == 'Admin' ? 'Employee' : 'Admin'}">
                                                <button type="submit" class="btn-action">
                                                    <i class="fas fa-user-shield"></i> ${u.role == 'Admin' ? 'Demote' : 'Promote'}
                                                </button>
                                            </form>
                                        </div>
                                        <!-- Password Reset Form Dropdown -->
                                        <div id="reset-form-${u.id}" style="display:none; margin-top:8px; padding:10px; background:#f8fafc; border:1px solid #cbd5e1; border-radius:6px; text-align:left;">
                                            <form action="${pageContext.request.contextPath}/UserManagement" method="POST">
                                                <input type="hidden" name="action" value="resetPassword">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <label style="font-size:11px; font-weight:600; color:var(--text-muted); display:block; margin-bottom:4px;">Set New Password for ${u.name}:</label>
                                                <div style="display:flex; gap:6px; align-items:center;">
                                                    <div style="position:relative; flex:1;">
                                                        <input type="password" id="pass-input-${u.id}" name="newPassword" class="form-control" placeholder="New password" required style="font-size:12px; padding:4px 30px 4px 8px; height:32px; width:100%;">
                                                        <button type="button" onclick="togglePasswordVisibility(${u.id})" style="position:absolute; right:8px; top:50%; transform:translateY(-50%); background:none; border:none; color:var(--text-muted); cursor:pointer; padding:2px;" title="View Password">
                                                            <i id="pass-icon-${u.id}" class="fas fa-eye"></i>
                                                        </button>
                                                    </div>
                                                    <button type="submit" class="btn-header-action btn-primary" style="font-size:11px; padding:4px 12px; height:32px; white-space:nowrap;">Save</button>
                                                </div>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeUsersModal()">Close</button>
            </div>
        </div>
    </div>
</body>
</html>
