# PowerShell Windows Event Log Analyzer

An interactive Windows event log analysis tool developed with PowerShell as part of my Microsoft Software & Systems Academy (MSSA) Server & Cloud Administration training.

## Project Overview

The Windows Event Log Analyzer helps IT administrators investigate system errors, identify recurring warnings, and generate troubleshooting reports.

The application provides an interactive menu that simplifies common Windows event log analysis tasks.

## Features

1. **Recent System Errors** — Retrieves the 20 most recent System log errors.
2. **Recent System Warnings** — Displays the 20 most recent System log warnings.
3. **Event Source Summary** — Identifies the most frequent event providers among the latest 100 System events.
4. **Event ID Search** — Allows users to investigate Windows events using specific Event IDs.
5. **Date Filtering** — Filters errors and warnings from the last 24 hours or seven days.
6. **CSV Report Generation** — Exports up to 200 recent errors and warnings to a timestamped CSV file.

## Technologies Used

- Windows PowerShell
- Windows Event Logs
- Visual Studio Code
- Git and GitHub
- CSV reporting

## How to Run

**Requirements:** Windows with Windows PowerShell 5.1 or a compatible PowerShell environment that supports `Get-WinEvent`.

1. Clone or download the repository.
2. Open the project folder in VS Code.
3. Open a PowerShell terminal.
4. Run:

```powershell
.\EventLogAnalyzer.ps1
```

Review the script before running it and follow the execution policies applicable to your computer.

## Application Menu

```text
====================================
       WINDOWS EVENT LOG ANALYZER
====================================

1. View Recent System Errors
2. View Recent System Warnings
3. Display Event Source Summary
4. Search Events by Event ID
5. Filter Events by Date
6. Export Events to CSV
7. Exit
```

## Project Structure

```text
Windows-Event-Log-Analyzer/
├── EventLogAnalyzer.ps1
├── .gitignore
└── README.md
```

The application creates a local `Reports` folder when a CSV report is successfully exported. These reports are excluded from Git tracking.

## PowerShell Concepts Demonstrated

- Functions and reusable code
- Variables and hashtables
- Switch statements
- Do-while loops
- Conditional logic
- Try/catch error handling
- PowerShell pipelines
- Filtering and grouping objects
- Exporting data into CSV files

## What I Learned

Through this project, I practiced retrieving and analyzing Windows System event logs using PowerShell.

I learned how to filter events based on severity, Event ID, and date, group results to identify common event sources, and automate report generation.

The project also helped reinforce the importance of investigating event records in context rather than assuming every logged error represents an active problem.

## Limitations

- Currently analyzes the Windows System log only.
- Some event logs may require elevated permissions.
- Report exports are limited to 200 matching events.
- Generated reports may contain sensitive system information and should not be uploaded publicly.

## Future Improvements

- Analyze Application and Security logs.
- Add advanced Event ID filtering.
- Generate HTML reports.
- Add graphical charts for recurring errors.
- Introduce automated event monitoring and alerting.

## Author

**Salvador Chavez Jr.**

Microsoft Software & Systems Academy — Server & Cloud Administration

U.S. Navy | Aspiring IT Professional