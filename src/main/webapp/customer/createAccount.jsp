<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Branch" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Create Account - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .create-account-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 12px 28px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            font-size: 14px;
            border: none;
            cursor: pointer;
            width: 100%;
        }

        .create-account-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }

        .back-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 12px 28px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            font-size: 14px;
            border: none;
            cursor: pointer;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }

        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>🏦 Create New Account</h2>
    </div>
    <br>
    <div class="table-container" style="max-width: 600px; margin: 0 auto;">
        <%
        String error = (String) request.getAttribute("error");
        if(error != null){
        %>
            <div class="alert-error" style="margin-bottom: 20px;">
                ⚠ <%= error %>
            </div>
        <%
        }
        %>

        <form action="${pageContext.request.contextPath}/createAccount" method="post">
            <div class="form-group">
                <label>Select Branch</label>
                <select name="branchId">
                    <%
                    List<Branch> branches = (List<Branch>) request.getAttribute("branches");
                    if(branches != null){
                        for(Branch b : branches){
                    %>
                        <option value="<%= b.getBranchId() %>">
                            🏢 <%= b.getBranchName() %> - <%= b.getIfsc() %>
                        </option>
                    <%
                        }
                    }
                    %>
                </select>
            </div>
            <br>
            <div class="form-group">
                <label>Account Type</label>
                <select name="accountType">
                    <option value="Savings" <%= "Savings".equals(request.getAttribute("accountType")) ? "selected" : "" %>>💰 Savings Account</option>
                    <option value="Current" <%= "Current".equals(request.getAttribute("accountType")) ? "selected" : "" %>>💼 Current Account</option>
                </select>
            </div>
            <br>
            <div class="form-group">
                <label>Initial Balance (₹)</label>
                <input type="text" name="balance"
                       value="<%= request.getAttribute("balance") != null ? request.getAttribute("balance") : "" %>"
                       placeholder="Minimum ₹500" required>
            </div>
            <br>
            <button type="submit" class="create-account-btn">Create Account</button>
        </form>
    </div>
    <br>
    <div class="bottom-buttons">
        <a href="viewAccounts" class="back-btn">← Back to Accounts</a>
    </div>
</div>

</body>
</html>