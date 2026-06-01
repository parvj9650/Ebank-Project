<html>
<head>
<title>eBankDB Login</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<div class="login-container">

    <div class="login-box">

        <h2>eBankDB Login</h2>

        <!-- ERROR MESSAGE -->
        <%
        if(request.getParameter("error") != null){
        %>
            <div class="alert alert-error">
                Invalid Username or Password
            </div>
        <%
        }
        %>

        <!-- SUCCESS MESSAGE -->
        <%
        if(request.getParameter("registered") != null){
        %>
            <div class="alert alert-success">
                Account created successfully! Please login.
            </div>
        <%
        }
        %>

        <form action="login" method="post">

            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <br>
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <br>
            <button type="submit" class="btn-login">Login</button>

        </form>

        <div style="text-align:center; margin-top:20px;">
            Don't have an account?
            <a href="signup.jsp">Sign-up</a>
        </div>

    </div>

</div>

</body>
</html>