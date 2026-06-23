# Security-Patches.
This project contains a Bash script to check available security patches on a Debian/Ubuntu server, generate a CSV report, and email the report to a configured recipient.

## Features

- Checks for available security updates
- Generates a CSV report with:
  - Package name
  - Current version
  - Available version
  - Repository
- Sends the report through email
- Automatically removes reports older than 180 days
- Stores reports in `/security_patch`

## Requirements

This script is designed for Debian/Ubuntu-based Linux servers.

Required packages:

```bash
sudo apt-get install mailutils
