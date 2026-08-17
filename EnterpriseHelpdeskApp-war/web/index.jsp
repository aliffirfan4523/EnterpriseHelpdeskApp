<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Helpdesk - Sign In</title>
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css?v=2.0">
</head>
<body>

    <div class="auth-wrapper">
        <!-- Left Hero Pane -->
        <div class="auth-hero-pane">
            <div class="auth-brand">
                <div class="auth-brand-logo">
                    <i class="fas fa-headset"></i>
                </div>
                <div class="auth-brand-name">Enterprise Helpdesk</div>
            </div>

            <div class="auth-hero-content">
                <div class="auth-hero-tag">
                    <i class="fas fa-bolt"></i> Next-Gen IT Service Management
                </div>
                <h2 class="auth-hero-title">Streamline support. Resolve incidents faster.</h2>
                <p class="auth-hero-desc">
                    Empowering employees and IT specialists with real-time ticket tracking, intelligent SLA management, and seamless issue resolution.
                </p>
                <div class="auth-feature-list">
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="fas fa-clock"></i></div>
                        <span>Automated SLA Tracking & Resolution Deadlines</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="fas fa-shield-alt"></i></div>
                        <span>Role-Based Access Control for Admins & Employees</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="fas fa-comments"></i></div>
                        <span>Interactive Activity Threads & Private Internal Notes</span>
                    </div>
                </div>
            </div>

            <div class="auth-hero-footer">
                <span>&copy; 2026 Enterprise Helpdesk System. UniKL RCBD.</span>
                <span>Version 2.0 (Java EE)</span>
            </div>
        </div>

        <!-- Right Form Pane -->
        <div class="auth-form-pane">
            <div class="auth-card">
                <div class="auth-header">
                    <h1>Welcome Back</h1>
                    <p>Select your role and enter your credentials to access the portal.</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                <% } %>

                <% if ("registered".equals(request.getParameter("success"))) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Account registered successfully! You may now sign in.</span>
                    </div>
                <% } %>

                <% if ("loggedout".equals(request.getParameter("loggedout"))) { %>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i>
                        <span>You have been safely signed out.</span>
                    </div>
                <% } %>

                <form action="Login" method="POST">
                    <!-- Role Switcher -->
                    <div class="role-toggle-group">
                        <input type="radio" id="roleEmployee" name="role" value="Employee" checked>
                        <label for="roleEmployee">
                            <i class="fas fa-user"></i> Employee
                        </label>

                        <input type="radio" id="roleAdmin" name="role" value="Admin">
                        <label for="roleAdmin">
                            <i class="fas fa-user-shield"></i> IT Admin
                        </label>
                    </div>

                    <!-- Email Input -->
                    <div class="form-group">
                        <label class="form-label" for="email">Work Email</label>
                        <div class="input-with-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" class="form-control" placeholder="name@company.com" required autofocus>
                        </div>
                    </div>

                    <!-- Password Input -->
                    <div class="form-group">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <label class="form-label" for="password">Password</label>
                        </div>
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-primary" style="margin-top: 12px;">
                        <span>Sign In</span>
                        <i class="fas fa-arrow-right"></i>
                    </button>
                </form>

                <div class="auth-footer">
                    Don't have an account? 
                    <a href="Register">Register as Employee</a>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
