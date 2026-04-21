# Trend Analysis - Supported Sheets

## ✅ Sheets with Trend Analysis

Trend analysis is now available **ONLY** for the following 4 sheets:

### 1. **Stats**
**Metrics Tracked:**
- Devices (Total)
- Windows (Total)
- Mac (Total)
- Linux (Total)
- Online: Devices Total
- Policy Score (0-100)

**Data Source:** `stats_data` (name-value pairs)

---

### 2. **Detections**
**Metrics Tracked:**
- Total
- Critical
- High
- Medium
- Low

**Data Source:** `detects_severity_data` (name-value pairs)

---

### 3. **Policy Scores**
**Metrics Tracked:**
- Policy Score
- Critical Policy Score

**Data Source:** `policy_scores_data` (name-value pairs)

---

### 4. **Prevention Toggles**
**Metrics Tracked:**
- Total Enabled (sum of all enabled toggles)
- Total Disabled (sum of all disabled toggles)

**Data Source:** `prevention_toggles_data` (complex dictionary - aggregated)

---

## ❌ Sheets WITHOUT Trend Analysis

The following sheets do NOT have the "View Trends" button:

- Sensor Updates
- Operating System Versions
- Agent Versions
- 2026 Certificate Rotation Versions
- Module Enablement

**Reason:** These sheets have complex data structures that don't map well to simple time-series trends, or the data would be too granular/numerous to visualize effectively.

---

## 🎨 How It Works

1. **View Trends Button**: Only appears on supported sheets
2. **Date Range**: Shows all 5 snapshots (Feb 26 - Mar 19, 2026)
3. **Per-CID**: Trends are calculated for the selected CID only
4. **Line Charts**: Interactive Chart.js visualization with color-coded lines
5. **Tooltip**: Hover over data points to see exact values

---

## 📊 Data Parsing Details

### Simple Name-Value Structure
- **Stats, Detections, Policy Scores**: Use `find()` to locate metric by name
- Format: `[{name: 'metric', value: 123}, ...]`

### Complex Aggregated Structure
- **Prevention Toggles**: Sums `enabled` and `disabled` fields across all items
- Format: `[{toggle_name: '...', enabled: 5, disabled: 3, ...}, ...]`

All data is correctly parsed and validated for accurate trend visualization! ✅
