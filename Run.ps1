# Get the regex pattern from the user
$regex = Read-Host "Enter the regex pattern to filter commits"

# Get the list of commits that match the regex
$commits = git log --oneline | Select-String -Pattern $regex

# Check if there are any matching commits
if (-not $commits) {
    Write-Host "No commits found matching the regex."
    exit 0
}

# Prepare the commit list for fzf
$commitList = $commits | ForEach-Object { $_.ToString() }

# Use fzf to select a commit and show the diff preview
$selectedCommit = $commitList | fzf --preview { git show --color=always ($args[0] -split ' ')[0] } --preview-window=up:30%:wrap --height=40% --ansi

# If a commit was selected, show the diff
if ($selectedCommit) {
    $commitHash = ($selectedCommit -split ' ')[0]
    git show $commitHash
}

