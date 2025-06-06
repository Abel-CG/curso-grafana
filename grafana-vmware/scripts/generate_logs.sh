#!/bin/bash

OUTPUT="vm_simulated_logs.log"
VMS=(vm{01..30})
SSH_MESSAGES=(
  "Accepted password for root from 192.168.1.%d port %d ssh2"
  "Failed password for invalid user guest from 192.168.1.%d port %d ssh2"
  "pam_unix(sshd:session): session opened for user root"
  "Received disconnect from 192.168.1.%d port %d:11: Bye Bye"
)
FTP_MESSAGES=(
  "USER admin login failed"
  "USER root login successful"
  "Passive data connection established"
  "RETR file.txt successful"
)
SPRING_MESSAGES=(
  "INFO org.springframework.boot.Startup - Application started successfully"
  "WARN com.example.service.UserService - Unexpected login attempt"
  "ERROR org.hibernate.engine - Failed to initialize database connection"
  "DEBUG com.example.controller.HomeController - Handling request /home"
)

LOG_TYPES=("ssh" "ftp" "springboot")

while true; do
  VM=${VMS[$RANDOM % ${#VMS[@]}]}
  LOG_TYPE=${LOG_TYPES[$RANDOM % ${#LOG_TYPES[@]}]}
  TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")

  case $LOG_TYPE in
    ssh)
      MSG_TEMPLATE=${SSH_MESSAGES[$RANDOM % ${#SSH_MESSAGES[@]}]}
      MSG=$(printf "$MSG_TEMPLATE" $((RANDOM % 255)) $((1024 + RANDOM % 50000)))
      ;;
    ftp)
      MSG=${FTP_MESSAGES[$RANDOM % ${#FTP_MESSAGES[@]}]}
      ;;
    springboot)
      MSG=${SPRING_MESSAGES[$RANDOM % ${#SPRING_MESSAGES[@]}]}
      ;;
  esac

  LOG_LINE="{\"@timestamp\":\"$TIMESTAMP\",\"vm\":\"$VM\",\"log_type\":\"$LOG_TYPE\",\"message\":\"$MSG\"}"

  echo "$LOG_LINE" >> "$OUTPUT"

  # Enviar línea a ElasticSearch
  curl -s -X POST "http://elasticsearch:9200/vm-logs/_doc" \
    -H 'Content-Type: application/json' \
    -d "$LOG_LINE" > /dev/null

  echo "Log enviado: $LOG_LINE"

  sleep 2
done
