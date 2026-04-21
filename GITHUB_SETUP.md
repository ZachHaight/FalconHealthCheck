# GitHub Setup Instructions

This guide explains how to share the Falcon Health Check Visualizer on GitHub while keeping your sensitive data private.

## What's Already Set Up

I've created the following files to protect your data:

### 1. `.gitignore`
Automatically excludes:
- `Falcon_Health_Check_Stats_*.json` (your actual data files)
- `list_files.json` (your actual file list)
- System files (.DS_Store, etc.)
- Editor files (.vscode, .idea, etc.)

### 2. `sample_data.json`
Example data structure with fake data showing how to format health check files.

### 3. `list_files.sample.json`
Template showing how to configure the file list.

### 4. `README.md`
Complete documentation for users of the visualizer.

## Initial GitHub Setup

### Step 1: Initialize Git Repository

```bash
cd /Users/zhaight/Desktop/Value

# Initialize git (if not already done)
git init
```

### Step 2: Add Files

The `.gitignore` file will automatically exclude your real data:

```bash
# Stage all files (gitignore protects sensitive data)
git add .

# Check what will be committed
git status
```

**What gets included:**
- ✅ visualizer.html
- ✅ sample_data.json
- ✅ list_files.sample.json
- ✅ README.md
- ✅ .gitignore
- ✅ GITHUB_SETUP.md

**What stays private:**
- ❌ Falcon_Health_Check_Stats_*.json (your real data)
- ❌ list_files.json (your real file list)

### Step 3: Make First Commit

```bash
git commit -m "Initial commit - Falcon Health Check Visualizer"
```

### Step 4: Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (choose a name like `falcon-health-check-visualizer`)
3. **Do NOT** initialize with README (we already have one)
4. Choose visibility (Public or Private)

### Step 5: Push to GitHub

```bash
# Add GitHub remote (replace with your actual repo URL)
git remote add origin https://github.com/yourusername/falcon-health-check-visualizer.git

# Push to main branch
git branch -M main
git push -u origin main
```

## Future Updates

### Adding New Features

```bash
cd /Users/zhaight/Desktop/Value

# Stage changes
git add visualizer.html

# Commit with descriptive message
git commit -m "Add new feature: XYZ"

# Push to GitHub
git push
```

### Updating Documentation

```bash
# After modifying README.md
git add README.md
git commit -m "Update documentation"
git push
```

### Checking What Will Be Committed

Before committing, always verify your data is protected:

```bash
# See what files are staged
git status

# See what's in the commit
git diff --cached

# If you accidentally staged a data file:
git reset HEAD filename.json
```

## Verifying Data Protection

### Double-Check Before Pushing

```bash
# List all tracked files
git ls-files

# Should NOT include:
# - Falcon_Health_Check_Stats_*.json
# - list_files.json
```

### If You Accidentally Committed Sensitive Data

**IMPORTANT:** If you pushed sensitive data to GitHub, you need to:

1. **Remove from history:**
```bash
# Remove file from all commits
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch your-sensitive-file.json" \
  --prune-empty --tag-name-filter cat -- --all
```

2. **Force push:**
```bash
git push origin --force --all
```

3. **Consider the data compromised** - Rotate any credentials, notify affected parties

4. **Better approach:** Delete the repo and start fresh if it's a new project

## Instructions for Others Using Your Repo

When someone clones your repo, they need to:

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/falcon-health-check-visualizer.git
cd falcon-health-check-visualizer
```

2. **Set up their data files:**
```bash
# Copy the sample to create their own file list
cp list_files.sample.json list_files.json

# Add their own health check JSON files to the directory
# (these will be gitignored automatically)
```

3. **Update list_files.json** with their file names

4. **Serve the application:**
```bash
python3 -m http.server 8000
```

5. **Open in browser:**
```
http://localhost:8000/visualizer.html
```

## Best Practices

### ✅ Do:
- Commit code changes (visualizer.html)
- Commit documentation updates (README.md)
- Commit sample/template files
- Review `git status` before committing
- Use descriptive commit messages

### ❌ Don't:
- Commit actual health check data files
- Commit list_files.json (use list_files.sample.json as template)
- Commit files with customer CIDs or names
- Force push unless absolutely necessary
- Share credentials in code or documentation

## Troubleshooting

### "My data files are showing up in git status"

Check that `.gitignore` is in place and contains:
```
Falcon_Health_Check_Stats_*.json
list_files.json
```

### "I want to add a new data file pattern to ignore"

Edit `.gitignore` and add the pattern:
```bash
echo "new_pattern_*.json" >> .gitignore
git add .gitignore
git commit -m "Update gitignore"
```

### "I need to change the GitHub remote URL"

```bash
# View current remote
git remote -v

# Change remote URL
git remote set-url origin https://github.com/new-username/new-repo.git
```

## Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Removing Sensitive Data from GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)

## Questions?

If you have questions about this setup, refer to:
- This file (GITHUB_SETUP.md)
- README.md for visualizer usage
- .gitignore for what's excluded
