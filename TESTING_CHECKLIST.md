# Falcon Health Check Visualizer - Testing Checklist

**Test URL:** http://localhost:8000/FalconHealthCheckVisualizer.html

**Purpose:** Verify all refactored code works correctly with zero functional changes

---

## Pre-Test Setup

- [x] Development server running on port 8000
- [ ] Browser opened to visualizer
- [ ] Browser console open (F12 → Console tab)
- [ ] Check for any immediate errors

**Expected Console Output:**
- ✅ No errors on page load
- ✅ No warnings (unless DEBUG_MODE = true)
- ✅ Clean console (debug statements gated)

---

## Test 1: Login & RBAC System

### Test 1.1: Admin Login
- [ ] Enter username: `admin`
- [ ] Enter password: `admin123`
- [ ] Click Login
- [ ] **Expected:** Successfully logged in, see user badge "Admin"
- [ ] **Expected:** All navigation items visible
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 1.2: Permission Check
- [ ] Verify "User Management" visible (admin only)
- [ ] Verify "Reporting" visible
- [ ] Verify "Comparison" visible
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 1.3: Session Persistence
- [ ] Refresh page (F5)
- [ ] **Expected:** Still logged in, no login prompt
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 1.4: Logout
- [ ] Click user badge → Logout
- [ ] Confirm logout dialog
- [ ] **Expected:** Redirected to login screen
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 1.5: Viewer Role (Limited Permissions)
- [ ] Login as username: `viewer`, password: `viewer123`
- [ ] **Expected:** "User Management" NOT visible
- [ ] **Expected:** Export buttons disabled/hidden
- [ ] **Result:** ✅ Pass / ❌ Fail
- [ ] Logout for next tests

---

## Test 2: Data Loading

### Test 2.1: Initial Load
- [ ] Login as admin
- [ ] Check "File info" badge shows: "X CIDs | Y Snapshots"
- [ ] **Expected:** Data loaded without errors
- [ ] Check console for fetch errors
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 2.2: Multiple Snapshots
- [ ] Check if multiple snapshot dates available
- [ ] Switch between different snapshot dates
- [ ] **Expected:** Data updates correctly
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 3: Dashboard View

### Test 3.1: Dashboard Rendering
- [ ] Navigate to Dashboard (should be default)
- [ ] **Expected:** See summary cards with metrics
- [ ] **Expected:** Charts render without errors
- [ ] Check console for Chart.js errors
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 3.2: CID Selection
- [ ] Change CID selector dropdown
- [ ] **Expected:** Dashboard updates with new CID data
- [ ] **Expected:** Charts re-render
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 3.3: Chart Visualization
- [ ] Verify "Device Count Trends" chart displays
- [ ] Verify "Sensor Health" chart displays
- [ ] Verify "Detection Trends" chart displays
- [ ] Hover over chart points to see tooltips
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 4: Billing Calculators

### Test 4.1: Consumption Billing
- [ ] Navigate to "Cloud Billing Estimation"
- [ ] **Expected:** Primary metrics displayed
- [ ] **Expected:** Time-based metrics in two columns
- [ ] **Expected:** Consumption trends chart renders
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 4.2: Cloud Pricing Calculator
- [ ] Scroll to "Cloud Workload Pricing Calculator"
- [ ] Modify server price (e.g., 0.01)
- [ ] Modify workstation price (e.g., 0.005)
- [ ] Click "Recalculate Costs"
- [ ] **Expected:** Cost breakdown table updates
- [ ] **Expected:** New hourly/daily/monthly/yearly costs shown
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 4.3: Billing Classification
- [ ] Navigate to "Billing Classification"
- [ ] **Expected:** Summary cards show workstation/server counts
- [ ] **Expected:** Classification table shows OS breakdown
- [ ] Verify workstation OSs labeled correctly (Windows 10/11, macOS)
- [ ] Verify server OSs labeled correctly (Windows Server, Linux)
- [ ] Check for SPECIAL badge (if applicable CID)
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 4.4: Cost Estimator
- [ ] Navigate to "EPP Cost Calculator"
- [ ] **Expected:** Cost summary shows monthly/annual totals
- [ ] Modify workstation annual price
- [ ] Modify server annual price
- [ ] Click "Recalculate Costs"
- [ ] **Expected:** Costs update correctly
- [ ] Verify math: (count * price) / 12 = monthly
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 4.5: Amazon Exceptions Tracker
- [ ] Navigate to "Special Pricing Exception Tracker"
- [ ] **Expected:** Page explains special pricing rules
- [ ] Check if specific CID selected shows exceptions
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 5: Worksheet Views

