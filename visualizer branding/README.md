# Visualizer Branding

This folder contains logo and branding images used in the Falcon Health Check Visualizer.

## Current Images

- **CrowdStrike_Logo_2023_Secondary_Black.png** - CrowdStrike logo
- **AWS Logo.png** - AWS logo (for Amazon-specific deployments)
- **Crowdstrike Logo.png** - Alternative CrowdStrike logo

## Customization

To use your own branding:

1. Replace the PNG files in this folder with your organization's logos
2. Keep the same filenames, or update the references in `FalconHealthCheckVisualizer.html` (line ~1449-1450)

```html
<div class="logo-container">
    <img src="visualizer branding/YOUR_LOGO.png" alt="Your Logo">
    <img src="visualizer branding/PARTNER_LOGO.png" alt="Partner Logo">
</div>
```

## Image Guidelines

- **Format:** PNG with transparent background recommended
- **Size:** Approximately 150-200px height for optimal display
- **Aspect Ratio:** Maintain reasonable aspect ratio for header layout
- **File Size:** Keep under 500KB for fast page loads

## Removing Logos

To display without logos, edit `FalconHealthCheckVisualizer.html` and remove or comment out the logo-container div.
