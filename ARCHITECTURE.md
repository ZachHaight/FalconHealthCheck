# Falcon Health Check Visualizer - Architecture Documentation

## Overview

The Falcon Health Check Visualizer is a single-page web application that provides interactive dashboards, reporting, and analysis tools for CrowdStrike Falcon health check data. The application is designed for security teams to monitor sensor health, track metrics over time, and generate billing estimates.

**Technology Stack:**
- Pure HTML5, CSS3, JavaScript (ES2021)
- Chart.js 3.x for data visualization
- JSZip for bulk export functionality
- No backend required - fully client-side

**File Size:** 5,500+ lines
**Functions:** 58 documented functions
**JSDoc Coverage:** 100%

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Browser Client                           │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Single Page Application                   │  │
│  │                                                         │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │  │
│  │  │     RBAC     │  │   Data       │  │   Chart     │ │  │
│  │  │   System     │  │   Loader     │  │   Engine    │ │  │
│  │  └──────────────┘  └──────────────┘  └─────────────┘ │  │
│  │                                                         │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │  │
│  │  │  Dashboard   │  │   Billing    │  │  Reporting  │ │  │
│  │  │   Views      │  │  Calculator  │  │   Tools     │ │  │
│  │  └──────────────┘  └──────────────┘  └─────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     Data Sources                             │
│                                                               │
│  ┌──────────────────┐         ┌──────────────────┐          │
│  │  Local JSON      │         │   S3 Bucket      │          │
│  │  Files           │   OR    │   (Optional)     │          │
│  │  (list_files.json)│        │   (CORS enabled) │          │
│  └──────────────────┘         └──────────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Systems

### 1. Role-Based Access Control (RBAC)

**Location:** Lines 1466-1709

**Purpose:** Restricts features based on user roles (Admin, Analyst, Viewer)

**Key Components:**

```javascript
ROLES = {
    admin: { permissions: ['view', 'export', 'bulk_export', 'reporting', 'comparison', 'user_management'] },
    analyst: { permissions: ['view', 'export', 'reporting', 'comparison'] },
    viewer: { permissions: ['view'] }
}

DEMO_USERS = {
    'admin': { password: 'admin123', role: 'admin' },
    'analyst': { password: 'analyst123', role: 'analyst' },
    'viewer': { password: 'viewer123', role: 'viewer' }
}
```

**Session Management:**
- Stored in `localStorage` as `falconSession`
- 24-hour session timeout
- Automatic logout on expiration

**Permission Checking:**
```javascript
hasPermission(permission) → boolean
checkPermissionOrAlert(permission, actionName) → boolean
```

**UI Enforcement:**
- Navigation items hidden based on permissions
- Export buttons disabled for unauthorized users
- Alert shown when attempting restricted actions

---

### 2. Data Loading System

**Location:** Lines 1922-2078

**Purpose:** Loads health check JSON files from local or S3 sources

**Data Flow:**

```
1. Fetch list_files.json (manifest)
   ↓
2. Parse file list
   ↓
3. For each file:
   - Fetch JSON data
   - Extract date from filename
   - Parse health check data
   - Store in allHealthChecks{}
   ↓
4. Build CID-to-Company mapping
   ↓
5. Set default CID selection
   ↓
6. Render initial dashboard
```

**Data Structures:**

```javascript
allHealthChecks = {
    'Falcon_Health_Check_Stats_2026-04-24_10-30-00.json': {
        date: Date object,
        data: [
            {
                worksheet_name: 'stats',
                worksheet_data: [
                    { cid: 'abc123', stats_data: [...] }
                ]
            }
        ],
        displayDate: 'Apr 24, 2026 10:30 AM'
    }
}

cidToCompanyMap = {
    'abc123': 'Company Name'
}
```

**Configuration:**
- `DATA_SOURCE_URL` - S3 bucket URL or empty for local files
- `DEBUG_MODE` - Enable/disable console logging

---

### 3. Navigation System

**Location:** Lines 1872-1928

**Purpose:** Manages view transitions and UI state

**Views:**
- Dashboard (default)
- Consumption Billing
- Billing Classification
- Cost Estimator
- Amazon Exceptions Tracker
- Reporting
- Comparison
- User Management
- Worksheets (9 different data sheets)

**Navigation Flow:**

