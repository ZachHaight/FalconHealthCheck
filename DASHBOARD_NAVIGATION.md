# Dashboard & Navigation Menu - New Features

## 🎉 Major Update: Dashboard Landing Page

The Amazon Health Check visualizer now features a **professional dashboard interface** with left sidebar navigation!

---

## 🏠 Dashboard Overview

### **Default Landing Page**
When you open the visualizer, you now see a **Dashboard** with:

#### **Key Metrics Cards** (Similar to CrowdStrike UI):
- **Total Devices** - All endpoints
- **Online Devices** - Currently connected
- **Policy Score** - Out of 100
- **Critical Policy Score** - Out of 100
- **Windows Devices** - Count
- **Mac Devices** - Count
- **Linux Devices** - Count
- **Total Detections** - All severities

#### **Trend Chart**:
- **Device Count Trends** - Line chart showing device counts over time
- Displays "Total Devices" vs "Online Devices"
- Color-coded: Red (Total), Green (Online)
- Interactive Chart.js visualization

#### **CID Selector**:
- Dropdown at the top to switch between companies
- Defaults to "AWS Corporate Production"
- All dashboard metrics update instantly when changed

---

## 📋 Left Sidebar Navigation

### **Menu Structure:**
```
📊 Navigation
├── 🏠 Dashboard (Default view)
├── 📈 Stats
├── 🔄 Sensor Updates
├── 🚨 Detections
├── 💻 Operating System Versions
├── 🔧 Agent Versions
├── 🔐 2026 Certificate Rotation
├── 📋 Policy Scores
├── 🛡️ Prevention Toggles
└── ⚙️ Module Enablement
```

### **Features:**
- **Always Visible** - Fixed left sidebar (250px wide)
- **Active State** - Current page highlighted in red
- **Hover Effects** - Smooth transitions
- **Icons** - Each item has an emoji icon for quick recognition
- **Dark Theme** - Black background (#1a1a1a) with red accents

---

## 🎨 Design Elements

### **Color Scheme:**
- **Sidebar**: Dark (#1a1a1a) with red border
- **Cards**: Dark background with red borders
- **Metrics**: Large numbers in red (#ff3333)
- **Active Nav**: Red highlight with left border
- **Charts**: Dark background, white text

### **Layout:**
- **Sidebar**: 250px fixed width
- **Main Content**: Remaining space (with margin-left: 250px)
- **Responsive**: Sidebar collapses on mobile

---

## 🚀 How to Use

### **Navigate:**
1. Click **Dashboard** (🏠) to see overview
2. Click any data sheet to drill into details
3. Active page is highlighted in red

### **Dashboard:**
1. Select CID from dropdown
2. View key metrics in large cards
3. See trend chart at bottom
4. All metrics are real-time from selected snapshot

### **Data Sheets:**
- Click any sheet in sidebar
- Same functionality as before (date selector, CID selector, delta toggle, trends)
- No tabs anymore - navigate via sidebar instead

---

## 📊 Dashboard Metrics Source

All metrics pulled from the **current snapshot's data** for the **selected CID**:

- **Device Counts**: `stats_data`
- **Policy Scores**: `stats_data`
- **Detection Counts**: `detects_severity_data`
- **Trends**: Aggregated across all 5 snapshots

---

## 🔧 Technical Implementation

### **New Variables:**
- `currentView` - Tracks if on 'dashboard' or specific sheet
- `dashboardCharts` - Stores dashboard chart instances

### **New Functions:**
- `navigateTo(view)` - Handles sidebar navigation
- `showDashboard()` - Renders dashboard view
- `renderDashboardCharts()` - Creates trend charts
- `hideTabs()` - Hides old tab navigation

### **Layout Changes:**
- Added `.sidebar` with fixed positioning
- Added `.main-layout` wrapper with left margin
- Added `.dashboard-grid` for metric cards
- Added `.metric-card` styling

---

## 📁 Backups Created

- `visualizer_pre_dashboard.html` - Version before dashboard changes
- `visualizer_backup.html` - Original version

---

## ✨ What's Different

### **Before:**
- Tabs at top for navigation
- No landing page
- Direct to data sheets

### **After:**
- ✅ Left sidebar navigation
- ✅ Dashboard landing page
- ✅ Large metric cards with trend chart
- ✅ CrowdStrike-style UI
- ✅ Better information hierarchy

---

**Refresh:** `http://localhost:8000/visualizer.html`

You'll see the new dashboard with sidebar navigation! 🎉
