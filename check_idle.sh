#!/bin/bash

# Thresholds for CPU and disk I/O considered idle
CPU_IDLE_THRESHOLD=10
DISK_IDLE_THRESHOLD=1  # in KB/s

# Get the average CPU usage over the last minute
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Get the disk I/O in KB/s (read and write)
DISK_IO=$(iostat -d 1  | awk 'NR==6 {print $3 + $4}')

# Check for active SSH connections
SSH_CONNECTIONS=$(ss -t state established '( sport = :ssh )' | grep -c ssh)

echo "Current CPU Usage: $CPU_USAGE%"
echo "Current Disk I/O: $DISK_IO KB/s"
echo "Active SSH Connections: $SSH_CONNECTIONS"

if (( $(echo "$CPU_USAGE < $CPU_IDLE_THRESHOLD" | bc -l) )) && (( $(echo "$DISK_IO < $DISK_IDLE_THRESHOLD" | bc -l) )) && [ "$SSH_CONNECTIONS" -eq 0 ]; then
  echo "CPU usage is below $CPU_IDLE_THRESHOLD%, Disk I/O is below $DISK_IDLE_THRESHOLD KB/s, and no active SSH connections. Shutting down the server..."
  sudo shutdown -h now
fi
