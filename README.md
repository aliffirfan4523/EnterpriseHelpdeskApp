# Enterprise Helpdesk Application

A Java EE Enterprise Application for managing IT helpdesk tickets, built with **JSF**, **EJB**, **JPA**, and **MySQL**.

Developed as part of the **Reuse and Component Based Development** course at UniKL.

---

## Prerequisites

Before running this project, make sure you have the following installed:

| Software | Version |
|----------|---------|
| **JDK** | 1.8 |
| **NetBeans IDE** | 12+ (or any version with Java EE support) |
| **GlassFish Server** | 5.1 |
| **MySQL Server** | 5.7 or 8.0 |

---

## Setup Instructions

### Step 1: Install the MySQL JDBC Driver

GlassFish does **not** include a MySQL driver by default. You must add it manually.

1. Download the **MySQL Connector/J** JAR file from [MySQL Downloads](https://dev.mysql.com/downloads/connector/j/).
   - Select **Platform Independent** and download the `.zip` file.
   - Extract the `.jar` file (e.g., `mysql-connector-java-8.0.xx.jar`).
2. Copy the `.jar` file into your GlassFish domain's `lib` folder:
   ```
   [GlassFish Installation]/glassfish/domains/domain1/lib/
   ```
3. **Restart GlassFish** after adding the driver.

### Step 2: Create the Database

We have provided a Python automation script to easily configure the database.

1. Ensure you have Python installed.
2. Ensure the `mysql` CLI tool is in your system PATH.
3. Run the setup script from the root directory:
   ```bash
   python setup_db.py
   ```
   
   Alternatively, you can manually run the SQL script via your MySQL client:
   ```sql
   source script.sql
   ```

   This will:
   - Create the `helpdesk_db` database
   - Create all required tables (`departments`, `priorities`, `users`, `tickets`, `comments`, `tags`, `ticket_tags`)
   - Insert sample/mock data for testing

### Step 3: Update Database Credentials (If Needed)

The project is configured with the following default MySQL credentials:

| Setting | Default Value |
|---------|---------------|
| **Host** | `localhost` |
| **Port** | `3306` |
| **Database** | `helpdesk_db` |
| **Username** | `helpdesk_user` |
| **Password** | `helpdesk123` |

To create this dedicated database user, run the following SQL commands in your MySQL client:

```sql
CREATE USER 'helpdesk_user'@'localhost' IDENTIFIED BY 'helpdesk123';
GRANT ALL PRIVILEGES ON helpdesk_db.* TO 'helpdesk_user'@'localhost';
FLUSH PRIVILEGES;
```

If you prefer to use different credentials, update them in this file:

```
src/conf/glassfish-resources.xml
```

Change the `User`, `Password`, and `URL` property values to match your setup.

### Step 4: Build and Deploy

1. Open the project in **NetBeans**.
2. Right-click the `EnterpriseHelpdeskApp` project (the main Enterprise Application).
3. Select **Clean and Build**.
4. Select **Run** (or **Deploy**).

The application will be deployed to GlassFish and should open automatically in your browser.

---

## Project Structure

```
EnterpriseHelpdeskApp/                  # EAR (Enterprise Application)
├── src/conf/
│   └── glassfish-resources.xml         # JDBC connection pool & resource (EAR level)
│
├── EnterpriseHelpdeskApp-ejb/          # EJB Module (Business Logic)
│   └── src/
│       ├── conf/
│       │   └── persistence.xml         # JPA Persistence Unit config
│       └── java/com/helpdesk/
│           ├── domain/
│           │   ├── core/               # Entity beans (Ticket, User, Department, Priority)
│           │   └── meta/               # Entity beans (Comment, Tag)
│           └── ejb/                    # Session beans (TicketManagerBean, DiscussionManagerBean, etc.)
│
├── EnterpriseHelpdeskApp-war/          # WAR Module (Web Layer)
│   └── src/java/com/helpdesk/web/     # Servlets (AdminDashboardServlet, UpdateTicketServlet, etc.)
│
└── script.sql                          # Database creation & seed data script
```

---

## Troubleshooting

### "Invalid resource: __pm" error
This usually means GlassFish cannot connect to your MySQL database. Check:
- Is MySQL running?
- Does the `helpdesk_db` database exist?
- Is the MySQL JDBC driver JAR in GlassFish's `lib` folder?
- Did you restart GlassFish after adding the driver?

### "Cannot find CDI BeanManager" error
Make sure `beans.xml` exists in both:
- `EnterpriseHelpdeskApp-ejb/src/conf/beans.xml`
- `EnterpriseHelpdeskApp-war/web/WEB-INF/beans.xml`

### "Could not resolve persistence unit" error
Make sure `persistence.xml` exists at `EnterpriseHelpdeskApp-ejb/src/conf/persistence.xml` and the persistence unit name matches `HelpdeskPU`.
