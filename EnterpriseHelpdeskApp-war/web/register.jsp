<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Helpdesk - Create Account</title>
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
                    <i class="fas fa-user-plus"></i> Employee Registration
                </div>
                <h2 class="auth-hero-title">Get fast support from your IT department.</h2>
                <p class="auth-hero-desc">
                    Create an account to submit support tickets, track resolution progress in real-time, and access company IT resources.
                </p>
                <div class="auth-feature-list">
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="fas fa-ticket-alt"></i></div>
                        <span>Create & Track Unlimited Support Incidents</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="fas fa-bolt"></i></div>
                        <span>Priority SLAs matched to your department requirements</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="fas fa-bell"></i></div>
                        <span>Instant updates directly from IT specialists</span>
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
                    <h1>Create Employee Account</h1>
                    <p>Enter your details below to register for the IT helpdesk portal.</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                <% } %>

                <form action="Register" method="POST">
                    <!-- Full Name -->
                    <div class="form-group">
                        <label class="form-label" for="fullname">Full Name</label>
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="fullname" name="fullname" class="form-control" placeholder="John Doe" required autofocus>
                        </div>
                    </div>

                    <!-- Email Input -->
                    <div class="form-group">
                        <label class="form-label" for="email">Work Email</label>
                        <div class="input-with-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" class="form-control" placeholder="name@company.com" required>
                        </div>
                    </div>

                    <!-- Department -->
                    <div class="form-group">
                        <label class="form-label" for="departmentId">Department</label>
                        <div class="input-with-icon">
                            <i class="fas fa-building"></i>
                            <select id="departmentId" name="departmentId" class="form-control" required>
                                <option value="">Select your Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}">${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Password Input -->
                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                        </div>
                    </div>

                    <!-- Confirm Password Input -->
                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="••••••••" required>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-primary" style="margin-top: 16px;">
                        <span>Complete Registration</span>
                        <i class="fas fa-arrow-right"></i>
                    </button>
                </form>

                <div class="auth-footer">
                    Already have an account? 
                    <a href="Login">Sign in here</a>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
