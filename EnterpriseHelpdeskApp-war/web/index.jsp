<%-- 
    Document   : index
    Created on : 2 Jun 2026, 2:31:02 am
    Author     : aliff
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>IT Helpdesk - Login</title>
        <link rel="stylesheet" href="style/style.css">
    </head>

    <body>

        <div class="container">

            <div class="card">

                <div class="logo">
                    🔒
                </div>

                <h1>IT Helpdesk</h1>
                <p class="subtitle">Secure Access Portal</p>
                
                <% if (request.getAttribute("error") != null) { %>
                    <p style="color:red; text-align:center; margin-bottom:15px; font-weight:bold;">
                        <%= request.getAttribute("error") %>
                    </p>
                <% } %>
                
                <form action="Login" method="post">

                    <div class="role-switch">

                        <input type="radio"
                               id="employee"
                               name="role"
                               value="Employee"
                               checked>

                        <label for="employee">Employee</label>

                        <input type="radio"
                               id="admin"
                               name="role"
                               value="Admin">

                        <label for="admin">IT Admin</label>

                    </div>

                    <label>Email Address</label>
                    <input type="email"
                           name="email"
                           required>

                    <label>Password</label>
                    <input type="password"
                           name="password"
                           required>

                    <button type="submit" class="btn-login">
                        Log in
                    </button>

                </form>

                <div class="footer">
                    <a href="Register">Register for an Employee account</a>
                </div>

            </div>

        </div>

    </body>
</html>
