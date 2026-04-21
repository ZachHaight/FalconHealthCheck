# CrowdStrike Falcon Health Check Visualizer - Functionality Summary

## Executive Overview

The **CrowdStrike Falcon Health Check Visualizer** is a comprehensive web-based dashboard for analyzing and visualizing CrowdStrike Falcon endpoint security data across multiple AWS environments. It provides real-time insights into device health, security detections, policy compliance, and agent configurations across 81 Customer IDs (CIDs) using historical snapshot data.

---

## Core Purpose

This tool transforms CrowdStrike Falcon Health Check JSON exports into an interactive, visual analytics platform, enabling security teams to:
- Monitor endpoint security posture across multiple customer environments
- Track security trends over time (up to 5 historical snapshots)
- Identify compliance gaps and policy issues
- Analyze detection patterns and threat severity
- Monitor agent version distributions and update compliance
- Perform bulk exports across multiple environments
- Compare security postures between different CIDs

---

## Key Features

### 1. Dashboard Landing Page 🏠

**Purpose:** Executive-level overview of security posture

**Features:**
- **8 Key Metric Cards** displaying critical statistics:
  - Total Devices
  - Online Devices
  - Policy Score (0-100)
  - Critical Policy Score (0-100)
  - Windows Device Count
  - Mac Device Count
  - Linux Device Count
  - Total Security Detections

- **4 Comprehensive Trend Charts** (2x2 grid):
  - **Device Count Trends:** Total vs Online devices over time
  - **Detection Severity Trends:** Critical, High, Medium, Low threat levels
  - **Policy Score Trends:** Overall and Critical policy compliance
  - **Platform Distribution:** Windows, Mac, Linux breakdowns

- **CID Selector:** Dropdown to switch between 81 customer environments
- **Live Date Display:** Shows current snapshot date

---

### 2. Multi-Snapshot Timeline Analysis 📅

**Capabilities:**
- Loads 5 historical health check JSON files automatically
- Snapshots range from Feb 26, 2026 to Mar 19, 2026
- Date selector dropdown for switching between time periods
- Chronological ordering (newest first)
- Displays timestamps in human-readable format

**Data Files:**
- `Falcon_Health_Check_Stats_2026-02-26_15-46-10_7-day_90-day.json`
- `Falcon_Health_Check_Stats_2026-03-05_22-17-11_7-day_90-day.json`
- `Falcon_Health_Check_Stats_2026-03-12_12-17-58_7-day_90-day.json`
- `Falcon_Health_Check_Stats_2026-03-13_12-15-53_7-day_90-day.json`
- `Falcon_Health_Check_Stats_2026-03-19_12-15-25_7-day_90-day.json`

---

### 3. Delta/Change Tracking ⚡

**Purpose:** Identify changes between consecutive snapshots

**Features:**
- Toggle button: "△ Changes: ON/OFF"
- Shows numeric deltas from previous snapshot
- Color-coded indicators:
  - **Red:** Increases (potential concerns)
  - **Green:** Decreases (improvements)
- Format: `current_value (+/- delta)`
- Works for all numeric metrics across all data sheets

---

### 4. Navigation System 📋

**Left Sidebar Menu:**
- **Always-visible fixed navigation** (250px width)
- **Collapsible hamburger menu** (☰) for maximizing viewing space
- **11 Navigation Categories:**
  1. 🏠 Dashboard (landing page)
  2. 📈 Stats (device and policy metrics)
  3. 🔄 Sensor Updates (agent update policies)
  4. 🚨 Detections (security alerts and threats)
  5. 💻 Operating System Versions (OS distribution)
  6. 🔧 Agent Versions (Falcon agent versions)
  7. 🔐 2026 Certificate Rotation (SSL cert compliance)
  8. 📋 Policy Scores (compliance metrics)
  9. 🛡️ Prevention Toggles (security feature enablement)
  10. ⚙️ Module Enablement (feature flags)
  11. 📊 Reporting (bulk export and scheduling)
  12. ⚖️ Comparison (side-by-side CID comparison)