```javascript
navigateTo(view)
  ↓
Update active nav item
  ↓
Expand parent category
  ↓
Route to appropriate render function:
  - showDashboard()
  - showConsumptionBilling()
  - showBillingClassifier()
  - showCostEstimator()
  - showAmazonExceptions()
  - showReporting()
  - showComparison()
  - showUserManagement()
  - renderWorksheet()
```

**State Management:**
```javascript
currentView = 'dashboard'  // Active view
currentWorksheet = ''      // Active worksheet
selectedCID = ''           // Selected customer
currentHealthCheckFile = ''  // Active snapshot
```

---

### 4. Visualization Engine

**Location:** Lines 3567-3939

**Purpose:** Renders Chart.js visualizations for trend analysis

**Chart Types:**

1. **Device Count Trends**
   - Line chart
   - Tracks total devices over time
   - Data: `stats_data['Devices (Total)']`

2. **Sensor Health Chart**
   - Line chart
   - Tracks online vs offline sensors
   - Data: `stats_data['Online: Devices Total']`

3. **Detection Trends**
   - Line chart
   - Tracks detections by severity
   - Data: `detects_severity_data[...]`

4. **Policy Compliance**
   - Line chart
   - Tracks policy scores over time
   - Data: `policy_scores_data['Policy Score']`

5. **Platform Distribution**
   - Pie/doughnut chart
   - Shows OS distribution
   - Data: `os_data[...]`

6. **Consumption Trends**
   - Line chart
   - Tracks metered usage
   - Data: `metered_ng_data[...]`

**Theme Support:**
- Charts adapt to light/dark theme
- Dynamic color scheme via `getChartTextColor()` and `getChartGridColor()`

---

### 5. Billing Calculators

**Location:** Lines 2808-3565

**Purpose:** Endpoint classification and cost estimation for billing

#### 5.1 OS Classification Engine

```javascript
classifyOSForBilling(osName, cid) → {
    type: 'Workstation' | 'Server' | 'Unknown',
    category: string,
    special: boolean,
    reason: string
}
```

**Classification Logic:**

```
1. Check if CID has special exceptions (AWS Corporate Production)
   ↓
2. Check special exception OS patterns:
   - Amazon Linux 2023
   - Fedora
   - KDE Neon
   ↓
3. Check workstation patterns:
   - Windows 11, Windows 10
   - macOS
   ↓
4. Check server patterns:
   - Windows Server (2025, 2022, 2019, 2016, 2012, 2008)
   - Ubuntu, RHEL, CentOS, SUSE, Debian
   ↓
5. Default: Linux → Server, Other → Unknown
```

**Special Pricing Exceptions:**
- Specific customer receives workstation rates for certain Linux distros
- Encoded customer ID: `PRICING_CONFIG.specialCustomerId`
- Pricing obfuscated via base64 encoding

#### 5.2 Cost Estimator

**Inputs:**
- Workstation count (from OS classification)
- Server count (from OS classification)
- Workstation annual price (default: $36.35)
- Server annual price (default: $41.00)

**Outputs:**
- Monthly cost breakdown
- Annual cost total
- Classification details per OS

**Formula:**
```javascript
monthlyWorkstation = (workstationCount * wsPrice) / 12
monthlyServer = (serverCount * serverPrice) / 12
totalMonthly = monthlyWorkstation + monthlyServer
totalAnnual = workstationCount * wsPrice + serverCount * serverPrice
```

#### 5.3 Cloud Billing Calculator

**Purpose:** Estimate costs for cloud workloads (hourly billing)

**Inputs:**
- Cloud server hourly rate
- Cloud workstation hourly rate
- Cloud workload counts from metered data

**Time Periods:**
- Hourly
- Daily (24 hours)
- Monthly (730 hours average)
- Yearly (8,760 hours)

---

### 6. Reporting System

**Location:** Lines 3948-4514

**Purpose:** Bulk export and scheduled reporting

#### 6.1 Bulk Export

**Features:**
- Export multiple CIDs
- Export multiple worksheets
- Generate ZIP archive with all CSV files
- Uses JSZip library

**Export Flow:**

```
1. User selects CIDs and worksheets
   ↓
2. For each CID + worksheet combination:
   - Generate CSV content
   - Add metadata header
   - Format data appropriately
   ↓
3. Create ZIP archive:
   - Add all CSVs
   - Name: Falcon_Bulk_Export_YYYY-MM-DD_HH-MM-SS.zip
   ↓
4. Trigger browser download
```

