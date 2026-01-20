#!/bin/bash

# Deployment Script for Danesh Selwal's Portfolio

echo "Starting deployment process..."

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git..."
    git init
fi

# Create GitHub Repo if gh is available
if command -v gh &> /dev/null; then
    echo "Creating GitHub repository..."
    if gh repo create daneshselwal.github.io --public --source=. --remote=origin --push; then
        echo "Repository created successfully."
    else
        echo "Repository creation failed (might already exist). Proceeding to link..."
    fi
else
    echo "GitHub CLI (gh) not found. Skipping repo creation."
fi

# Add remote if it doesn't exist
if ! git remote | grep -q origin; then
    echo "Adding remote origin..."
    git remote add origin https://github.com/daneshselwal/daneshselwal.github.io.git
else
    echo "Remote origin already exists."
fi

# Ensure correct branch
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "Renaming current branch to main..."
    git branch -M main
fi

# Check status
if [ -n "$(git status --porcelain)" ]; then
    echo "Staging and committing changes..."
    git add .
    git commit -m "feat: Initial deployment of professional portfolio"
else
    echo "No changes to commit."
fi

# Attempt push
echo "Pushing to GitHub Pages..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo "Deployment successful!"
else
    echo "Deployment failed. Please check your GitHub credentials and permissions."
    echo "You may need to authenticate using 'gh auth login' or by using a Personal Access Token."
fi
