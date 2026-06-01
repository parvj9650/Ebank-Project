<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complete Your Profile - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .form-box {
            background: white;
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--shadow);
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

        .save-btn {
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

        .save-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
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

        .info-note {
            background: #dbeafe;
            color: #1e40af;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #3b82f6;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }
    </style>
</head>
<body>

<div class="form-container">
    <div class="page-header">
        <h2>📝 Complete Your Profile</h2>
    </div>

    <div class="form-box">
        <div class="info-note">
            <span>ℹ️</span>
            <span>Please provide accurate information. This will be used for verification purposes.</span>
        </div>

        <%
        String error = (String) request.getAttribute("error");
        if(error != null){
        %>
            <div class="error-message">
                <span>⚠</span> <%= error %>
            </div>
        <%
        }
        %>

        <form action="<%=request.getContextPath()%>/saveCustomerProfile" method="post">
            <div class="form-group">
                <label>📝 Full Name</label>
                <input type="text" name="name" placeholder="Enter your full name" required>
            </div>

            <div class="form-group">
                <label>🏠 Address</label>
                <textarea name="address" placeholder="Enter your complete address" required></textarea>
            </div>

            <div class="form-group">
                <label>📧 Email Address</label>
                <input type="email" name="email" placeholder="you@example.com" required>
            </div>

            <div class="form-group">
                <label>📱 Phone Number</label>
                <input type="text" name="phone" placeholder="10-digit mobile number" required>
            </div>

            <div class="form-group">
                <label>🎂 Date of Birth</label>
                <input type="date" name="dob" required>
            </div>

            <button type="submit" class="save-btn">💾 Save Profile</button>
        </form>
    </div>

    <div class="bottom-buttons">
        <a href="<%= request.getContextPath() %>/login.jsp" class="back-btn">← Back to Login Page</a>
    </div>
</div>

</body>
</html>