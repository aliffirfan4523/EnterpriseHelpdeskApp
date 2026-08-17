# Implementation Plan - Advanced Helpdesk Features & Bulletproof CSS Overhaul

Implement 7+ major enterprise helpdesk features, eliminate all emojis across the application, and guarantee 100% reliable CSS styling so pages never render unstyled.

## User Review Required

> [!IMPORTANT]
> - **Zero Emojis**: All emojis across the frontend (e.g. 🔒, ⚡, 🚀, 👍, 💡, 🛡️, etc.) are strictly replaced with clean SVG icons, font icons, geometric status indicators, and styled badge labels.
> - **Bulletproof Styling**: To prevent any chance of "HTML without CSS" (caused by browser cache, offline CDN font loading, or proxy path resolution), core design system styles will be directly embedded in page headers in addition to external stylesheet links.

---

## 7+ New Enterprise Helpdesk Features

1. **Knowledge Base & Solution Article System**:
   - Searchable repository of solution articles categorized by *Network & VPN*, *Account Access*, *Software*, and *Hardware*.
   - Live search filter and full article reader modal with a "Did this solve your issue?" prompt.
2. **Customer Satisfaction (CSAT) Rating & Review**:
   - 1-to-5 star rating widget and feedback review submission for employees on Resolved/Closed tickets.
   - Average CSAT score and feedback count aggregated on the Admin Dashboard.
3. **Canned Responses / Quick Reply Templates**:
   - 1-click standard response templates for IT staff (e.g., *Password Reset Instructions*, *Investigating Network Issue*, *Requesting Diagnostics*, *Resolved - Awaiting Confirmation*).
4. **Service Category & Incident Classification**:
   - Incident categorization dropdown (*Hardware, Software, Network & VPN, Account Access, Security, Infrastructure*) with category badges.
5. **Bulk Ticket Management (Admin Multi-Select Actions)**:
   - Checkbox row selection on the Admin incident table allowing bulk actions:
     - *Bulk Status Update* (e.g., Mark all selected as In Progress or Resolved)
     - *Bulk Assignment* (Assign selected to chosen IT Admin)
     - *Bulk Priority Change* (Escalate selected tickets to Critical/High)
6. **Incident Audit Trail & Activity Timeline Log**:
   - Automatic chronological logging of status updates, priority changes, and assignments into `ticket_audit_logs` displayed on the ticket workbench.
7. **SLA Breach Escalation Alerts & Compliance Breakdown**:
   - Prominent visual SLA alerts with remaining countdown and a 1-click *Escalate Priority* action.
8. **IT Operations Analytics & SLA Performance Modal**:
   - Real-time modal showing SLA Compliance %, CSAT Average, Category breakdown, and department ticket load.

---

## Proposed Changes

### Database Layer
- [x] Created `articles` table for Knowledge Base articles.
- [x] Created `ticket_ratings` table for CSAT feedback.
- [x] Created `ticket_audit_logs` table for ticket timeline logs.
- [x] Added `category` column to `tickets` table.

### EJB Backend Layer (`EnterpriseHelpdeskApp-ejb`)

#### [NEW] [Article.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-ejb/src/java/com/helpdesk/domain/meta/Article.java)
- Entity for Knowledge Base articles (id, title, category, content, author, created_at).

#### [NEW] [TicketRating.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-ejb/src/java/com/helpdesk/domain/meta/TicketRating.java)
- Entity for CSAT ratings and feedback comments linked to tickets.

#### [NEW] [TicketAuditLog.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-ejb/src/java/com/helpdesk/domain/meta/TicketAuditLog.java)
- Entity for tracking action events (status changes, priority changes, reassignments).

#### [MODIFY] [Ticket.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-ejb/src/java/com/helpdesk/domain/core/Ticket.java)
- Add `category` field with getter/setter.
- Add `rating` (`@OneToOne TicketRating`) and `auditLogs` (`@OneToMany List<TicketAuditLog>`) associations.

