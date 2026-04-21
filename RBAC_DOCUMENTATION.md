# Role-Based Access Control (RBAC) System

## Overview

The CrowdStrike Falcon Health Check Visualizer now includes a comprehensive Role-Based Access Control system that provides secure, granular access management for different user types.

---

## 🔐 User Roles

### 1. Administrator
**Username:** `admin` | **Password:** `admin123`

**Permissions:**
- ✅ View all data
- ✅ Export single files (CSV)
- ✅ Bulk export (ZIP)
- ✅ Access reporting features
- ✅ Side-by-side comparison
- ✅ User management

**Use Case:** Full system access for IT administrators and security team leads

---

### 2. Security Manager
**Username:** `manager` | **Password:** `manager123`

**Permissions:**
- ✅ View all data
- ✅ Export single files (CSV)
- ❌ Bulk export (ZIP)
- ✅ Access reporting features
- ✅ Side-by-side comparison
- ❌ User management

**Use Case:** Security managers who need data analysis and reporting capabilities but not bulk export

---

### 3. Security Analyst
**Username:** `analyst` | **Password:** `analyst123`

**Permissions:**
- ✅ View all data
- ✅ Export single files (CSV)
- ❌ Bulk export (ZIP)
- ❌ Access reporting features
- ❌ Side-by-side comparison
- ❌ User management

**Use Case:** Day-to-day analysts who need to view and export individual data sheets

---

### 4. Read-Only Viewer
**Username:** `viewer` | **Password:** `viewer123`

**Permissions:**
- ✅ View all data
- ❌ Export single files (CSV)
- ❌ Bulk export (ZIP)
- ❌ Access reporting features
- ❌ Side-by-side comparison
- ❌ User management

**Use Case:** Stakeholders who need visibility but not data extraction capabilities

---

## 🎨 UI Features

### Login Screen
- **Professional login modal** with CrowdStrike branding
- Username and password authentication
- Error handling for invalid credentials
- Demo account credentials displayed for convenience
- Secure session management with localStorage

### User Badge
- **Visible in header** after successful login
- Displays user's full name
- Shows current role
- Logout button for session termination

### Permission-Based UI
- **Hidden navigation items** based on role
  - Reporting tab (managers and admins only)
  - Comparison tab (managers and admins only)
  - User Management tab (admins only)
- **Disabled export buttons** for viewers
- **Permission denied alerts** when attempting unauthorized actions

---

## 🔒 Security Features

### Session Management
- **24-hour session expiry** - automatic logout after 24 hours
- **LocalStorage-based** session persistence (survives page refreshes)
- **Session validation** on page load
- **Secure logout** with confirmation dialog

### Permission Checks
- **Function-level validation** before executing sensitive operations
- **Export permission** checked before CSV generation
- **Bulk export permission** checked before ZIP creation
- **Comparison permission** checked before rendering comparison view
- **User management permission** checked before accessing admin panel

### User Alerts
- **Permission denied dialogs** with clear messaging
- Shows current role and required permission
- Action-specific descriptions

---

## 📊 User Management Dashboard

Available to **Administrators only** via the 👥 User Management tab.

### Features:
1. **Current Session Info**
   - Logged-in user details
   - Role and permissions
   - Login timestamp

2. **Roles & Permissions Matrix**
   - Complete permission grid
   - Visual checkmarks (✅) and crosses (❌)
   - Easy reference for all roles

3. **Demo User Accounts Table**
   - All available accounts
   - Usernames, roles, and passwords
   - Active session indicator

4. **Permission Descriptions**
   - Detailed explanation of each permission
   - Use case guidance

5. **Production Implementation Notes**
   - SSO integration recommendations
   - Security best practices
   - Audit logging requirements
   - MFA recommendations

---

## 🚀 Usage

### Logging In
1. Open `visualizer.html` in your browser
2. Login modal appears automatically
3. Select a demo account or enter credentials
4. Click **Login**
5. Dashboard loads with appropriate permissions

### Switching Users
1. Click **Logout** button in header
2. Confirm logout
3. Page reloads to login screen
4. Login with different credentials

### Testing Permissions
1. Login as **viewer** (viewer/viewer123)
   - Try to export - permission denied
   - Try to access Reporting - hidden
