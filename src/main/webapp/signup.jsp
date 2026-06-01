<html>
<head>
    <title>eBankDB Sign Up</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ef4444;
        }

        select {
            width: 100%;
            padding: 12px;
            border: 1.5px solid #c8e6c9;
            border-radius: 6px;
            font-size: 15px;
            background: white;
        }

        select:focus {
            border-color: #66bb6a;
            outline: none;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-box">
        <h2>eBankDB Sign Up</h2>

        <!-- ERROR MESSAGE -->
        <%
        if(request.getParameter("error") != null){
        %>
            <div class="alert-error">
                ⚠ Username already exists. Please choose a different username.
            </div>
        <%
        }
        %>

        <form action="signup" method="post">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter username" required>
            </div>
            <br>
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter password" required>
            </div>
            <br>
            <div class="input-group">
                <label>Role</label>
                <select name="role" required>
                    <option value="">-- Select Role --</option>
                    <option value="Customer">Customer</option>
                    <option value="Employee">Employee</option>
                    <option value="Manager">Manager</option>
                </select>
            </div>
            <br>
            <button type="submit" class="btn-login">Sign Up</button>
        </form>

        <div style="text-align:center; margin-top:20px;">
            Already have an account?
            <a href="login.jsp">Login</a>
        </div>
    </div>
</div>

</body>
</html>