#### [MODIFY] [TicketManagerBean.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-ejb/src/java/com/helpdesk/ejb/TicketManagerBean.java)
- Add `submitRating(int ticketId, int rating, String feedback)`
- Add `getRatingForTicket(int ticketId)`
- Add `logAudit(int ticketId, int userId, String action, String details)`
- Add `getAuditLogsForTicket(int ticketId)`
- Add `bulkUpdateStatus(List<Integer> ticketIds, String newStatus, int userId)`
- Add `bulkAssign(List<Integer> ticketIds, int adminId, int userId)`
- Add `bulkUpdatePriority(List<Integer> ticketIds, int priorityId, int userId)`
- Add `getAllArticles()` and `searchArticles(String keyword)`
- Add `getAnalyticsData()` for CSAT averages, SLA compliance %, and department distribution.

---

### Servlet & Web Layer (`EnterpriseHelpdeskApp-war`)

#### [NEW] [KnowledgeBaseServlet.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/src/java/com/helpdesk/web/KnowledgeBaseServlet.java)
- Serve Knowledge Base article search and return article content.

#### [NEW] [RateTicketServlet.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/src/java/com/helpdesk/web/RateTicketServlet.java)
- Process employee CSAT star rating and feedback submission for resolved tickets.

#### [NEW] [BulkActionServlet.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/src/java/com/helpdesk/web/BulkActionServlet.java)
- Handle bulk status updates, bulk assignments, and bulk priority changes from the Admin table.

#### [MODIFY] [AdminDashboardServlet.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/src/java/com/helpdesk/web/AdminDashboardServlet.java)
- Pass analytics data, CSAT average, and knowledge base article counts to `admin.jsp`.

#### [MODIFY] [EmployeeDashboardServlet.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/src/java/com/helpdesk/web/EmployeeDashboardServlet.java)
- Pass knowledge base articles and resolution ratings to `employee.jsp`.

#### [MODIFY] [ViewTicketServlet.java](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/src/java/com/helpdesk/web/ViewTicketServlet.java)
- Load CSAT rating, audit history logs, and canned response templates.

---

### Presentation Layer (JSPs & CSS)

#### [MODIFY] [index.jsp](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/web/index.jsp) & [register.jsp](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/web/register.jsp)
- Ensure all styling is bulletproof (no missing styles), zero emojis.

#### [MODIFY] [admin.jsp](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/web/admin.jsp)
- Add Bulk Action Toolbar (appears dynamically when checkboxes are selected).
- Add 5th KPI Card: CSAT Satisfaction Score.
- Add "Analytics & SLA Compliance" modal.
- Add Knowledge Base management tab.
- Embedded master styles + zero emojis.

#### [MODIFY] [employee.jsp](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/web/employee.jsp)
- Add Knowledge Base search bar with category chips and Article Reader modal.
- Add category selector in "Raise a Request" form.
- Embedded master styles + zero emojis.

#### [MODIFY] [ticket-details.jsp](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/web/ticket-details.jsp)
- Add Canned Response quick insertion pills for IT staff.
- Add CSAT Rating & Feedback card for employees when ticket is Resolved.
- Add Audit History Timeline tab.
- Add 1-click "Escalate Incident" button for high/breached SLAs.
- Embedded master styles + zero emojis.

#### [MODIFY] [tickets-list.jsp](file:///c:/Users/aliff/Documents/Unikl%20Library/Sem%205/REUSE%20AND%20COMPONENT%20BASED%20DEVELOPMENT/project/EnterpriseHelpdeskApp/EnterpriseHelpdeskApp-war/web/tickets-list.jsp)
- Add multi-select checkbox column for Admin bulk actions.
- Add Category badge column.
- Zero emojis.

---

## Verification Plan

### Automated Verification
- Ant clean build (`build.xml`) on JDK 8.
- Redeploy EAR to GlassFish 5 domain.

### Browser Verification
- Test all 7+ features in the browser subagent:
  1. Knowledge Base search and article view.
  2. Submitting CSAT rating on a resolved ticket.
  3. Inserting canned responses into the reply box.
  4. Selecting incident category during ticket creation.
  5. Performing bulk status / assignment update on admin table.
  6. Viewing audit history log on ticket details.
  7. Checking SLA escalation alert.
  8. Viewing the Analytics & SLA performance modal.
- Verify zero missing CSS and zero emojis across all pages.