**Design:**
- Dark theme (#1a1a1a) with red accent highlights
- Active page highlighted in red
- Smooth hover effects and transitions
- Responsive design (collapses on mobile)

---

### 5. Detailed Data Sheets 📊

Each data sheet provides granular visibility into specific security domains:

#### **Stats Sheet**
- **39 metrics per CID** including:
  - Device counts by type (workstations, servers, domain controllers)
  - Online/offline status
  - RFM (Reduced Functionality Mode) devices
  - Sensor age distribution
  - Policy scores
  - Telemetry counts
- **Structure:** Name-value pairs
- **Trend Analysis:** ✅ Supported

#### **Sensor Updates Sheet**
- **27 update policies per CID**
- **8 columns:**
  - Policy ID, Active Devices, Policy Name
  - Platform, Agent Version, Support End Date
  - Uninstall Protection, Color Status
- **Visual Color Key Legend:**
  - 🟢 **Green:** Current / N-1 - Sensor is on current or previous version (supported)
  - 🟡 **Yellow:** N-2 Version - Sensor is two versions behind (update recommended)
  - 🟠 **Orange:** N-3 or Older - Sensor is three+ versions behind (update needed)
  - 🔴 **Red:** Unsupported / Critical - Sensor version is no longer supported
  - ⚫ **Gray:** Inactive / No Data - Policy inactive or status unknown
- **Structure:** Multi-column table
- **Trend Analysis:** ❌ Not supported (too granular)

#### **Detections Sheet**
- **5 data categories:**
  1. **Status:** New, In Progress, True Positive, False Positive, Ignored, Closed, Reopened
  2. **Severity:** Critical, High, Medium, Low, Informational
  3. **Disposition:** Resolution types
  4. **Platform:** OS breakdown
  5. **Tactics:** 21 MITRE ATT&CK tactics
- **Structure:** Multiple arrays
- **Trend Analysis:** ✅ Supported (severity tracking)

#### **Operating System Versions Sheet**
- **65+ OS versions per CID**
- Shows device distribution across OS types
- Example: Amazon Linux 2, Windows Server 2019, macOS 13.x
- **Structure:** Name-value pairs
- **Trend Analysis:** ❌ Not supported (too many variations)

#### **Agent Versions Sheet**
- **123 unique agent versions per CID**
- **5 columns:**
  - Agent Version, Platform, Expiration Date
  - Color Status, Device Count
- Color-coded compliance indicators
- **Visual Color Key Legend:**
  - 🟢 **Green:** Up to Date / Compliant - Agent version is current and supported
  - 🟡 **Yellow:** Nearing Expiration - Agent version support ending soon
  - 🟠 **Orange:** Update Recommended - Agent version should be updated
  - 🔴 **Red:** Expired / Non-Compliant - Agent version is outdated or expired
  - ⚫ **Black:** Unknown / No Data - Status cannot be determined
- **Structure:** Multi-column table
- **Trend Analysis:** ❌ Not supported (version-specific)

#### **2026 Certificate Rotation Sheet**
- **Same structure as Agent Versions** (123 entries)
- Tracks SSL certificate compliance for 2026 rollover
- Critical for maintaining connectivity
- Color-coded status indicators
- **Visual Color Key Legend** (same as Agent Versions)
- **Trend Analysis:** ❌ Not supported

#### **Policy Scores Sheet**
- **10 compliance metrics per CID**
- Includes overall policy score and critical policy score
- Granular breakdown of score components
- **Structure:** Name-value pairs
- **Trend Analysis:** ✅ Supported

#### **Prevention Toggles Sheet**
- **112 security features per CID**
- **7 columns:**
  - Platform, Toggle API Name, Toggle Name
  - Enabled Count, Disabled Count
  - Policy Score Impact, Disable Percentage
- Shows feature adoption across policies
- **Structure:** Multi-column table
- **Trend Analysis:** ✅ Supported (aggregated enabled/disabled)

#### **Module Enablement Sheet**
- **87 feature flags per CID**
- Shows which features are enabled/configured
- Example: Detection emails, notification settings
- **Structure:** Name-value pairs
- **Trend Analysis:** ❌ Not supported

---

### 6. Trend Visualization System 📈

**Supported Sheets:** Stats, Detections, Policy Scores, Prevention Toggles

**Features:**
- **"View Trends" button** on supported sheets
- **Full-screen modal** with interactive Chart.js charts
- **Time-series line charts** across all 5 snapshots
- **Per-CID tracking** (filters data for selected customer)
- **Color-coded metrics** for easy identification
- **Interactive tooltips** showing exact values
- **Smooth curves** with tension and fill effects

**Chart Configuration:**
- Dark theme compatibility (white text, colored lines)
- Responsive sizing (max-height: 250px)
- Legends positioned at top
- Automatic scaling and gridlines

---

### 7. CSV Export Functionality 📥

**Purpose:** Enable data extraction and offline analysis

**Features:**
- **Export Button:** Green "📥 Export CSV" button on all data sheets
- **Location:** Top controls row (alongside Date, CID, Changes, Trends)
- **Scope:** Exports current sheet data for selected CID and snapshot

**CSV File Format:**
1. **Metadata Header Section:**
   - CrowdStrike Falcon Health Check Export title
   - Company name
   - Customer ID (CID)
   - Data sheet name
   - Snapshot date
   - Export date/time

2. **Data Section:**
   - **Simple sheets** (Stats, Policy Scores, OS Versions):
     - Two-column format: Metric | Value
   - **Complex sheets** (Agent Versions, Sensor Updates, Prevention Toggles):
     - Multi-column format with all fields
     - Column headers from data structure
   - **Multi-array sheets** (Detections):
     - Separate sections for each data category
     - Section headers in UPPERCASE
     - Individual tables for each array

3. **CSV Standards Compliance:**
   - Proper escaping of commas, quotes, newlines
   - UTF-8 encoding
   - Compatible with Excel, Google Sheets, and CSV tools

**Filename Convention:**
```
falcon_[worksheet]_[company_name]_[YYYY-MM-DD].csv
```
**Example:** `falcon_stats_aws_corporate_production_2026-03-27.csv`

**Use Cases:**
- Offline analysis and reporting
- Data archival and backup
- Import into BI tools (Tableau, Power BI)
- Compliance documentation
- Custom analysis in Excel/Python/R
- Sharing with stakeholders without system access

---

### 8. Color Legend System 🎨

**Purpose:** Visual interpretation guide for status indicators

**Sheets with Color Legends:**
- Agent Versions
- 2026 Certificate Rotation
- Sensor Updates

**Legend Design:**
- Displayed prominently at top of sheet (below summary cards)
- Light gray background (#f8f9fa) with black border
- Responsive grid layout (auto-fits to screen width)
- Each color includes:
  - Visual color square (16×16px with black border)
  - Bold label describing status
  - Descriptive text explaining meaning

**Color Code Meanings:**

**For Agent Versions & Certificate Rotation:**

| Color | Label | Description | Use Case |
|-------|-------|-------------|----------|
| 🟢 Green | Up to Date / Compliant | Agent version is current and supported | Good standing |
| 🟡 Yellow | Nearing Expiration | Agent version support ending soon | Plan updates |
| 🟠 Orange | Update Recommended | Agent version should be updated | Take action |
| 🔴 Red | Expired / Non-Compliant | Agent version is outdated or expired | Critical issue |
| ⚫ Black | Unknown / No Data | Status cannot be determined | Investigate |

**For Sensor Updates:**

| Color | Label | Description | Use Case |
|-------|-------|-------------|----------|
| 🟢 Green | Current / N-1 | Sensor on current or previous version | Supported |
| 🟡 Yellow | N-2 Version | Sensor two versions behind | Update recommended |
| 🟠 Orange | N-3 or Older | Sensor three+ versions behind | Update needed |
| 🔴 Red | Unsupported / Critical | Sensor version no longer supported | Critical |
| ⚫ Gray | Inactive / No Data | Policy inactive or status unknown | Investigate |

**Benefits:**
- Immediate visual understanding of agent status
- Reduces confusion about color meanings
- Standardizes interpretation across teams
- Improves reporting clarity
- Supports audit and compliance documentation

---

### 9. Bulk Export & Reporting System 📦

**Purpose:** Advanced data extraction and reporting capabilities

**Location:** Reporting tab in sidebar navigation

#### **Bulk Export Features:**

**Selection Controls:**
- **Snapshot Date Selector:** Choose which historical snapshot to export
- **CID Selection:**
  - "Select All CIDs" checkbox (all 81 environments)
  - Individual CID checkboxes with company names
  - Scrollable list with responsive grid layout
- **Data Sheet Selection:**
  - "Select All Sheets" checkbox
  - Individual sheet checkboxes for all 9 data types
  - Multi-select capability

**Export Process:**
- **ZIP Packaging:** All selected combinations bundled into single file
- **Folder Structure:** Organized by sheet name
- **Filename Format:** `falcon_bulk_export_YYYY-MM-DD.zip`
- **File Contents:** Individual CSV for each CID/Sheet combination
- **Progress Feedback:** Real-time status messages during generation

**Technical Implementation:**
- Uses JSZip library (dynamically loaded from CDN)
- Creates folder hierarchy: `[Sheet Name]/[CID files]`
- Maintains CSV metadata headers in each file
- Proper filename sanitization for cross-platform compatibility

#### **Scheduled Export Configuration:**

**Schedule Settings:**
- **Schedule Name:** Custom identifier for the configuration
- **Frequency Options:**
  - Daily (24-hour interval)
  - Weekly (7-day interval)
  - Monthly (30-day interval)
  - Custom Interval (user-defined hours)
- **Export Scope:**
  - Single CID (current selection)
  - All CIDs (all 81 environments)
  - Selected CIDs (custom subset with checkboxes)
- **Data Sheet Selection:**
  - All Sheets
  - Stats Only
  - Detections Only
  - Custom Selection

**Schedule Management:**
- **💾 Save Schedule:** Stores configuration in browser localStorage
- **Active Schedules Display:** Shows all saved schedules with details
- **Schedule Details:** Name, frequency, scope, creation date
- **Delete Function:** Remove unwanted schedules
- **Persistent Storage:** Survives browser restarts

**Automation Script Generation:**
- **📜 Download Script:** Bash script for server-side automation
- **Script Contents:**
  - Configuration section (URLs, paths)
  - Logging functionality
  - Accessibility checks
  - JavaScript code snippet for browser console
  - Instructions for Puppeteer/Playwright integration
  - Cron job guidance
- **Filename:** `falcon_export_automation.sh`

**Limitations & Notes:**
- Browser-based schedules only run when page is open
- True automation requires downloaded script + cron/Task Scheduler
- Configurations stored in localStorage (per-browser, per-domain)
- Auto-download triggered when schedule fires

---

### 10. Side-by-Side Comparison System ⚖️

**Purpose:** Compare security posture and configurations between two CIDs

**Location:** Comparison tab in sidebar navigation

#### **Comparison Controls:**

**Selection Interface:**
- **Snapshot Date Selector:** Choose time period for comparison
- **Data Sheet Selector:** Choose which worksheet to compare (all 9 available)
- **CID A (Left - Blue):** First environment for comparison
- **CID B (Right - Green):** Second environment for comparison

**Comparison Options:**
- **🔍 Compare Button:** Trigger comparison analysis
- **Highlight Differences:** Color-code rows with variations
- **Show Delta Values:** Display numeric differences in dedicated column
- **📥 Export Comparison:** Download comparison as CSV

**Auto-Update Feature:**
- Comparison refreshes automatically on any selection change
- Instant visual feedback without button clicks
- Validates that two different CIDs are selected

#### **Visual Comparison Layout:**

**Summary Cards:**
- Two gradient-colored cards showing selected CIDs
- Blue gradient (#0066cc) for CID A (left side)
- Green gradient (#00aa00) for CID B (right side)
- Displays company name and CID hash
- Black borders for clear delineation

**Simple Data Comparison (Stats, Policy Scores, etc.):**
- **4-Column Table:**
  - **Metric:** Name of the metric
  - **🔵 CID A:** Value from first environment
  - **🟢 CID B:** Value from second environment
  - **Δ Delta:** Calculated numeric difference
- **Delta Styling:**
  - Red text for positive differences (increases)
  - Green text for negative differences (decreases)
  - Gray text for zero or N/A
  - Sign prefix (+ or -)
- **Row Highlighting:** Yellow background for different values

**Complex Data Comparison (Agent Versions, Prevention Toggles, etc.):**
- **Multi-Column Table:**
  - All original data columns preserved
  - Two additional columns: 🔵 A and 🟢 B
  - Checkmark (✓) indicates item exists
  - X mark (✗) indicates item missing
- **Row Highlighting:**
  - Pink background (#ffe6e6) = Only in CID A
  - Light green background (#e6ffe6) = Only in CID B
  - White background = Present in both
- **Visual Legend:**
  - Automatically appears below complex tables
  - Explains color coding with visual samples

#### **Validation & Error Handling:**

- **Same CID Check:** Warning if both selectors have same CID
- **Data Availability:** Validates data exists for both CIDs
- **Missing Values:** Displays "N/A" for absent data
- **Empty Arrays:** Graceful handling of missing sections

#### **CSV Export:**

**Export Format:**
- Metadata header with comparison details
- Both CID names and IDs
- Snapshot date and export timestamp
- Comparison data in tabular format
- Delta column for numeric differences

**Filename Convention:**
```
falcon_comparison_[sheet]_YYYY-MM-DD.csv
```

**Use Cases:**
- Security posture comparison between environments
- Pre/post-migration validation
- Configuration drift detection
- Troubleshooting discrepancies
- Compliance auditing across business units

---

### 11. Data Structure Handling

The visualizer intelligently handles **3 data structure types:**

#### **Type 1: Simple Name-Value Pairs**
- Format: `[{'name': 'metric', 'value': 123}, ...]`
- Rendered as: 2-column table (Metric | Value)
- Used by: Stats, OS Versions, Policy Scores, Features

#### **Type 2: Complex Dictionary Tables**
- Format: Multiple columns per row
- Rendered as: Multi-column table (all keys as columns)
- Used by: Sensor Updates, Agent Versions, Prevention Toggles

#### **Type 3: Multi-Array Worksheets**
- Format: Multiple separate data arrays
- Rendered as: Separate sections with individual tables
- Used by: Detections (5 arrays)

---

### 12. Visual Design System 🎨

**Color Scheme:**
- **Primary:** CrowdStrike Red (#cc0000)
- **Secondary:** Black (#000000, #1a1a1a)
- **Accent:** White (#ffffff)
- **Borders:** Black (3px solid)
- **Charts:** Red, Green, Blue, Orange, Yellow palettes
- **Status Colors:** Green (good), Yellow (warning), Orange (caution), Red (critical), Black/Gray (unknown)
- **Comparison Colors:** Blue (#0066cc) for CID A, Green (#00aa00) for CID B

**Layout:**
- **Container:** Max-width 1600px, centered
- **Cards:** Dark background with red borders
- **Metric Numbers:** Large red text (#ff3333)
- **Responsive:** Adapts to desktop, tablet, mobile

**Logos:**
- CrowdStrike logo (top-left)
- AWS logo (top-left)
- Header gradient: Red to Black

---

### 13. User Controls & Interactivity

**Global Controls (present on all data sheets):**
- **Snapshot Date Selector:** Choose time period
- **CID Selector:** Choose customer environment
- **Changes Toggle:** Show/hide delta indicators
- **View Trends Button:** Open trend charts (on supported sheets)
- **Export CSV Button:** Download current sheet data

**Reporting Controls:**
- **Bulk Export:** Multi-select CIDs and sheets
- **Schedule Configuration:** Set up automated exports
- **Download Script:** Get automation bash script

**Comparison Controls:**
- **CID A/B Selectors:** Choose two environments
- **Highlight Differences:** Toggle visual highlighting
- **Show Delta:** Toggle numeric difference display
- **Export Comparison:** Download comparison CSV

**Navigation Controls:**
- **Hamburger Menu (☰):** Collapse/expand sidebar
- **Sidebar Links:** Navigate between data sheets
- **Close Button:** Exit modals

**Interaction Features:**
- All tables are scrollable
- Charts have interactive tooltips
- Smooth transitions and animations
- Instant updates when changing CID or snapshot

---

## Technical Architecture

### **Frontend Stack:**
- **HTML5** single-page application
- **Vanilla JavaScript** (no frameworks)
- **Chart.js 4.4.0** for visualizations
- **CSS3** with flexbox/grid layouts

### **Data Management:**
- **Auto-loading:** Reads `list_files.json` for file discovery
- **In-memory storage:** All 5 snapshots loaded at once
- **Date parsing:** Extracts timestamps from filenames
- **Delta calculation:** Compares consecutive snapshots
- **CID filtering:** Real-time data filtering by customer

### **File Structure:**
```
Value/
├── visualizer.html (main application)
├── Falcon_Health_Check_Stats_*.json (5 data files)
├── list_files.json (file manifest)
├── AWS Logo.png
├── Crowdstrike Logo.png
├── DASHBOARD_NAVIGATION.md (feature docs)
├── HAMBURGER_MENU_CHARTS.md (feature docs)
├── MULTI_SNAPSHOT_FEATURES.md (feature docs)
├── TREND_ANALYSIS_SHEETS.md (feature docs)
├── DATA_STRUCTURE_ANALYSIS.md (data spec)
└── visualizer_backup.html (backups)
```

---

## Performance Characteristics

- **Load Time:** Fast (client-side only)
- **Data Size:** ~68MB total (13.6MB × 5 files)
- **CID Count:** 81 customer environments
- **Snapshot Count:** 5 time periods
- **Total Metrics:** Thousands per CID
- **Browser Requirements:** Modern browser with ES6 support

---

## Use Cases

### **Security Operations Teams:**
- Monitor real-time security posture across environments
- Identify offline or outdated endpoints
- Track detection rates and response times

### **Compliance Teams:**
- Audit policy compliance scores
- Verify security feature enablement
- Track SSL certificate rotation compliance

### **IT Operations:**
- Monitor agent update adoption
- Track OS version distributions
- Identify devices requiring maintenance
- Compare configurations across environments

### **Executive Reporting:**
- High-level dashboard metrics
- Trend visualizations for presentations
- Multi-environment comparisons
- Bulk exports for stakeholder reports

---

## Data Sources

**Input Format:** CrowdStrike Falcon Health Check JSON exports

**Export Cadence:** Weekly (current dataset spans 3 weeks)

**Data Retention:** 5 most recent snapshots

**Customer Scope:** AWS corporate production environments (81 CIDs)

---

## Version History

- **v1.0:** Initial tabbed interface
- **v2.0:** Multi-snapshot support with delta tracking
- **v3.0:** Dashboard landing page with sidebar navigation
- **v4.0:** Enhanced trend charts (4-chart layout)
- **v5.0:** Hamburger menu and responsive improvements
- **v5.1:** Color key legends and CSV export functionality
- **v5.2:** Bulk export, scheduled reporting, side-by-side comparison

---

## Future Enhancement Opportunities

- Side-by-side snapshot comparison (time-based)
- Custom date range selection
- Alert thresholds and notifications
- Downloadable charts and reports (PNG/PDF)
- API integration for automatic data refresh
- Role-based access control
- Custom dashboard widgets
- Bulk comparison (compare 3+ CIDs)
- Historical trend analysis (compare across snapshots)
- Email delivery of scheduled reports

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Customer Environments (CIDs) | 81 |
| Historical Snapshots | 5 |
| Data Sheets | 9 |
| Navigation Tabs | 11 (including Reporting & Comparison) |
| Trend-Enabled Sheets | 4 |
| Total Metrics per CID | ~400+ |
| Data File Size | ~68MB |
| Supported Platforms | Windows, Mac, Linux |
| Security Tactics Tracked | 21 (MITRE ATT&CK) |
| Export Formats | CSV (single), ZIP (bulk) |
| Comparison Modes | Side-by-side CID comparison |

---

**The CrowdStrike Falcon Health Check Visualizer provides comprehensive, actionable intelligence for managing enterprise endpoint security at scale.**