**CSV Format:**
```csv
CrowdStrike Falcon Health Check Export
Company,Company Name
CID,abc123xyz
Data Sheet,Stats
Snapshot Date,Apr 24, 2026 10:30 AM
Export Date,Apr 27, 2026 3:45 PM

Metric,Value
Devices (Total),1250
Windows (Total),890
...
```

#### 6.2 Scheduled Reporting

**Purpose:** Configure automated export schedules

**Features:**
- Frequency options (daily, weekly, monthly, custom)
- Scope selection (all CIDs or specific CIDs)
- Worksheet selection
- Schedule persistence in localStorage

**Storage:**
```javascript
localStorage.getItem('falconSchedules') = [
    {
        id: timestamp,
        name: 'Schedule Name',
        frequency: 'daily',
        scope: 'all-cids',
        sheets: 'all',
        selectedCIDs: [],
        createdAt: ISO date,
        lastRun: ISO date
    }
]
```

**Automation Script:**
- Generates bash script template
- Includes instructions for browser automation
- Recommends Puppeteer/Playwright for full automation

---

### 7. Comparison Tools

**Location:** Lines 4516-5017

**Purpose:** Side-by-side comparison of two CIDs

**Features:**
- Select snapshot date
- Select worksheet
- Select two CIDs to compare
- Diff highlighting (optional)
- Delta calculation (optional)
- CSV export of comparison

**Comparison Types:**

1. **Simple Name-Value Comparison**
   - Used for: stats, detections, policy scores
   - Format: 3-column table (Metric | CID A | CID B)
   - Delta column shows numeric differences

2. **Complex Structure Comparison**
   - Used for: agent versions, prevention toggles, features
   - Format: Multi-column with A/B presence indicators
   - Color-coded rows (only in A, only in B, in both)

**Visual Indicators:**
- Yellow highlight: Values differ
- Green text: Positive delta
- Red text: Negative delta
- Color badges: Presence/absence in each CID

---

### 8. Worksheet Rendering System

**Location:** Lines 5186-5603

**Purpose:** Render raw health check data by worksheet

**Worksheets:**

1. **stats** - Overview metrics
2. **sensor_updates** - Sensor version distribution
3. **detections** - Security detections by severity
4. **os_versions** - Operating system distribution
5. **agent_versions** - Falcon agent versions
6. **ssl_cert_rollover_2026_versions** - Certificate readiness
7. **policy_scores** - Policy compliance scores
8. **prevention_toggles** - Prevention policy settings
9. **features** - Feature enablement status
10. **metered_ng** - Consumption billing metrics

**Rendering Logic:**

```
1. User selects worksheet tab
   ↓
2. Load data for selected snapshot and CID
   ↓
3. Determine data structure:
   - Simple: { name, value } array
   - Complex: Multiple data arrays
   ↓
4. Render appropriately:
   - Simple: 2-column table
   - Complex: Multi-column table with sections
   ↓
5. Add delta indicators (if enabled)
   ↓
6. Add export button
```

**Delta Indicators:**
- Compare current snapshot to previous snapshot
- Show +/- change for numeric values
- Green for positive, red for negative

**Color Legends:**
- Agent versions: Green (current), Yellow (expiring), Orange (update needed), Red (expired)
- Sensor updates: Green (N-1), Yellow (N-2), Orange (N-3+), Red (unsupported)

---

### 9. Theme System

**Location:** Lines 5882-5914

**Purpose:** Light/dark theme support

**Themes:**
- Light (default)
- Dark

**Storage:**
- Preference saved in `localStorage` as `theme`
- System preference detection via `prefers-color-scheme`

**Application:**
- CSS custom properties (variables) switch based on `data-theme` attribute
- Charts re-render with theme-appropriate colors
- Smooth transition on theme toggle

**CSS Variables:**
```css
[data-theme='light'] {
    --bg-primary: #ffffff;
    --bg-secondary: #f5f5f5;
    --text-primary: #333333;
    --accent-color: #cc0000;
}

[data-theme='dark'] {
    --bg-primary: #1a1a1a;
    --bg-secondary: #2d2d2d;
    --text-primary: #e0e0e0;
    --accent-color: #ff6666;
}
```

---

## Data Models

### Health Check File Structure

```json
{
  "worksheet_name": "stats",
  "worksheet_data": [
    {
      "cid": "abc123xyz",
      "stats_data": [
        { "name": "Devices (Total)", "value": 1250 },
        { "name": "Windows (Total)", "value": 890 },
        { "name": "Mac (Total)", "value": 200 },
        { "name": "Linux (Total)", "value": 160 }
      ]
    }
  ]
}
```

