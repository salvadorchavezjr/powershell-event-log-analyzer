
# ==========================================
# MSSA Project 4
# Windows Event Log Analyzer
# Version 2.0
# ==========================================

# Display the application menu
function Show-Menu {
    Clear-Host

    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host "       WINDOWS EVENT LOG ANALYZER    " -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "1. View Recent System Errors"
    Write-Host "2. View Recent System Warnings"
    Write-Host "3. Display Event Source Summary"
    Write-Host "4. Search Events by Event ID"
    Write-Host "5. Filter Events by Date"
    Write-Host "6. Export Events to CSV"
    Write-Host "7. Exit"
    Write-Host ""
}

# Retrieve Windows events
function Get-SystemEvents {
    param(
        [hashtable]$Filter,
        [int]$MaxEvents = 50
    )

    try {
        $Events = @(
            Get-WinEvent -FilterHashtable $Filter `
                -MaxEvents $MaxEvents -ErrorAction Stop
        )

        return $Events
    }
    catch {
        if ($_.FullyQualifiedErrorId -like "NoMatchingEventsFound*") {
            Write-Host "No matching events found." -ForegroundColor Yellow
        }
        else {
            Write-Host "Unable to retrieve events: $($_.Exception.Message)" -ForegroundColor Red
        }

        return
    }
}

# Display events in a readable table
function Show-Events {
    param(
        [object[]]$Events
    )

    if (-not $Events -or $Events.Count -eq 0) {
        return
    }

    $Events |
        Select-Object TimeCreated, Id, LevelDisplayName,
            ProviderName, Message |
        Format-Table -Wrap
}

# OPTION 1: Recent system errors
function Show-SystemErrors {
    Write-Host "`n=== RECENT SYSTEM ERRORS ===" -ForegroundColor Yellow

    $Events = @(Get-SystemEvents -Filter @{
        LogName = "System"
        Level = 2
    } -MaxEvents 20)

    Show-Events -Events $Events
}

# OPTION 2: Recent system warnings
function Show-SystemWarnings {
    Write-Host "`n=== RECENT SYSTEM WARNINGS ===" -ForegroundColor Yellow

    $Events = @(Get-SystemEvents -Filter @{
        LogName = "System"
        Level = 3
    } -MaxEvents 20)

    Show-Events -Events $Events
}

# OPTION 3: Event source summary
function Show-EventSummary {
    Write-Host "`n=== EVENT SOURCE SUMMARY ===" -ForegroundColor Yellow

    $Events = @(Get-SystemEvents -Filter @{
        LogName = "System"
    } -MaxEvents 100)

    if ($Events.Count -gt 0) {
        $Events |
            Group-Object ProviderName |
            Sort-Object Count -Descending |
            Select-Object -First 10 Count, Name |
            Format-Table -AutoSize
    }
}

# OPTION 4: Search by Event ID
function Search-EventID {
    Write-Host "`n=== SEARCH BY EVENT ID ===" -ForegroundColor Yellow

    $InputID = Read-Host "Enter an Event ID (example: 7036)"

    $EventID = 0

    if (-not [int]::TryParse($InputID, [ref]$EventID) -or
        $EventID -lt 0) {
        Write-Host "Please enter a valid Event ID." -ForegroundColor Red
        return
    }

    $Events = @(Get-SystemEvents -Filter @{
        LogName = "System"
        Id = $EventID
    } -MaxEvents 30)

    Show-Events -Events $Events
}

# OPTION 5: Filter by date
function Search-EventsByDate {
    Write-Host "`n=== FILTER EVENTS BY DATE ===" -ForegroundColor Yellow
    Write-Host "1. Last 24 hours"
    Write-Host "2. Last 7 days"

    $Selection = Read-Host "Choose a time range (1-2)"

    switch ($Selection) {
        "1" { $StartDate = (Get-Date).AddHours(-24) }
        "2" { $StartDate = (Get-Date).AddDays(-7) }
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            return
        }
    }

    Write-Host "Searching for errors and warnings..." -ForegroundColor Cyan

    $Events = @(Get-SystemEvents -Filter @{
        LogName = "System"
        Level = @(2, 3)
        StartTime = $StartDate
    } -MaxEvents 100)

    Show-Events -Events $Events
}

# OPTION 6: Export system events
function Export-EventReport {
    Write-Host "`n=== EXPORT EVENT REPORT ===" -ForegroundColor Yellow

    try {
        $Events = @(Get-SystemEvents -Filter @{
            LogName = "System"
            Level = @(2, 3)
            StartTime = (Get-Date).AddDays(-7)
        } -MaxEvents 200)

        if ($Events.Count -eq 0) {
            Write-Host "No events to export." -ForegroundColor Yellow
            return
        }

        # Create Reports folder
        $ReportFolder = Join-Path $PSScriptRoot "Reports"

        if (-not (Test-Path -LiteralPath $ReportFolder)) {
            New-Item -ItemType Directory -Path $ReportFolder `
                -ErrorAction Stop | Out-Null
        }

        # Create unique filename
        $Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $ReportPath = Join-Path $ReportFolder "EventReport_$Timestamp.csv"

        # Export events
        $Events |
            Select-Object TimeCreated, Id, LevelDisplayName,
                ProviderName, LogName, Message |
            Export-Csv -LiteralPath $ReportPath `
                -NoTypeInformation -Encoding UTF8 -ErrorAction Stop

        Write-Host "`nReport generated successfully!" -ForegroundColor Green
        Write-Host "Events exported: $($Events.Count)"
        Write-Host "Saved to: $ReportPath" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Export failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# MAIN APPLICATION LOOP
do {
    Show-Menu

    $Choice = Read-Host "Enter your selection (1-7)"

    switch ($Choice) {
        "1" { Show-SystemErrors }
        "2" { Show-SystemWarnings }
        "3" { Show-EventSummary }
        "4" { Search-EventID }
        "5" { Search-EventsByDate }
        "6" { Export-EventReport }
        "7" {
            Write-Host "Exiting Event Log Analyzer..." -ForegroundColor Green
        }
        default {
            Write-Host "Invalid selection. Choose 1-7." -ForegroundColor Red
        }
    }

    if ($Choice -ne "7") {
        Write-Host ""
        Read-Host "Press Enter to return to the menu"
    }

} while ($Choice -ne "7")
