<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ebankdb.model.Customer" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile - eBankDB</title>
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

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
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
            background: linear-gradient(135deg, #0d9488, #0f766e);
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

        .message-success {
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

        .message-error {
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
    </style>
</head>
<body>

<div class="form-container">
    <div class="page-header">
        <h2>✏️ Edit Profile</h2>
    </div>

    <div class="form-box">
        <%
        Customer c = (Customer) request.getAttribute("customer");
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        %>

        <% if(error != null){ %>
            <div class="message-error">
                <span>⚠</span> <%= error %>
            </div>
        <% } %>

        <% if(success != null){ %>
            <div class="message-success">
                <span>✓</span> <%= success %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/updateCustomerProfile" method="post">
            <div class="form-group">
                <label>📝 Full Name</label>
                <input type="text" name="name"
                       value="<%= (c != null ? c.getName() : "") %>"
                       placeholder="Enter your full name" required>
            </div>

            <div class="form-group">
                <label>🏠 Address</label>
                <textarea name="address"
                          placeholder="Enter your complete address" required><%= (c != null ? c.getAddress() : "") %></textarea>
            </div>

            <div class="form-group">
                <label>📧 Email</label>
                <input type="email" name="email"
                       value="<%= (c != null ? c.getEmail() : "") %>"
                       placeholder="you@example.com" required>
            </div>

            <div class="form-group">
                <label>📱 Phone</label>
                <input type="text" name="phone"
                       value="<%= (c != null ? c.getPhone() : "") %>"
                       placeholder="Enter 10-digit mobile number" required>
            </div>

            <div class="form-group">
                <label>🎂 Date of Birth</label>
                <input type="date" name="dob"
                       value="<%= (c != null && c.getDob()!=null ? c.getDob().toString() : "") %>" required>
            </div>

            <button type="submit" class="update-btn">💾 Update Profile</button>
        </form>
    </div>

    <div class="bottom-buttons">
        <a href="<%= request.getContextPath() %>/customer/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>