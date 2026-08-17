# Enterprise Helpdesk System

A modern, enterprise-grade IT Helpdesk & Service Desk Web Application built on **Java EE 8**, **EJB 3.2**, **JPA (Hibernate)**, **JSP/Servlets**, and **MySQL 8.0**, running on **GlassFish Server 5**.

Developed for the **Reuse and Component Based Development** course at **UniKL**.

---

## Default Login Credentials

Use these credentials to sign in and test the system:

| Role | Email | Password | Access Rights |
|------|-------|----------|---------------|
| **IT Administrator** | `admin@helpdesk.com` | `password` (or `admin123`) | Full IT Operations Center access, ticket assignment, status updates, SLA tracking, CSV exports, KB article management, user management. |
| **IT Lead** | `sarah.it@helpdesk.com` | `password` | Full IT Operations Center access, internal notes, tag management. |
| **Employee (Requester)** | `user@helpdesk.com` | `password` | Employee Portal access, log new support tickets, view status, reply to threads, submit CSAT ratings, search Knowledge Base. |
| **Employee (HR)** | `emily.hr@helpdesk.com` | `password` | Employee Portal access, ticket submission & rating. |
| **Employee (Finance)** | `michael.finance@helpdesk.com` | `password` | Employee Portal access, ticket submission & rating. |

---

## Features & Highlights

### 1. Modern Enterprise UI & Design System
- **Theme**: Dark Navy & Slate executive aesthetic with Indigo/Violet primary accents.
- **Responsive Layout**: Full support for desktop, tablet, and mobile views.
- **Custom Vanilla CSS**: Modular, lightweight CSS (`admin.css`, `employee.css`, `ticket-details.css`, `knowledge-base.css`, `style.css`). No heavy external frameworks.

### 2. Multi-Role Portals
- **IT Operations Center (Admin Dashboard)**: Real-time ticket counts, SLA breakdown metrics, multi-criteria filtering, bulk actions, and ticket assignment.
- **Employee Service Portal**: Request submission form, personal ticket tracking with status chips, and instant Knowledge Base access.

### 3. Key Helpdesk Capabilities
- **Knowledge Base Portal**: Self-service library with category navigation (Network, Software, Account Access, Hardware, Security), hero search bar, expandable guides, and admin article authoring.
- **CSAT 1-5 Star Ratings**: Interactive satisfaction rating form on resolved/closed tickets with optional feedback comments.
- **SLA Tracking Engine**: Automated deadline calculation with real-time `IN_SLA`, `AT_RISK`, and `BREACHED` status badges based on priority resolution targets.
- **Internal vs. External Threads**: Tabbed reply composer for IT specialists to record private diagnostic notes or public customer updates.
- **Multi-Criteria Filtering & Live Search**: Filter by status, priority, department, or live keyword search.
- **CSV Data Export**: Automated export of ticket records for offline reporting.
- **Audit History Trail**: Immutable timestamped audit logs for every ticket action.
- **Tagging System**: Multi-tag management per incident.
- **User Account Management**: Ability for admins to view user lists, change roles, or remove accounts.

---

## Prerequisites

| Software | Version |
|----------|---------|
| **JDK** | 1.8 (Java 8) |
| **GlassFish Server** | 5.0 / 5.1 |
| **MySQL Server** | 5.7 or 8.0 |
| **NetBeans IDE** | 12+ (or Eclipse / IntelliJ with Java EE EAR support) |

---

## Setup Instructions

### Step 1: Install MySQL JDBC Driver into GlassFish
1. Download **MySQL Connector/J** (`mysql-connector-java-8.0.xx.jar`).
2. Copy the `.jar` file into your GlassFish domain library:
   ```
   [GlassFish_Directory]/glassfish/domains/domain1/lib/
   ```
3. Restart GlassFish Server.

### Step 2: Create the Database & Load Seed Data
Create the MySQL database user and run `script.sql`:

```sql
CREATE USER 'helpdesk_user'@'localhost' IDENTIFIED BY 'helpdesk123';
GRANT ALL PRIVILEGES ON helpdesk_db.* TO 'helpdesk_user'@'localhost';
FLUSH PRIVILEGES;

SOURCE c:/path/to/EnterpriseHelpdeskApp/script.sql;
```

`script.sql` will automatically:
- Create `helpdesk_db` and all 10 schema tables with foreign keys and indexes.
- Seed demo users, departments, priorities, tags, tickets, comments, CSAT ratings, and 9 Knowledge Base articles.

### Step 3: Build & Deploy
1. Open the root project (`EnterpriseHelpdeskApp`) in NetBeans.
2. Select **Clean and Build** (`Ant clean dist`).
3. Deploy `EnterpriseHelpdeskApp.ear` to GlassFish Server 5.
4. Access the web application in your browser:
   ```
   http://localhost:8080/EnterpriseHelpdeskApp-war/
   ```

---

## Project Architecture

```
EnterpriseHelpdeskApp/                  # EAR (Enterprise Application Archive)
├── src/conf/
│   └── glassfish-resources.xml         # JDBC Connection Pool & Data Source
│
├── EnterpriseHelpdeskApp-ejb/          # EJB Module (Business & Data Layer)
│   └── src/
│       ├── conf/
│       │   ├── persistence.xml         # JPA Persistence Unit (HelpdeskPU)
│       │   └── beans.xml
│       └── java/com/helpdesk/
│           ├── domain/
│           │   ├── core/               # Entity Beans (Ticket, User, Department, Priority)
│           │   └── meta/               # Entity Beans (Comment, Tag, Article, TicketRating, AuditLog)
│           └── ejb/                    # Stateless Session Beans (TicketManagerBean, UserManagerBean, etc.)
│
├── EnterpriseHelpdeskApp-war/          # WAR Module (Presentation Layer)
│   └── src/java/com/helpdesk/web/     # Servlets & Performance Filters
│   └── web/
│       ├── index.jsp                   # Sign In / Portal Entry
│       ├── register.jsp                # Account Registration
│       ├── admin.jsp                   # IT Operations Center Dashboard
│       ├── employee.jsp                # Employee Service Portal
│       ├── ticket-details.jsp          # Incident Workbench & Discussion Stream
│       ├── knowledge-base.jsp          # Self-Service Knowledge Base
│       └── style/                      # Custom Modular Stylesheets
│
└── script.sql                          # Complete Database Schema & Seed Data Script
```

---

## Performance Optimizations

- **Database Indexing**: BTREE indexes added on `user_id`, `status`, `assigned_to`, `category`, and `ticket_id` for fast query response times.
- **HTTP Cache Control**: `CacheControlFilter.java` sets 24-hour browser caching headers on static assets (`.css`, `.js`, fonts).
- **Asynchronous Audit Logging**: Non-blocking audit trail execution to ensure instant UI response times.