### Test 5.1: Stats Worksheet
- [ ] Navigate to "Data Sheets" → "Stats"
- [ ] **Expected:** Table with metric name/value pairs
- [ ] Verify metrics display correctly (devices, windows, mac, linux)
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 5.2: Detections Worksheet
- [ ] Navigate to "Detections"
- [ ] **Expected:** Table with severity breakdown
- [ ] Verify total, critical, high, medium, low counts
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 5.3: OS Versions Worksheet
- [ ] Navigate to "Operating System Versions"
- [ ] **Expected:** Table with OS names and counts
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 5.4: Agent Versions Worksheet
- [ ] Navigate to "Agent Versions"
- [ ] **Expected:** Table with agent versions and counts
- [ ] **Expected:** Color indicators (green/yellow/orange/red)
- [ ] **Expected:** Color legend displayed below table
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 5.5: Date Selector
- [ ] Change snapshot date selector (if multiple dates)
- [ ] **Expected:** Worksheet data updates
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 5.6: Delta Indicators
- [ ] Toggle "Show Change Indicators" (if available)
- [ ] Change to different snapshot
- [ ] **Expected:** See +/- delta values for numeric changes
- [ ] Green for positive, red for negative
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 6: Reporting & Export

### Test 6.1: Single Worksheet Export
- [ ] Navigate to any worksheet (e.g., "Stats")
- [ ] Click "Export to CSV" button
- [ ] **Expected:** CSV file downloads
- [ ] Open CSV file
- [ ] **Expected:** Proper formatting with headers
- [ ] **Expected:** Metadata section (Company, CID, Date)
- [ ] **Expected:** Data section with values
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 6.2: Bulk Export
- [ ] Navigate to "Reporting"
- [ ] Select 2-3 CIDs in "Bulk Export" section
- [ ] Select 2-3 worksheets
- [ ] Click "Run Bulk Export"
- [ ] **Expected:** ZIP file downloads
- [ ] **Expected:** Filename: Falcon_Bulk_Export_YYYY-MM-DD_HH-MM-SS.zip
- [ ] Extract ZIP
- [ ] **Expected:** Multiple CSV files inside
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 6.3: Schedule Configuration
- [ ] Scroll to "Scheduled Reporting"
- [ ] Enter schedule name
- [ ] Select frequency (e.g., "Daily")
- [ ] Select scope (e.g., "All CIDs")
- [ ] Select sheets (e.g., "All sheets")
- [ ] Click "Save Schedule"
- [ ] **Expected:** Success alert
- [ ] **Expected:** Schedule appears in "Active Schedules"
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 6.4: Delete Schedule
- [ ] Find saved schedule in "Active Schedules"
- [ ] Click "Delete" button
- [ ] Confirm deletion
- [ ] **Expected:** Schedule removed from list
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 6.5: Automation Script
- [ ] Click "Download Automation Script"
- [ ] **Expected:** Shell script downloads (.sh file)
- [ ] Open script
- [ ] **Expected:** Contains bash automation template
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 7: Comparison Tools

### Test 7.1: Basic Comparison
- [ ] Navigate to "Side-by-Side Comparison"
- [ ] Select snapshot date
- [ ] Select worksheet (e.g., "Stats")
- [ ] Select first CID (CID A)
- [ ] Select different CID (CID B)
- [ ] **Expected:** Comparison table renders
- [ ] **Expected:** Three columns (Metric | CID A | CID B)
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 7.2: Diff Highlighting
- [ ] Check "Highlight Differences"
- [ ] **Expected:** Rows with different values highlighted yellow
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 7.3: Delta Calculation
- [ ] Check "Show Delta"
- [ ] **Expected:** Fourth column appears with change values
- [ ] **Expected:** Green for positive, red for negative
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 7.4: Comparison Export
- [ ] Click "Export Comparison"
- [ ] **Expected:** CSV downloads
- [ ] Open CSV
- [ ] **Expected:** Side-by-side comparison data
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 7.5: Same CID Validation
- [ ] Select same CID for both A and B
- [ ] **Expected:** Warning message: "Please select two different CIDs"
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 8: User Management (Admin Only)

### Test 8.1: View User Management
- [ ] Ensure logged in as admin
- [ ] Navigate to "User Management"
- [ ] **Expected:** Current session info displayed
- [ ] **Expected:** Roles & permissions matrix shown
- [ ] **Expected:** Demo users list shown
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 8.2: Role Permissions Display
- [ ] Verify permissions table shows all roles
- [ ] Admin: All permissions
- [ ] Analyst: View, Export, Reporting, Comparison
- [ ] Viewer: View only
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 9: Theme Switching