2. Login as **analyst** (analyst/analyst123)
   - Can export single files
   - Cannot access Reporting or Comparison
3. Login as **manager** (manager/manager123)
   - Full access except bulk export and user management
4. Login as **admin** (admin/admin123)
   - Complete system access

---

## 🛠️ Technical Implementation

### Architecture
```javascript
// Role definitions
const ROLES = {
    admin: { permissions: ['view', 'export', 'bulk_export', 'reporting', 'comparison', 'user_management'] },
    manager: { permissions: ['view', 'export', 'reporting', 'comparison'] },
    analyst: { permissions: ['view', 'export'] },
    viewer: { permissions: ['view'] }
};

// Current user session
let currentUser = {
    username: string,
    fullName: string,
    role: string,
    permissions: array,
    loginTime: timestamp
};
```

### Key Functions
- `initRBAC()` - Initialize RBAC system on page load
- `handleLogin(event)` - Process login form submission
- `handleLogout()` - Clear session and reload page
- `hasPermission(permission)` - Check if user has specific permission
- `checkPermissionOrAlert(permission, action)` - Check permission or show alert
- `applyPermissions()` - Apply UI restrictions based on role
- `showUserManagement()` - Render user management dashboard

### Storage
- **localStorage key:** `falconSession`
- **Format:** JSON object with user session data
- **Expiry:** 24 hours from login time

---

## 🔄 Future Enhancements

### Authentication
- [ ] Enterprise SSO integration (SAML, OAuth 2.0)
- [ ] LDAP/Active Directory support
- [ ] Multi-factor authentication (MFA)
- [ ] Biometric authentication support

### User Management
- [ ] Admin UI to create/edit/delete users
- [ ] Custom role creation with permission builder
- [ ] User invitation system via email
- [ ] Password reset functionality
- [ ] Account lockout after failed attempts

### Security
- [ ] Backend API authentication
- [ ] JWT token-based sessions
- [ ] Encrypted credential storage
- [ ] Audit log of all user actions
- [ ] IP whitelisting
- [ ] Rate limiting for API calls

### Session Management
- [ ] Configurable session timeout
- [ ] Idle timeout detection
- [ ] Remember me functionality
- [ ] Concurrent session limits
- [ ] Force logout of specific users

### Compliance
- [ ] GDPR compliance features
- [ ] SOC 2 audit trail
- [ ] Role change notifications
- [ ] Privacy policy acceptance
- [ ] Terms of service tracking

---

## 📝 Migration Notes

### From No Auth to RBAC
- **Existing users:** Will see login screen on next visit
- **Default admin:** Use `admin/admin123` to regain access
- **Session persistence:** Users stay logged in across page refreshes
- **Data access:** All data remains accessible, just permission-controlled

### Production Deployment
1. **Replace demo users** with real user database
2. **Implement backend authentication** API
3. **Add password hashing** (bcrypt, argon2)
4. **Configure SSO** provider (Okta, Auth0, Azure AD)
5. **Set up audit logging** database
6. **Enable HTTPS** for secure transmission
7. **Configure session** timeout policies
8. **Add MFA** for admin accounts

---

## 🆘 Support & Troubleshooting

### Common Issues

**Issue:** Forgot password
- **Solution:** Use demo credentials from login screen, or contact admin to reset

**Issue:** Session expired
- **Solution:** Login again (24-hour expiry)

**Issue:** Permission denied
- **Solution:** Contact admin to request role upgrade

**Issue:** Can't see navigation items
- **Solution:** Normal behavior - items hidden based on role

**Issue:** Export button doesn't work
- **Solution:** Check your role has export permission

---

## 📊 Permission Matrix Quick Reference

| Permission | Admin | Manager | Analyst | Viewer |
|------------|-------|---------|---------|--------|
| View Data | ✅ | ✅ | ✅ | ✅ |
| Export Single | ✅ | ✅ | ✅ | ❌ |
| Bulk Export | ✅ | ❌ | ❌ | ❌ |
| Reporting | ✅ | ✅ | ❌ | ❌ |
| Comparison | ✅ | ✅ | ❌ | ❌ |
| User Management | ✅ | ❌ | ❌ | ❌ |

---

**The RBAC system provides enterprise-grade access control while maintaining simplicity and ease of use!**