### Worksheet Data Types

| Worksheet | Data Key | Structure |
|-----------|----------|-----------|
| stats | `stats_data` | Array of { name, value } |
| detections | `detects_severity_data` | Array of { name, value } |
| os_versions | `os_data` | Array of { name, value } |
| agent_versions | `agent_version_data` | Array of { agent_version, count, color } |
| ssl_cert | `ssl_cert_data` | Array of { agent_version, count, color } |
| policy_scores | `policy_scores_data` | Array of { name, value } |
| prevention_toggles | `prevention_toggles_data` | Array of { toggle_name, enabled, disabled } |
| features | `feature_data` | Array of { name, value } |
| metered_ng | `metered_ng_data` | Array of { name, value } |

---

## Extension Points

### Adding New Worksheets

1. Add worksheet name to `CONSTANTS.WORKSHEETS`
2. Add display name to `worksheetDisplayNames`
3. Update `renderWorksheet()` to handle new data structure
4. Add color legend if needed (like agent_versions)
5. Update export CSV formatting in `generateCSVContent()`

### Adding New Chart Types

1. Add chart rendering function to visualization engine
2. Call from `renderDashboardCharts()` or appropriate view
3. Define data extraction logic
4. Add theme color support
5. Add to trend modal if applicable

### Adding New Billing Rules

1. Update `classifyOSForBilling()` with new patterns
2. Add to special exceptions if CID-specific
3. Update `PRICING_OBFUSCATION_NOTES.md` with reasoning
4. Update cost estimator display if needed

### Adding New RBAC Roles

1. Add role to `ROLES` object with permissions array
2. Add demo user to `DEMO_USERS` (if applicable)
3. Update UI permission checks
4. Add to user management view

### Adding New Export Formats

1. Create format-specific generation function
2. Add format selection to bulk export UI
3. Update filename generation
4. Add content-type headers if needed

---

## Security Considerations

### Authentication
- Demo users for testing only
- Session-based with localStorage
- 24-hour timeout for security
- **Production:** Replace with real authentication (OAuth, SAML, etc.)

### Data Privacy
- All processing client-side (no server logging)
- Data never leaves browser
- Export files contain sensitive data - handle appropriately
- **Production:** Consider data sanitization before export

### Pricing Obfuscation
- Base64 encoding (NOT encryption)
- Special customer ID obfuscated
- Pricing values visible in code
- **Purpose:** Prevent casual viewing, not security

### CORS Configuration
- Required for S3 data sources
- Allow GET/HEAD methods only
- Restrict origins in production
- See DEPLOYMENT.md for secure configuration

---

## Performance Considerations

### Data Loading
- Loads all snapshots at once
- Stores in memory (`allHealthChecks` object)
- Consider pagination for 50+ snapshots
- Large files (>10MB) may cause browser slowdown

### Chart Rendering
- Uses requestAnimationFrame for smooth rendering
- Destroys old charts before creating new ones
- Limits data points for performance
- Chart.js handles optimization internally

### Export Performance
- JSZip processes in memory
- Large exports (100+ files) may take time
- Progress indication not currently implemented
- Consider chunking for massive exports

### Memory Management
- Old charts destroyed to prevent memory leaks
- LocalStorage has 5-10MB limit (varies by browser)
- Consider indexedDB for larger datasets
- Clear old sessions periodically

---

## Testing Strategy

### Manual Testing Checklist

See `REFACTOR_STATUS.md` for complete testing checklist.

Key areas to test:
- Login/logout with all roles
- Navigate to each view
- Load multiple snapshots
- Generate all chart types
- Perform bulk export
- Run comparison between CIDs
- Test theme switching
- Verify RBAC restrictions

### Unit Testing (Future Enhancement)

Recommended test framework: Jest

Priority test targets:
- `classifyOSForBilling()` - Complex business logic
- `filterConsumptionMetrics()` - Data processing
- `calculateCloudCosts()` - Financial calculations
- `extractDateFromFilename()` - Parsing logic
- RBAC permission checking

### Integration Testing (Future Enhancement)

Recommended framework: Cypress or Playwright

Test scenarios:
- End-to-end data loading flow
- Multi-snapshot comparison
- Bulk export workflow
- Role-based access enforcement
- Chart rendering across themes

---

## Deployment

See `QUICKSTART.md` and `DEPLOYMENT.md` for deployment instructions.

