#!/bin/bash

# # Clear terminal screen
clear

# 1. Get CPU Usage (calculates total active vs idle)
# Source: Uses /proc/stat snapshot differences for precision
cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.2f", usage}')

# 2. Get Memory Usage (RAM)
# Source: Parses output of the 'free' utility
memory_info=$(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)", $3,$2,$3*100/$2}')

# 3. Get Disk Usage (Root partition)
# Source: Parses output of the 'df' utility
disk_info=$(df -h / | awk 'NR==2{printf "Disk Usage:    %s/%s (%s used)", $3,$2,$5}')


# ---- THIS IS THE FIX: Only redirect AFTER the variables are filled ----

OUTPUT_FILE="/home/abdallah/health_report_$(date +%F_%H-%M).txt"

{
    echo "=========================================="
    echo "         SYSTEM RESOURCE USAGE            "
    echo "=========================================="
    echo "Date/Time : $(date)"
    echo "Host      : $(hostname)"
    echo "Uptime    : $(uptime -p)"
    echo "=========================================="
    echo "CPU Usage:    $cpu_usage%"
    echo "$memory_info"
    echo "$disk_info"
    echo "=========================================="
} | tee "$OUTPUT_FILE"

echo " Saved to $OUTPUT_FILE"
