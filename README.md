# Rolling Ping Monitor (aping)

A shell script to monitor rolling average of ping responses in real-time.

## 📌 Table of Contents
- [📥 Clone the Repository](#-clone-the-repository)
- [🚀 Installation](#-installation)
- [📌 Usage](#-usage)
- [📝 Example](#-example)
- [📖 Features](#-features)
- [📊 Sample Output](#-sample-output)


## 📥 Clone the Repository

```sh
git clone https://github.com/hsmmi/rolling-ping-monitor.git
```

## 🚀 Installation

```sh
cd rolling-ping-monitor
sudo mv rolling_ping_avg.sh /usr/local/bin/aping
sudo chmod +x /usr/local/bin/aping
``` 

Now, you can use it like a built-in command:

```sh
aping google.com 20
```

## 📌 Usage

```sh
aping <hostname_or_ip> [ping_count]
```
- <hostname_or_ip>: The domain or IP address to ping.
- [ping_count] (Optional, default = 10): The number of pings to include in the rolling average.


## 📝 Example
1. 	Ping Google continuously with a rolling average of 10 pings(default):
```sh
aping google.com
```
2. 	Ping Cloudflare’s DNS with a rolling average of 50 pings:
```sh
aping 1.1.1.1 50
```

## 📖 Features

✅ Shows rolling average of last N pings
✅ Includes timestamps for better logging
✅ Supports both hostnames and IPs
✅ Works as a command-line utility (aping)

## 📊 Sample Output

```sh
aping google.com 5
```
You will see the output like this:

```sh
Pinging IP: 142.250.181.238 with rolling average of last 5 pings
[2025-02-26 13:27:51] Ping 1 -> 135.90 ms
[2025-02-26 13:27:52] Ping 2 -> 165.25 ms
[2025-02-26 13:27:53] Ping 3 -> 150.74 ms
[2025-02-26 13:27:54] Ping 4 -> 143.72 ms
[2025-02-26 13:27:55] Ping 5 -> 138.98 ms
[2025-02-26 13:27:57] Ping 6 -> 136.06 ms
[2025-02-26 13:27:58] Ping 7 -> 122.15 ms
[2025-02-26 13:27:59] Ping 8 -> 122.84 ms
[2025-02-26 13:28:00] Ping 9 -> 122.77 ms
[2025-02-26 13:28:01] Ping 10 -> 123.71 ms
[2025-02-26 13:28:02] Ping 11 -> 124.58 ms
[2025-02-26 13:28:04] Ping 12 -> 124.22 ms
[2025-02-26 13:28:05] Ping 13 -> 127.78 ms
[2025-02-26 13:28:06] Ping 14 -> 152.48 ms
[2025-02-26 13:28:07] Ping 15 -> 151.52 ms
```
