# Email Verification Guide

## 📧 Current Email Verification Process

### How It Works

1. **User Signs Up** with their email address
2. **Email Validation** checks:
   - Valid email format (RFC 5322 compliant)
   - Not a fake/test email pattern (test@, user@, example@, etc.)
   - Not a disposable email service (tempmail.com, 10minutemail.com, etc.)
   - Real email domain exists

3. **Verification Token Generated**: A secure 32-byte random token is created
4. **Email Sent**: Verification email sent to the address they signed up with
5. **User Clicks Link**: Opens verification URL with token
6. **Account Verified**: Email marked as verified in database

---

## ✅ Email Validation Rules

The system currently validates that emails are:

- **Format**: Valid email address format (name@domain.com)
- **Not Fake Patterns**: Rejects test@, user@, admin@, example@, etc.
- **Not Disposable**: Blocks temporary email services
- **Real Domain**: Domain must be properly formatted

### Valid Email Examples:
```
✅ john@gmail.com
✅ sarah@company.com
✅ user@example.org
✅ contact@yourname.com
```

### Invalid Email Examples:
```
❌ test@example.com (fake pattern)
❌ user123@gmail.com (fake pattern)
❌ admin@test.com (fake pattern)
❌ name@tempmail.com (disposable)
❌ invalid.email (no @)
❌ @domain.com (no local part)
```

---

## 📬 Where Verification Code Goes

**The verification code is sent to the email address the user provided during signup.**

### Current Setup (Development Mode)

Since email credentials are not configured, the system logs the verification link to the terminal:

```
📧 ============================================
📧 Verification email would be sent to: john@gmail.com
🔗 Verification link: http://localhost:5173/verify-email?token=abc123...
📧 ============================================
```

**To use this link:**
1. Copy the verification link from the terminal
2. Paste it in your browser
3. Email is verified

---

## 🔧 Configure Real Email Sending (Gmail)

To enable automatic email sending, add these to your `.env` file:

### Gmail Setup:

1. **Enable 2-Factor Authentication** on your Google Account
2. **Generate App Password**:
   - Go to [myaccount.google.com/security](https://myaccount.google.com/security)
   - Select "App Passwords"
   - Choose "Mail" and "Windows Computer" (or your device)
   - Copy the generated 16-character password

3. **Add to `.env`**:
```
EMAIL_SERVICE=gmail
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=xxxx xxxx xxxx xxxx
FRONTEND_URL=http://localhost:5174
```

### Other Email Services:

For Outlook/Hotmail:
```
EMAIL_SERVICE=outlook
EMAIL_USER=your-email@outlook.com
EMAIL_PASS=your-password
FRONTEND_URL=http://localhost:5174
```

For custom SMTP:
```
EMAIL_SERVICE=custom
EMAIL_HOST=smtp.provider.com
EMAIL_PORT=587
EMAIL_USER=your-email@provider.com
EMAIL_PASS=your-password
FRONTEND_URL=http://localhost:5174
```

---

## 📋 Database Schema

### Users Table (Email Fields)
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(100) NOT NULL UNIQUE,           -- Email user signed up with
  email_verified INT DEFAULT 0,                  -- 1 = verified, 0 = not verified
  verification_token VARCHAR(255),              -- Secure random token
  verification_token_expires DATETIME,          -- Token expires in 24 hours
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔐 Security Features

1. **Email Validation**:
   - Prevents fake/test emails
   - Blocks disposable email services
   - Validates RFC 5322 format

2. **Token Security**:
   - 32-byte cryptographic random token
   - Expires after 24 hours
   - Can only be used once
   - Stored as hash in database

3. **Database**:
   - Email is UNIQUE (no duplicate emails)
   - Token can be NULL after verification
   - Proper timestamps for audit trail

---

## 🧪 Testing Email Verification

### Development Testing (No Real Email):

1. **Sign up** with a valid email: `john@company.com`
2. **Get verification link** from terminal output
3. **Copy link** and paste in browser
4. **Click verify** to mark email as verified
5. **Login** with verified account

### Production Testing (With Real Email):

1. **Configure email credentials** in `.env`
2. **Sign up** with your real email
3. **Check inbox** for verification email
4. **Click link** in email to verify
5. **Login** to your account

---

## ❌ Common Issues & Solutions

### Issue: "Please use a real email address"
**Solution**: You used an email pattern that looks fake (test@, user@, etc.)
- Use a real email address
- Examples: yourname@company.com, john@gmail.com

### Issue: "Email Already Registered"
**Solution**: This email is already in use
- Use a different email
- Or request password reset if it's your account

### Issue: Verification link not received
**Solution**: Email service not configured
- Use the link from terminal output
- Or configure real email service with Gmail/Outlook credentials

### Issue: "Invalid email format"
**Solution**: Email doesn't follow proper format
- Use format: name@domain.com
- Avoid spaces and special characters

---

## 🔄 Resend Verification Email

If user doesn't receive the first email:

```
POST /api/auth/resend-verification
Body: { "email": "john@company.com" }
```

New token is generated and new email sent (or logged in development mode)

---

## 📊 Email Status in Database

Check user email verification status:

```bash
# Connect to MySQL
mysql -u root cbt_anxiety_db

# Check email verification status
SELECT id, email, email_verified, created_at FROM users WHERE email = 'john@company.com';
```

Result columns:
- **email_verified = 0**: Not yet verified
- **email_verified = 1**: Verified and can login

---

## 📝 Summary

| Aspect | Details |
|--------|---------|
| **Email Validation** | Format + no fake patterns + no disposables |
| **Verification Code Location** | Sent to the email address provided during signup |
| **Token Expiry** | 24 hours |
| **Current Mode** | Development (logs to terminal) |
| **Configure Email** | Add EMAIL_USER and EMAIL_PASS to .env |

