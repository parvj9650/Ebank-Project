<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Employee Profile - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-header h2 {
            margin: 0;
            color: var(--dark);
            font-size: 28px;
        }

        .form-box {
            background: white;
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--shadow);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        .form-group select,
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }

        .form-group input[readonly] {
            background: #f1f5f9;
            cursor: not-allowed;
        }

        .update-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 12px 28px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 16px;
            width: 100%;
        }

        .update-btn:hover {
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
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
            font-size: 14px;
            margin-top: 20px;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(100, 116, 139, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
            text-decoration: none;
            color: white;
        }

        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .error-message {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ef4444;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .success-message {
            background: #d1fae5;
            color: #065f46;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #10b981;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .readonly-note {
            background: #f1f5f9;
            color: #64748b;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<div class="form-container">
    <div class="page-header">
        <h2>✏️ Edit Your Profile</h2>
    </div>

    <div class="form-box">
        <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");

        if(error != null){
        %>
            <div class="error-message">
                <span>⚠</span> <%= error %>
            </div>
        <%
        }
        if(success != null){
        %>
            <div class="success-message">
                <span>✓</span> <%= success %>
            </div>
        <%
        }

        Map<String, Object> profile = (Map<String, Object>) request.getAttribute("profile");
        List<Map<String, Object>> branches = (List<Map<String, Object>>) request.getAttribute("branches");
        %>

        <form action="<%= request.getContextPath() %>/updateEmployeeProfile" method="post">
            <div class="form-group">
                <label>📝 Full Name</label>
                <input type="text" name="name"
                       value="<%= profile != null ? profile.get("name") : "" %>"
                       placeholder="Enter your full name" required>
            </div>

            <div class="form-group">
                <label>🏢 Branch</label>
                <select name="branchId" required>
                    <%
                    if(branches != null){
                        Object currentBranch = profile != null ? profile.get("branch_id") : null;

                        for(Map<String, Object> b : branches){
                            String selected = (currentBranch != null && currentBranch.equals(b.get("branch_id"))) ? "selected" : "";
                    %>
                        <option value="<%= b.get("branch_id") %>" <%= selected %>>
                            🏢 <%= b.get("branch_name") %>
                        </option>
                    <%
                        }
                    }
                    %>
                </select>
            </div>

            <div class="form-group">
                <label>👔 Designation</label>
                <input type="text"
                       value="<%= profile != null ? profile.get("designation") : "" %>"
                       readonly>
                <div class="readonly-note">
                    ℹ️ Designation cannot be changed. Please contact administrator if needed.
                </div>
            </div>

            <button type="submit" class="update-btn">💾 Update Profile</button>
        </form>
    </div>

    <div class="bottom-buttons">
        <a href="<%= request.getContextPath() %>/employee/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>