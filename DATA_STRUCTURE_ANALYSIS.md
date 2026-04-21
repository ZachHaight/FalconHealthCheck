# Falcon Health Check JSON - Data Structure Analysis

## Overview
- **Total Worksheets:** 9
- **CID Entries per Worksheet:** 81
- **Created:** 2026-03-19 19:15:25Z

---

## Worksheet Breakdown

### 1. **stats** ✅
- **Structure Type:** Simple Name-Value
- **Data Key:** `stats_data`
- **Format:** `[{'name': ..., 'value': ...}, ...]`
- **Items:** 39 metrics per CID
- **Sample Metrics:**
  - Time, Company, CID, Parent
  - Device counts (Total, Windows, Mac, Linux)
  - Sensor types (Workstations, Servers, Domain Controllers)
  - RFM status, Online devices
  - Sensor age percentages
  - Policy scores
  - Telemetry counts

---

### 2. **sensor_updates** ✅
- **Structure Type:** Complex Dictionary
- **Data Key:** `sensor_updates_data`
- **Format:** Multi-column table with 8 fields
- **Items:** 27 entries per CID
- **Columns:**
  1. Policy Id
  2. Active Devices
  3. Policy Name
  4. Platform
  5. Agent Version
  6. Support Ends
  7. Uninstall Protection
  8. Color (visual indicator)

---

### 3. **detections** ✅
- **Structure Type:** Multiple Arrays (5 categories)
- **Data Keys:**
  1. `detects_status_data` (8 items)
     - New, In Progress, True Positive, False Positive, Ignored, Closed, Reopened, Total
  2. `detects_severity_data` (6 items)
     - Total, Critical, High, Medium, Low, Informational
  3. `detects_disposition_data` (4 items)
     - Disposition types
  4. `detects_platform_data` (4 items)
     - Platform breakdown
  5. `detects_tactic_data` (21 items)
     - MITRE ATT&CK tactics

---

### 4. **os_versions** ✅
- **Structure Type:** Simple Name-Value
- **Data Key:** `os_data`
- **Format:** `[{'name': ..., 'value': ...}, ...]`
- **Items:** 65 OS versions per CID
- **Example:** `{'name': 'Amazon Linux 2', 'value': 5}`

---

### 5. **agent_versions** ✅
- **Structure Type:** Complex Dictionary
- **Data Key:** `agent_versions_data`
- **Format:** Multi-column table with 5 fields
- **Items:** 123 entries per CID
- **Columns:**
  1. agent_version
  2. platform
  3. expiration_date
  4. color (status indicator)
  5. count (device count)

---

### 6. **ssl_cert_rollover_2026_versions** ✅
- **Structure Type:** Complex Dictionary
- **Data Key:** `agent_versions_data`
- **Format:** Multi-column table with 5 fields
- **Items:** 123 entries per CID
- **Columns:** (Same as agent_versions)
  1. agent_version
  2. platform
  3. expiration_date
  4. color (compliance indicator)
  5. count (device count)

---

### 7. **policy_scores** ✅
- **Structure Type:** Simple Name-Value
- **Data Key:** `policy_scores_data`
- **Format:** `[{'name': ..., 'value': ...}, ...]`
- **Items:** 10 metrics per CID
- **Example:** `{'name': 'Policy Score', 'value': 82.0}`

---

### 8. **prevention_toggles** ✅
- **Structure Type:** Complex Dictionary
- **Data Key:** `prevention_toggles_data`
- **Format:** Multi-column table with 7 fields
- **Items:** 112 entries per CID
- **Columns:**
  1. platform
  2. toggle_api_name
  3. toggle_name
  4. enabled (count)
  5. disabled (count)
  6. policy_score_enable (boolean)
  7. disable_percentage

---

### 9. **features** ✅
- **Structure Type:** Simple Name-Value
- **Data Key:** `feature_data`
- **Format:** `[{'name': ..., 'value': ...}, ...]`
- **Items:** 87 features per CID
- **Example:** `{'name': 'Detection Email 1', 'value': 'gee@amazon.com'}`

---

## Structure Categories

### Category A: Simple Name-Value Pairs
Worksheets that use `{'name': ..., 'value': ...}` format:
- stats (39 items)
- os_versions (65 items)
- policy_scores (10 items)
- features (87 items)

### Category B: Complex Dictionary Tables
Worksheets with multiple columns per row:
- sensor_updates (8 columns, 27 rows)
- agent_versions (5 columns, 123 rows)
- ssl_cert_rollover_2026_versions (5 columns, 123 rows)
- prevention_toggles (7 columns, 112 rows)

### Category C: Multi-Array Worksheets
Worksheets with multiple data arrays:
- detections (5 separate arrays with different metrics)

---

## Visualizer Implementation

### ✅ Handled Structures:
1. **Simple Name-Value** → 2-column table (Metric | Value)
2. **Complex Dictionaries** → Multi-column table (all keys as columns)
3. **Multiple Arrays** → Separate sections with individual tables
4. **Color Fields** → Visual color indicators rendered inline

### Features:
- Auto-detects structure type
- Creates appropriate table layouts
- Separates multi-array data with headers
- Renders color fields visually
- All sections delineated with black borders (red/white/black theme)

---

## Total Data Points
- **81 CIDs** across all worksheets
- **Thousands of metrics** per CID
- All structures properly visualized in the HTML viewer
