-- =======================================================
-- 1. DATABASE CREATION
-- =======================================================
DROP DATABASE IF EXISTS helpdesk_db;
CREATE DATABASE helpdesk_db;
USE helpdesk_db;

-- =======================================================
-- 2. TABLE DEFINITIONS (Must be in this order for Foreign Keys)
-- =======================================================

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE priorities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    level_name VARCHAR(20),
    resolve_hours INT(3)
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT NOT NULL,
    name VARCHAR(45),
    email VARCHAR(45),
    role VARCHAR(20),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE tickets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    priority_id INT NOT NULL,
    title VARCHAR(100),
    description TEXT,
    status VARCHAR(20),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (priority_id) REFERENCES priorities(id)
);

CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    user_id INT NOT NULL,
    message TEXT,
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45)
);

CREATE TABLE ticket_tags (
    ticket_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (ticket_id, tag_id),
    FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- =======================================================
-- 3. SEED MOCK DATA
-- =======================================================

-- Insert Departments
INSERT INTO departments (name) VALUES 
('Human Resources'), 
('Finance'), 
('IT Support');

-- Insert Priorities (SLA Hours)
INSERT INTO priorities (level_name, resolve_hours) VALUES 
('Low', 48), 
('Medium', 24), 
('High', 4);

-- Insert Users (1 Admin, 2 Employees)
INSERT INTO users (department_id, name, email, role) VALUES 
(3, 'Admin User', 'admin@unikl.edu.my', 'Admin'),
(1, 'Test Employee', 'employee@unikl.edu.my', 'Employee'),
(2, 'Finance User', 'finance@unikl.edu.my', 'Employee');

-- Insert Tickets
INSERT INTO tickets (user_id, priority_id, title, description, status) VALUES 
(2, 3, 'Cannot access Payroll system', 'Getting a 403 Forbidden error when trying to export the Q3 report.', 'Open'),
(3, 1, 'Need new mouse', 'Scroll wheel is broken and double clicking randomly.', 'In Progress');

-- Insert Tags
INSERT INTO tags (name) VALUES 
('Software Bug'), 
('Hardware Failure'), 
('Access Request'), 
('Network Issue');

-- Link Tags to Tickets (Ticket 1 = Software Bug, Ticket 2 = Hardware Failure)
INSERT INTO ticket_tags (ticket_id, tag_id) VALUES 
(1, 1), 
(2, 2);

-- Insert Comments
INSERT INTO comments (ticket_id, user_id, message) VALUES 
(1, 2, 'Update: I tried clearing my browser cache but the error is still happening.'),
(1, 1, 'Acknowledged. Checking the server permissions now.');