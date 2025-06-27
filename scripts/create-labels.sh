#!/usr/bin/env bash
# Script to create custom labels for the GitHub repository using GitHub CLI
echo "Creating custom labels for the repository..."

echo "Phase/Status Labels"
gh label create "planning" --color "6c757d" --description "Item is in planning phase"
gh label create "design" --color "6f42c1" --description "Item is in design phase"
gh label create "development" --color "ffc107" --description "Item is in development"
gh label create "testing" --color "fd7e14" --description "Item is in testing phase"
gh label create "released" --color "28a745" --description "Item has been released"
gh label create "blocked" --color "dc3545" --description "Item is blocked and needs attention"

echo "Priority Labels"
gh label create "priority-critical" --color "b60205" --description "Critical priority - immediate attention required"
gh label create "priority-high" --color "d73a49" --description "High priority - should be addressed soon"
gh label create "priority-medium" --color "ffc107" --description "Medium priority - standard timeline"
gh label create "priority-low" --color "28a745" --description "Low priority - can be scheduled flexibly"

echo "Feature Area Labels"
gh label create "area-core" --color "e99695" --description "Core functionality"
gh label create "area-infrastructure" --color "5dade2" --description "Infrastructure related"
gh label create "area-security" --color "bb8fce" --description "Security related"
gh label create "area-api" --color "76d7c4" --description "API related"
gh label create "area-ui-ux" --color "f8c8dc" --description "UI/UX related"
gh label create "area-documentation" --color "d7bde2" --description "Documentation related"

echo "Team Labels"
gh label create "team-frontend" --color "bdd3f7" --description "Frontend team"
gh label create "team-backend" --color "c3e6c3" --description "Backend team"
gh label create "team-devops" --color "ffd4a3" --description "DevOps team"
gh label create "team-design" --color "f8c8dc" --description "Design team"
gh label create "team-qa" --color "fff3cd" --description "QA team"

echo "Effort Labels"
gh label create "effort-small" --color "c6f6d5" --description "Small effort required"
gh label create "effort-medium" --color "fff3cd" --description "Medium effort required"
gh label create "effort-large" --color "f8d7da" --description "Large effort required"

echo "All labels created!"
