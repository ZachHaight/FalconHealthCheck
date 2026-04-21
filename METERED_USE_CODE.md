# Metered Use Integration Code

This file contains the code needed to add the "Metered Use" (metered_ng) sheet to the visualizer.

## Files to Update

### 1. list_files.json
Add the latest JSON file that contains the metered_ng data:

```json
{
  "files": [
    "Falcon_Health_Check_Stats_2026-02-26_15-46-10_7-day_90-day.json",
    "Falcon_Health_Check_Stats_2026-03-05_22-17-11_7-day_90-day.json",
    "Falcon_Health_Check_Stats_2026-03-12_12-17-58_7-day_90-day.json",
    "Falcon_Health_Check_Stats_2026-03-13_12-15-53_7-day_90-day.json",
    "Falcon_Health_Check_Stats_2026-03-19_12-15-25_7-day_90-day.json",
    "Falcon_Health_Check_Stats_2026-03-27_21-59-56_7-day_90-day.json"
  ]
}
```

### 2. visualizer.html - Navigation Item

**Location:** In the sidebar navigation menu, around line 894-898
**Insert after:** The "Feature Enablement" nav-item
**Insert before:** The "Reporting" nav-item

```html
            <div class="nav-item" onclick="navigateTo('metered_ng')">
                <span class="nav-icon">💳</span>
                <span>Metered Use</span>
            </div>
```

Full context:
```html
            <div class="nav-item" onclick="navigateTo('features')">
                <span class="nav-icon">⚙️</span>
                <span>Feature Enablement</span>
            </div>
            <!-- ADD METERED USE HERE -->
            <div class="nav-item" onclick="navigateTo('metered_ng')">
                <span class="nav-icon">💳</span>
                <span>Metered Use</span>
            </div>
            <!-- END METERED USE -->
            <div class="nav-item" onclick="navigateTo('reporting')">
                <span class="nav-icon">📊</span>
                <span>Reporting</span>
            </div>
```

### 3. visualizer.html - Worksheet Display Name Mapping

**Location:** Around line 1152-1167, in the `worksheetDisplayNames` object

**Add this line:**
```javascript
            'metered_ng': 'Metered Use'
```

Full context:
```javascript
        // Worksheet display name mapping
        const worksheetDisplayNames = {
            'stats': 'Stats',
            'sensor_updates': 'Sensor Updates',
            'detections': 'Detections',
            'os_versions': 'Operating System Versions',
            'agent_versions': 'Agent Versions',
            'ssl_cert_rollover_2026_versions': '2026 Certificate Rotation Versions',
            'policy_scores': 'Policy Scores',
            'prevention_toggles': 'Prevention Toggles',
            'features': 'Feature Enablement',
            'metered_ng': 'Metered Use'  // <-- ADD THIS LINE
        };
```

## Data Structure

The metered_ng worksheet follows the standard structure:

```json
{
  "worksheet_name": "metered_ng",
  "worksheet_creation_date": "2026-03-28 04:59:56Z",
  "worksheet_data": [
    {
      "cid": "f5b14bfb19d444d39241a8d11fe0c912",
      "metered_ng_data": [
        {
          "name": "Total (Cloud and On-Prem)",
          "value": 5
        },
        {
          "name": "On-Prem (Workstations)",
          "value": 0
        },
        // ... more metrics
      ]
    }
    // ... more CIDs
  ]
}
```

## Features Automatically Included

Once the above changes are made, the Metered Use tab will automatically have:

- ✅ Data table display with all metered_ng_data metrics
- ✅ Date/snapshot selection
- ✅ CID selection dropdown
- ✅ Delta indicators (show changes from previous snapshot)
- ✅ CSV export functionality
- ✅ Bulk export (automatically appears in reporting)
- ✅ Comparison view (automatically appears as a sheet option)
- ✅ Trend analysis capabilities
- ✅ Search and filter

No additional code needed - the generic rendering functions handle it automatically!

## Notes

- The JSON file with metered_ng data must be loaded via list_files.json
- The metered_ng_data array uses the standard name-value pair structure
- All existing visualizer features work automatically with this data structure
