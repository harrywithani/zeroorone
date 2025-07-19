---
title: "Essential Linux Commands"
date: 2025-01-20
description: "A reference guide for the most commonly used Linux commands"
categories: ["linux"]
tags: ["commands", "cli", "reference"]
---

# Essential Linux Commands

This is a comprehensive reference for the most commonly used Linux commands that every system administrator should know.

## File Operations

### Basic File Commands

The `ls` command lists directory contents:

```bash
ls -la    # List all files with detailed information
ls -lh    # Human-readable file sizes
```

### File Management

Moving and copying files:

```bash
cp source destination     # Copy files
mv source destination     # Move/rename files
rm filename              # Delete files
rm -rf directory         # Delete directory and contents
```

## Text Processing

### Viewing Files

```bash
cat filename             # Display entire file
less filename           # View file with pagination
head -n 20 filename     # Show first 20 lines
tail -f logfile         # Follow log file changes
```

### Text Manipulation

```bash
grep "pattern" filename  # Search for patterns
sed 's/old/new/g' file  # Replace text
awk '{print $1}' file   # Print first column
```

## System Monitoring

### Process Management

```bash
ps aux                  # List all processes
top                     # Real-time process viewer
htop                    # Better top alternative
kill PID                # Terminate process
```

### System Information

```bash
df -h                   # Disk space usage
free -h                 # Memory usage
uptime                  # System uptime
uname -a                # System information
```

## Network Commands

### Basic Networking

```bash
ping hostname           # Test connectivity
wget URL                # Download files
curl URL                # Transfer data
netstat -tulpn         # Show listening ports
```

## File Permissions

Understanding Linux permissions:

```bash
chmod 755 filename      # Set permissions
chown user:group file   # Change ownership
```

Permission values:
- 4 = read
- 2 = write  
- 1 = execute

## Tips and Tricks

1. Use `Tab` completion to save time
2. `Ctrl+R` for reverse search in command history
3. `!!` repeats the last command
4. `sudo !!` runs the last command with sudo

