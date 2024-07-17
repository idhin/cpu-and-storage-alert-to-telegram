#!/bin/bash

get_cpu_usage() {
    cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$cpu"
}

get_storage_usage() {
    storage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "$storage"
}

# Token dan Chat ID Telegram
bot_token="TOKEN-TELEGRAM"
chat_id="CHAT-ID-GROUP"

# Nama server
server_name="NAMASERVER-KAMU"

# Fungsi untuk mengirim pesan ke Telegram
send_telegram_message() {
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" \
        -d chat_id="$chat_id" \
        -d text="$message"
}

# Loop utama untuk memeriksa kondisi setiap 5 menit
while true; do
    cpu_usage=$(get_cpu_usage)
    storage_usage=$(get_storage_usage)

    #silahkan ganti 95 itu dengan threeshold kamu
    if (( $(echo "$cpu_usage >=95" | bc -l) )); then
        message="⚠️ [$server_name] [Testing-Script-DevsecOps] CPU usage is at $cpu_usage%."
        send_telegram_message "$message"
    fi

    #silahkan ganti 90 itu dengan threeshold kamu
    if (( $(echo "$storage_usage >=90" | bc -l) )); then
        message="⚠️ [$server_name] [Testing-Script-DevsecOps] Storage usage is at $storage_usage%."
        send_telegram_message "$message"
    fi

    sleep 5 
done