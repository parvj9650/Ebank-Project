<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Audit Logs - Manager Panel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .search-section {
            background: white;
            padding: 20px;
            border-radius: var(--border-radius);
            margin-bottom: 25px;
            box-shadow: var(--shadow);
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .search-form .form-group {
            flex: 1;
            min-width: 200px;
            margin-bottom: 0;
        }

        .search-form label {
            margin-bottom: 5px;
            font-size: 13px;
            font-weight: 500;
            color: var(--dark);
            display: block;
        }

        .search-form input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .search-form input:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }

        .btn-search {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 10px 24px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }

        .show-all-btn {
            background: linear-gradient(135deg, #64748b, #475569);
            color: white;
            padding: 10px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .show-all-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(100, 116, 139, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
            text-decoration: none;
            color: white;
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
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            font-size: 14px;
            border: none;
            cursor: pointer;
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
            margin-top: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-header h2 {
            margin: 0;
            color: var(--dark);
        }

        .empty-state {
            text-align: center;
            padding: 60px 40px;
            color: #64748b;
        }

        .account-id {
            font-weight: 700;
            color: #14b8a6;
            font-size: 14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 12px;
            background: #f8fafc;
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid #e2e8f0;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        tr:hover {
            background: #f8fafc;
        }

        .badge-action {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .action-create {
            background: #d1fae5;
            color: #065f46;
        }

        .action-update {
            background: #dbeafe;
            color: #1e40af;
        }

        .action-delete {
            background: #fee2e2;
            color: #991b1b;
        }

        .action-login {
            background: #fed7aa;
            color: #92400e;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>📜 Audit Logs</h2>
    </div>

    <div class="search-section">
        <form method="get" action="<%= request.getContextPath() %>/viewAuditLogs" class="search-form">
            <div class="form-group">
                <label>🔍 Search Employee ID</label>
                <input type="text" name="employeeId"
                       value="<%= request.getParameter("employeeId") != null ? request.getParameter("employeeId") : "" %>"
                       placeholder="Enter Employee ID">
            </div>
            <button type="submit" class="btn-search">🔍 Search</button>
            <a href="<%= request.getContextPath() %>/viewAuditLogs?action=showAll" class="show-all-btn">Show All Logs</a>
        </form>
    </div>

    <div class="table-container">
        <%
        String error = (String) request.getAttribute("error");
        List<Map<String,Object>> logs = (List<Map<String,Object>>) request.getAttribute("logs");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm");

        if(logs != null && !logs.isEmpty()){
        %>
        <table>
            <thead>
                <tr>
                    <th>Log ID</th>
                    <th>Employee ID</th>
                    <th>Employee Name</th>
                    <th>Action</th>
                    <th>Date</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <%
                for(Map<String,Object> row : logs){
                    Object logId = row.get("log_id");
                    Object employeeId = row.get("employee_id");
                    Object employeeName = row.get("employee_name");
                    Object action = row.get("action");
                    Object actionDate = row.get("action_date");
                    Object description = row.get("description");

                    String actionClass = "";
                    String actionStr = action != null ? action.toString() : "";
                    if(actionStr.equalsIgnoreCase("CREATE")) actionClass = "action-create";
                    else if(actionStr.equalsIgnoreCase("UPDATE")) actionClass = "action-update";
                    else if(actionStr.equalsIgnoreCase("DELETE")) actionClass = "action-delete";
                    else if(actionStr.equalsIgnoreCase("LOGIN")) actionClass = "action-login";
                %>
                    <tr>
                        <td><span class="account-id">#<%= logId %></span></td>
                        <td>#<%= employeeId %></dt>
                        <td><strong><%= employeeName %></strong></dt>
                        <td><span class="badge-action <%= actionClass %>"><%= actionStr %></span></dt>
                        <td><%= actionDate != null ? actionDate : "-" %></dt>
                        <td><%= description != null ? description : "-" %></dt>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <% } else if(error != null && error.equals("invalidId")) { %>
            <div class="empty-state">
                <p>⚠ Invalid Employee ID format. Please enter a valid number.</p>
            </div>
        <% } else if(error != null && error.equals("noData")) { %>
            <div class="empty-state">
                <p>📭 No audit logs found for the specified Employee ID.</p>
                <p style="font-size: 13px; margin-top: 10px;">Try searching for a different employee ID or click "Show All Logs"</p>
            </div>
        <% } else { %>
            <div class="empty-state">
                <p>📭 No audit logs available</p>
                <p style="font-size: 13px; margin-top: 10px;">Try searching for a specific employee ID or click "Show All Logs"</p>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="manager/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>