**Options:**
1. **Local Development** - Python HTTP server
2. **GitHub Pages** - Free static hosting
3. **S3 Static Website** - AWS hosting
4. **CloudFront + S3** - CDN with authentication

**Requirements:**
- Web server (any)
- JSON data files
- CORS configuration (if remote data)
- Optional: Authentication layer

---

## Troubleshooting

### No Data Loaded
- Check `list_files.json` exists and is valid JSON
- Verify JSON filenames match pattern: `Falcon_Health_Check_Stats_YYYY-MM-DD_HH-MM-SS.json`
- Check browser console for fetch errors
- Verify CORS configuration if using S3

### Charts Not Rendering
- Verify Chart.js library loaded (check `<script>` tag)
- Check browser console for canvas errors
- Ensure data exists for selected CID
- Try refreshing page

### Export Not Working
- Verify JSZip library loaded
- Check user has export permission
- Check browser console for errors
- Try smaller export (fewer CIDs/worksheets)

### Theme Not Persisting
- Check localStorage not blocked
- Verify browser supports CSS custom properties
- Check console for localStorage errors
- Try clearing localStorage and reloading

### Performance Issues
- Check snapshot count (50+ may cause slowdown)
- Verify file sizes (>10MB may cause issues)
- Clear old localStorage data
- Close other browser tabs
- Check memory usage in browser dev tools

---

## Maintenance

### Regular Updates

**When to update:**
- New worksheet types added to health checks
- Pricing changes
- New OS versions need classification
- Feature additions/changes

**Update locations:**
- `CONSTANTS` object - Configuration values
- `classifyOSForBilling()` - Billing logic
- `worksheetDisplayNames` - Display names
- JSDoc comments - Documentation

### Version Control

**Git workflow:**
1. Create feature branch
2. Make changes
3. Test thoroughly
4. Update documentation
5. Create pull request
6. Review changes
7. Merge to main
8. Tag release

**Commit message format:**
```
<type>: <description>

<detailed explanation>

- Bullet points for changes
- Related to issue #123
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

---

## Future Enhancements

### High Priority
1. Backend API integration
2. Real authentication system
3. Database storage for historical data
4. Automated snapshot loading
5. Unit test coverage

### Medium Priority
1. Export to Excel (.xlsx)
2. PDF report generation
3. Email report scheduling
4. Custom dashboard widgets
5. Data filtering/search

### Low Priority
1. Mobile responsive design
2. Offline mode (Service Worker)
3. Multi-language support
4. Custom theme colors
5. Plugin architecture

---

## Contact and Support

For questions, issues, or contributions:
- GitHub: https://github.com/ZachHaight/FalconHealthCheck
- Issues: https://github.com/ZachHaight/FalconHealthCheck/issues

---

## Appendix

### Glossary

- **CID** - Customer Identifier (unique per Falcon instance)
- **Worksheet** - Named data section in health check JSON
- **Snapshot** - Point-in-time health check data file
- **RBAC** - Role-Based Access Control
- **Delta** - Change from previous snapshot
- **Metered** - Cloud-based consumption billing

### File Structure

```
/FalconHealthCheck
├── FalconHealthCheckVisualizer.html  (Main application - 5,500 lines)
├── list_files.json                   (File manifest)
├── .eslintrc.json                    (ESLint configuration)
├── run_eslint.sh                     (Validation script)
├── QUICKSTART.md                     (Setup guide)
├── DEPLOYMENT.md                     (Deployment guide)
├── REFACTOR_STATUS.md                (Refactoring progress)
├── ESLINT_VALIDATION.md              (Validation guide)
├── ARCHITECTURE.md                   (This file)
├── PRICING_OBFUSCATION_NOTES.md      (Internal docs)
└── Falcon_Health_Check_Stats_*.json  (Data files)
```

### Constants Reference

All constants defined in `CONSTANTS` object (lines 1717-1798):

- `WORKSHEETS.*` - Worksheet identifiers
- `SESSION.*` - Session configuration
- `THEME.*` - Theme identifiers
- `COLORS.*` - Color scheme
- `PRICING.*` - Billing rates
- `DEFAULTS.*` - Default values

### Function Index

See JSDoc comments in code for detailed function documentation. All 58 functions fully documented with:
- Purpose and behavior
- Parameter types and descriptions
- Return value structure
- Error conditions
- Usage examples (where applicable)

---

*Last Updated: April 27, 2026*
*Document Version: 1.0*
*Code Version: Post-Refactor (Phases 1-9 Complete)*