### Test 9.1: Toggle to Dark Mode
- [ ] Click theme toggle button (moon/sun icon)
- [ ] **Expected:** Background becomes dark
- [ ] **Expected:** Text becomes light
- [ ] **Expected:** Charts re-render with dark colors
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 9.2: Toggle to Light Mode
- [ ] Click theme toggle again
- [ ] **Expected:** Background becomes light
- [ ] **Expected:** Text becomes dark
- [ ] **Expected:** Charts re-render with light colors
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 9.3: Theme Persistence
- [ ] Set theme to dark
- [ ] Refresh page (F5)
- [ ] **Expected:** Theme remains dark after reload
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 10: Browser Console Validation

### Test 10.1: Console Cleanliness
- [ ] Open browser console (F12 → Console)
- [ ] Navigate through all views
- [ ] **Expected:** No console errors (red)
- [ ] **Expected:** No console warnings (yellow)
- [ ] **Expected:** No console.log spam (DEBUG_MODE = false)
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 10.2: Error Messages Preserved
- [ ] Check if any console.error messages appear
- [ ] **Expected:** Only legitimate errors (e.g., missing data)
- [ ] **Expected:** User-friendly error messages in UI
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 11: Mobile/Responsive (Optional)

### Test 11.1: Browser Resize
- [ ] Resize browser window to narrow width
- [ ] **Expected:** Layout adapts reasonably
- [ ] **Expected:** No major UI breaks
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 12: Performance

### Test 12.1: Load Time
- [ ] Clear browser cache
- [ ] Reload page
- [ ] **Expected:** Page loads within 3-5 seconds
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 12.2: Chart Rendering Speed
- [ ] Navigate to dashboard
- [ ] **Expected:** Charts render within 2 seconds
- [ ] No visible lag or freezing
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 12.3: Large Export
- [ ] Try bulk export with all CIDs and all sheets
- [ ] **Expected:** Export completes within 10-15 seconds
- [ ] Browser doesn't freeze
- [ ] **Result:** ✅ Pass / ❌ Fail

---

## Test 13: Edge Cases

### Test 13.1: No Data Scenarios
- [ ] Select CID with no metered data
- [ ] Navigate to "Cloud Billing Estimation"
- [ ] **Expected:** "No metered data available for this CID" message
- [ ] **Result:** ✅ Pass / ❌ Fail

### Test 13.2: Session Timeout (Optional - 24hr test)
- [ ] Login and leave browser open for 24+ hours
- [ ] Try to perform action
- [ ] **Expected:** Auto-logout due to session expiration
- [ ] **Result:** ✅ Pass / ❌ Fail (or skip if impractical)

---

## Final Validation

### Code Quality Checks
- [ ] All tests passed
- [ ] No console errors observed
- [ ] No functional regressions
- [ ] All features work as before refactoring

### Documentation Verification
- [ ] JSDoc comments match function behavior
- [ ] Architecture doc accurately describes system
- [ ] No misleading documentation

### Git Status
- [ ] All changes committed
- [ ] Repository pushed to GitHub
- [ ] No uncommitted changes

---

## Test Results Summary

**Total Tests:** ~60 test cases
**Passed:** _____ / ~60
**Failed:** _____ / ~60
**Skipped:** _____ / ~60

**Overall Status:** ✅ Pass / ⚠️ Minor Issues / ❌ Major Issues

**Notes:**
_______________________________________________________
_______________________________________________________
_______________________________________________________

---

## If Issues Found

1. **Document the issue:**
   - What test failed?
   - What was expected?
   - What actually happened?
   - Error messages in console?

2. **Check git diff:**
   ```bash
   git diff HEAD~12 FalconHealthCheckVisualizer.html
   ```

3. **Isolate the problem:**
   - Which phase introduced the issue?
   - Can you reproduce consistently?

4. **Fix and re-test:**
   - Make targeted fix
   - Re-run failed test
   - Run full suite again

5. **Commit fix:**
   ```bash
   git add FalconHealthCheckVisualizer.html
   git commit -m "Fix: [description of issue]"
   git push
   ```

---

## Cleanup After Testing

```bash
# Stop development server
kill $(cat /tmp/value_server.pid)
rm /tmp/value_server.pid

# Or if needed:
lsof -ti:8000 | xargs kill -9
```

---

**Tester:** _______________
**Date:** _______________
**Browser:** _______________
**Status:** _______________
