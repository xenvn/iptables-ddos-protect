#!/bin/sh

# ----------------------------- #
# Now we will create the script
# Step 1: Create a bash script with the name of iptables.sh
# vi /root/iptables.sh

# Step 2: Paste the above given script contents in your bash script file iptables.sh

# Step 3: Make the Read Write Execute permission
# chmod +x /root/iptables.sh

# Step 4 : Now run the script
# sh /root/iptables.sh

# Step 5: Check the IPTABLES rule with following command
# iptables -nL
# iptables -t mangle -nL
# ----------------------------- #

# Flush all iptables
iptables -F
iptables -X

### 1: Drop invalid packets ###
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

### 2: Drop TCP packets that are new and are not SYN ###
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

### 3: Drop SYN packets with suspicious MSS value ###
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

### 4: Block packets with bogus TCP flags ###
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP

### 5: Block spoofed packets ###
iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP

### 6: Drop fragments in all chains ###
iptables -t mangle -A PREROUTING -f -j DROP

### 7: Limit connections per source IP ###
iptables -A INPUT -p tcp -m connlimit --connlimit-above 200 -j REJECT --reject-with tcp-reset

### 8: Limit new TCP connections per second per source IP ###
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 60 -j ACCEPT
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

### 9: SSH brute-force protection ###
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 5 -j DROP

### Save All Rules ###
iptables-save
