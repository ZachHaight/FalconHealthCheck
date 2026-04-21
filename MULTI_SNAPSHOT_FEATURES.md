# Amazon Health Check Visualizer - Multi-Snapshot Features

## 🎉 New Features Added

### 1. **Multi-File Support**
- Automatically loads all 5 health check JSON files from the Value directory
- Extracts timestamps from filenames for chronological ordering
- Displays "81 CIDs | 5 Snapshots" in header

### 2. **Snapshot Date Selector**
- Dropdown to switch between different health check dates
- Sorted chronologically (newest first)
- Displays dates in readable format: "Mar 19, 2026, 12:15 PM"
- Current selection: Mar 19, 2026 (most recent)

### 3. **Delta/Change Indicators** ⚡
- Toggle button: "△ Changes: ON/OFF"
- When enabled, shows numeric changes from previous snapshot
- Format: `current_value (+/- delta)`
- Red for increases, green for decreases
- Only shows for numeric values

### 4. **Trend Visualization** 📊
- "View Trends" button opens modal with line charts
- Tracks key metrics over time across all 5 snapshots
- **Stats worksheet**: Device counts, online devices, policy scores
- **Detections worksheet**: Severity levels (Critical, High, Medium, Low)
- **Policy Scores worksheet**: Policy Score, Critical Policy Score
- Interactive Chart.js visualization with color-coded lines

### 5. **Enhanced Controls**
- All controls in one row:
  - Snapshot Date dropdown
  - CID selector dropdown
  - Changes toggle button
  - View Trends button
- Red and white theme maintained
- Black borders for clear delineation

## 📊 Supported Trend Metrics

### Stats Tab:
- Devices (Total)
- Windows (Total)
- Mac (Total)
- Linux (Total)
- Online: Devices Total
- Policy Score (0-100)

### Detections Tab:
- Total, Critical, High, Medium, Low

### Policy Scores Tab:
- Policy Score
- Critical Policy Score

## 🔧 Technical Implementation

**Auto-Loading**: Reads `list_files.json` which contains all health check filenames
**Date Parsing**: Extracts dates from filename pattern `YYYY-MM-DD_HH-MM-SS`
**Delta Calculation**: Compares current snapshot with previous chronological snapshot
**Trend Data**: Aggregates metric values across all snapshots for selected CID

## 📝 Files Modified

1. `visualizer.html` - Enhanced with multi-file support
2. `list_files.json` - Created file list for auto-loading
3. `visualizer_backup.html` - Backup of original version

## 🚀 How to Use

1. **Refresh browser**: `http://localhost:8000/visualizer.html`
2. **Select snapshot date**: Choose from 5 available dates
3. **Select CID**: Choose company to view
4. **Toggle changes**: Click "△ Changes" button to show/hide deltas
5. **View trends**: Click "📊 View Trends" to see line charts

## 📅 Available Snapshots

1. Feb 26, 2026, 03:46 PM
2. Mar 5, 2026, 10:17 PM
3. Mar 12, 2026, 12:17 PM
4. Mar 13, 2026, 12:15 PM
5. Mar 19, 2026, 12:15 PM ⭐ (Default/Current)

## 🎨 UI Updates

- **Summary Cards**: Now shows "Snapshot Date" instead of "CID Hash"
- **Header**: Shows "81 CIDs | 5 Snapshots"
- **Modal**: Full-screen trend chart with close button
- **Delta Indicators**: Inline color-coded changes

## ✨ Future Enhancements (Optional)

- Export trend data to CSV
- Side-by-side comparison view
- Custom date range selection
- More configurable metrics for trending
- Downloadable trend charts
