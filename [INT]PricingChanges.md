# [INT] Pricing Changes Guide

This guide explains how to customize pricing in the calculators and remove Amazon-specific pricing exceptions from the visualizer.

## Table of Contents

1. [Changing Calculator Pricing](#changing-calculator-pricing)
2. [Removing Amazon Exception Tracker](#removing-amazon-exception-tracker)
3. [Removing Metered Use / Cloud Billing](#removing-metered-use--cloud-billing)
4. [Testing Your Changes](#testing-your-changes)

---

## Changing Calculator Pricing

The EPP Cost Calculator uses default pricing values that can be modified.

### Location

File: `FalconHealthCheckVisualizer.html`
Lines: ~2894 and ~2903

### Current Default Values

- **Workstation Price:** $36.35 per unit/year
- **Server Price:** $41.00 per unit/year

### How to Change

1. Open `FalconHealthCheckVisualizer.html` in a text editor

2. Search for: `id="workstation-price"`

3. Find this section (around line 2894):
```html
<input type="number" id="workstation-price" value="36.35" step="0.01" min="0"
```

4. Change `value="36.35"` to your desired workstation price

5. Search for: `id="server-price"`

6. Find this section (around line 2903):
```html
<input type="number" id="server-price" value="41.00" step="0.01" min="0"
```

7. Change `value="41.00"` to your desired server price

### Example: Setting Custom Pricing

To set workstation price to $40.00 and server price to $45.00:

```html
<!-- Workstation -->
<input type="number" id="workstation-price" value="40.00" step="0.01" min="0"

<!-- Server -->
<input type="number" id="server-price" value="45.00" step="0.01" min="0"
```

### Notes

- Prices are annual per-unit costs
- The calculator automatically converts to monthly costs (divides by 12)
- Users can still override these values in the UI - these are just the defaults

---

## Removing Amazon Exception Tracker

The Amazon Exception Tracker is a dedicated section that tracks special pricing accommodations for AWS Corporate Production. If you want to remove this feature entirely, follow these steps.

### Step 1: Remove Navigation Menu Item

**Location:** Lines ~1422-1425

**Find:**
```html
<div class="nav-item nav-sub-item" onclick="navigateTo('amazon-exceptions')">
    <span class="nav-icon"></span>
    <span>Amazon Exception Tracker</span>
</div>
```

**Action:** Delete these 4 lines entirely

### Step 2: Remove Route Handler

**Location:** Lines ~1734-1735

**Find:**
```javascript
} else if (view === 'amazon-exceptions') {
    showAmazonExceptions();
```

**Action:** Delete these 2 lines

### Step 3: Remove Function Definition

**Location:** Lines 3068-3287 (entire function)

**Find:** The function starting with:
```javascript
// 3. Amazon Exception Tracker
function showAmazonExceptions() {
    document.getElementById('tabs-container').style.display = 'none';
    const contentContainer = document.getElementById('content');
    contentContainer.innerHTML = '';
    ...
```

**Find the ending:** Around line 3287:
```javascript
        contentContainer.appendChild(infoBox);
    }
```

**Action:** Delete the entire function from line 3068 to line 3287 (inclusive of the comment line above it)

### Quick Search Method

To locate these sections quickly:

1. **Menu Item:** Search for `amazon-exceptions`
2. **Route:** Search for `showAmazonExceptions`
3. **Function:** Search for `// 3. Amazon Exception Tracker`

### What Gets Removed

- Navigation menu item "Amazon Exception Tracker"
- Entire tracking functionality
- AWS Corp Prod specific logic
- Amazon Linux 2 / Amazon Linux 2023 exception tracking
- Summary cards and tables for exceptions

---

## Testing Your Changes

### 1. Test Locally

```bash
# Start local server
python3 -m http.server 8000

# Open browser
open http://localhost:8000/FalconHealthCheckVisualizer.html
```

### 2. Verify Pricing Changes

1. Navigate to **Cost Allocation > EPP Cost Calculator**
2. Check the default values in the pricing inputs
3. Confirm they match your new values
4. Try the "Recalculate Costs" button to ensure calculations work

### 3. Verify Amazon Tracker Removal

1. Expand **Cost Allocation** in the left navigation
2. Confirm "Amazon Exception Tracker" is no longer listed
3. Navigate to other sections to ensure nothing broke
4. Check browser console (F12) for JavaScript errors

### 4. Commit Your Changes

```bash
# Stage changes
git add FalconHealthCheckVisualizer.html

# Commit with descriptive message
git commit -m "Customize pricing and remove Amazon Exception Tracker

- Updated workstation price to $XX.XX
- Updated server price to $XX.XX
- Removed Amazon-specific pricing exception tracking"

# Push to GitHub
git push
```

---

## Removing Metered Use / Cloud Billing

The **Cloud Billing Estimation** (also called "Metered Use" or "Consumption Billing") tracks metered usage for CrowdStrike services. This feature is primarily used by Amazon and not applicable to most CrowdStrike customers. If you want to remove this feature entirely, follow these steps.

### Overview

This feature has three components:
1. **Navigation Menu Items** - "Metered Use" (in hamburger menu) and "Cloud Billing Estimation" (in Cost Allocation)
2. **Route Handler** - Code that responds when users click the menu items
3. **Function Definitions** - Two functions that render the metered use display and charts

### Step 1: Remove Navigation Menu Items

#### Remove "Metered Use" from Hamburger Menu

**Location:** Lines ~1388-1391

**Find:**
```html
<div class="nav-item nav-sub-item" onclick="navigateTo('metered_ng')">
    <span class="nav-icon"></span>
    <span>Metered Use</span>
</div>
```

**Action:** Delete these 4 lines entirely

#### Remove "Cloud Billing Estimation" from Cost Allocation Menu

**Location:** Lines ~1418-1421

**Find:**
```html
<div class="nav-item nav-sub-item" onclick="navigateTo('consumption-billing')">
    <span class="nav-icon"></span>
    <span>Cloud Billing Estimation</span>
</div>
```

**Action:** Delete these 4 lines entirely

### Step 2: Remove Worksheet Display Name Mapping

**Location:** Line ~1699

**Find:**
```javascript
'metered_ng': 'Metered Use'
```

**Action:** Delete this entire line (including the comma at the end)

### Step 3: Remove Route Handler

**Location:** Lines ~1728-1729

**Find:**
```javascript
} else if (view === 'consumption-billing') {
    showConsumptionBilling();
```

**Action:** Delete these 2 lines

### Step 4: Remove Main Function

**Location:** Lines 2016-2430 (entire function, approximately 415 lines)

**Find:** The function starting with:
```javascript
function showConsumptionBilling() {
    document.getElementById('tabs-container').style.display = 'none';
    const contentContainer = document.getElementById('content');
    contentContainer.innerHTML = '';
    contentContainer.style.display = 'block';
    ...
```

**Find the ending:** Around line 2430:
```javascript
        renderConsumptionCharts(contentContainer, meteredData);
    }
```

**Action:** Delete the entire function from line 2016 to line 2430

### Step 5: Remove Charts Rendering Function

**Location:** Lines 2432-2556 (entire function, approximately 125 lines)

**Find:** The function starting with:
```javascript
// Render consumption billing charts
function renderConsumptionCharts(container, meteredData) {
    const chartsGrid = document.createElement('div');
    chartsGrid.className = 'dashboard-charts-grid';
    ...
```

**Find the ending:** Around line 2556:
```javascript
            });
        });
    }
```

**Action:** Delete the entire function from line 2432 to line 2556 (including the comment line above it)

### Quick Search Method

To locate these sections quickly:

1. **Menu Items:** Search for `metered_ng` and `consumption-billing`
2. **Display Name:** Search for `'metered_ng': 'Metered Use'`
3. **Route Handler:** Search for `showConsumptionBilling()`
4. **Main Function:** Search for `function showConsumptionBilling()`
5. **Chart Function:** Search for `function renderConsumptionCharts(`

### What Gets Removed

- **Navigation menu items:** "Metered Use" and "Cloud Billing Estimation"
- **Entire consumption billing/metered use page**
- **Cloud workload calculations** (AWS/Azure/GCP instances)
- **Metered consumption tracking over time**
- **Consumption trend charts**

### Important Notes

**⚠️ Keep these functions:**
- `getChartTextColor()` (around line 2558)
- `getChartGridColor()` (around line 2564)

These helper functions are used by OTHER charts in the visualizer, not just metered use. Only delete up to line 2556.

**⚠️ If you see this comment, STOP:**
```javascript
// Helper function to get chart text color based on current theme
```
This marks where the metered use code ends. Don't delete beyond this point.

---

## Testing Your Changes

### Calculator Not Loading

**Issue:** Cost calculator shows blank or errors
**Solution:** Verify you only changed the `value="XX.XX"` part and didn't modify the HTML structure

### Menu Still Shows Amazon Tracker

**Issue:** Menu item still visible after deletion
**Solution:** Clear browser cache (Cmd+Shift+R on Mac, Ctrl+F5 on Windows)

### JavaScript Errors

**Issue:** Console shows "showAmazonExceptions is not defined" or "showConsumptionBilling is not defined"
**Solution:** Make sure you removed BOTH the route handler (Step 2/3) AND the function definitions (Step 3-5 for respective features)

### Charts Still Show After Removal

**Issue:** Metered use or consumption charts still appear
**Solution:** Clear browser cache (Cmd+Shift+R on Mac, Ctrl+F5 on Windows) and verify you deleted the chart rendering function

### Other Charts Broken After Metered Use Removal

**Issue:** Dashboard or other charts no longer work
**Solution:** You may have deleted the helper functions. Check that these functions still exist around lines 2558-2568:
```javascript
function getChartTextColor() { ... }
function getChartGridColor() { ... }
```
These are shared by all charts. If missing, restore them from the original file.

### Page Won't Load

**Issue:** Visualizer shows completely blank page
**Solution:** You may have deleted too much. Check around line 3289 for this comment:
```javascript
// ==================== END BILLING CALCULATORS ====================
```
This line should remain - only delete content between line 3068 and 3287.

---

## Reverting Changes

If something goes wrong, you can revert to the original version:

```bash
# Check what changed
git diff FalconHealthCheckVisualizer.html

# Discard all changes
git checkout FalconHealthCheckVisualizer.html

# Or revert to last commit
git reset --hard HEAD
```

Alternatively, download the original from GitHub:
https://github.com/ZachHaight/FalconHealthCheck

---

## Summary of Changes

**For Pricing Changes:**
- 2 line modifications (workstation and server values)
- No structural changes
- Low risk

**For Removing Amazon Tracker:**
- ~223 lines deleted
- 3 separate locations modified
- Medium risk - test thoroughly

**For Removing Metered Use / Cloud Billing:**
- ~545 lines deleted
- 5 separate locations modified
- Medium-high risk - test thoroughly
- Note: Most customers don't use this feature (Amazon-specific)

---

## Support

If you encounter issues:
1. Check the browser console for JavaScript errors (F12 → Console tab)
2. Verify JSON syntax if you edited near any commas or brackets
3. Compare with original file on GitHub
4. Test with `python3 -m http.server` before deploying

---

**Last Updated:** 2026-04-21
**Applies to:** FalconHealthCheckVisualizer.html v1.0
