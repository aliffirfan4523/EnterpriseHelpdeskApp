<%-- 
    Document   : register
    Created on : 2 Jun 2026, 2:31:13 am
    Author     : aliff
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Register Account</title>
        <link rel="stylesheet" href="style/style.css">
    </head>

    <body>

        <div class="container">

            <div class="card">

                <div class="logo">
                    👤
                </div>

                <h1>Create Account</h1>
                <p class="subtitle">Register to access the Helpdesk System</p>
                
                <% if (request.getAttribute("error") != null) { %>
                    <p style="color:red; text-align:center; margin-bottom:15px; font-weight:bold;">
                        <%= request.getAttribute("error") %>
                    </p>
                <% } %>

                <form action="Register" method="post">

                    <label>Full Name</label>
                    <input type="text"
                           name="fullname"
                           required>

                    <label>Email Address</label>
                    <input type="email"
                           name="email"
                           required>

                    <label>Password</label>
                    <input type="password"
                           name="password"
                           required>

                    <label>Department</label>
                    <select name="departmentId" required style="width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px; font-family: inherit; font-size: 14px;">
                        <option value="">Select a Department</option>
                        <c:forEach var="dept" items="${departments}">
                            <option value="${dept.id}">${dept.name}</option>
                        </c:forEach>
                    </select>

                    <label>Confirm Password</label>
                    <input type="password"
                           name="confirmPassword"
                           required>

                    <button type="submit"
                            class="btn-login">
                        Register
                    </button>

                </form>

                <div class="footer">
                    <a href="Login">Login for IT Admin Here</a>
                </div>

            </div>

        </div>

    </body>
</html>
