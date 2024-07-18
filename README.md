# check_Idle
This script check and shutdown server if if it is idle 
- chmod +x /path/to/idle_check.sh
- crontab -e
- */5 * * * * /path/to/idle_check.sh >> /path/to/idle_check.log 2>&1
