#!/bin/sh

# Usage function
usage() {
    echo "Usage: $0 <hostname_or_ip> [ping_count]"
    echo "Example: $0 google.com 100"
    exit 1
}

# Check if an argument is given
if [ -z "$1" ]; then
    usage
fi

TARGET="$1"

# Function to check if input is a valid IP
is_ip() {
    [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

# Resolve hostname to IP if necessary
if is_ip "$TARGET"; then
    IP="$TARGET"
else
    # Try resolving hostname to IP
    IP=$(dig +short "$TARGET" | head -n 1)

    # If dig fails, use host command
    if [ -z "$IP" ]; then
        IP=$(host "$TARGET" | awk '/has address/ { print $4; exit }')
    fi

    # If IP resolution fails
    if [ -z "$IP" ]; then
        echo "Could not resolve IP for $TARGET"
        exit 1
    fi
fi

# Default number of pings in rolling average
PING_COUNT=${2:-10}  # Default to 10 if not provided

echo "Pinging IP: $IP with rolling average of last $PING_COUNT pings"

# Run ping in a loop and calculate rolling average
ping_times=()
seq_num=1  # Sequence number for each ping

while true; do
    # Get the start time before ping
    start_time=$(date +%s.%N)  # High-precision timestamp

    # Get the current timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Get a single ping response time with 1 second timeout
    ping_output=$(ping -c 1 "$IP" -t 1)
    ping_time=$(echo "$ping_output" | awk -F'=' '/time=/{print $NF+0}')

    # # Print the full ping output for debugging
    # echo "[$timestamp] Ping $seq_num response: "
    # echo "$ping_output"

    # If the ping was successful, store it
    if [[ -n "$ping_time" ]]; then
        ping_times+=("$ping_time")

        # If we have more than PING_COUNT values, remove the oldest one
        if (( ${#ping_times[@]} > PING_COUNT )); then
            ping_times=("${ping_times[@]:1}")
        fi

        # Calculate the rolling average
        sum=0
        for time in "${ping_times[@]}"; do
            sum=$(echo "$sum + $time" | bc)
        done
        avg=$(echo "scale=2; $sum / ${#ping_times[@]}" | bc)

        # Print the rolling average with timestamp and sequence number
        printf "[$timestamp] aPing %5d -> %s ms\n" "$seq_num" "$avg"
        else
        printf "[$timestamp] aPing %5d -> Ping failed\n" "$seq_num"
    fi

    # Get the end time after ping
    end_time=$(date +%s.%N)

    # Calculate time taken for ping
    time_taken=$(echo "$end_time - $start_time" | bc)

    # Calculate remaining sleep time to ensure exactly 1s interval
    sleep_time=$(echo "1 - $time_taken" | bc)

    # Ensure sleep time is not negative
    if (( $(echo "$sleep_time > 0" | bc -l) )); then
        sleep "$sleep_time"
    fi

    # Increment sequence number
    ((seq_num++))
done