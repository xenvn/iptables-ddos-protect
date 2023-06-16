# iptables-ddos-protect
DDoS Protection With IPtables
![XenVn-DDoS Protection With IPtables - The Ultimate Guide](https://github.com/xenvn/iptables-ddos-protect/assets/112816533/b1cbd3cd-c039-4d41-8d3a-8ab562524017)

**There are different ways of building your own anti-DDoS rules for iptables. We will be discussing the most effective iptables DDoS protection methods in this comprehensive tutorial.**

This guide will teach you how to select the best iptables table and chain to stop DDoS attacks.
Please note that this article is written for professionals who deal with Linux servers on a daily basis.

What Is IPtables?
netfilter iptables (soon to be replaced by nftables) is a user-space command line utility to configure kernel packet filtering rules developed by netfilter.
It’s the default firewall management utility on Linux systems – everyone working with Linux systems should be familiar with it or have at least heard of it.
iptables can be used to filter certain packets, block source or destination ports and IP addresses, forward packets via NAT and a lot of other things.
Most commonly it’s used to block destination ports and source IP addresses.

You’ll find that most if not all guides on how to block DDoS attacks using iptables use the filter table and the INPUT chain for anti-DDoS rules.
The issue with this approach is that the INPUT chain is only processed after the PREROUTING and FORWARD chains and therefore only applies if the packet doesn’t match any of these two chains.
This causes a delay in the filtering of the packet which consumes resources. In conclusion, to make our rules as effective as possible, we need to move our anti-DDoS rules as far up the chains as possible.

The first chain that can apply to a packet is the PREROUTING chain, so ideally we’ll want to filter the bad packets in this chain already.
However, the filter table doesn’t support the PREROUTING chain. To get around this problem, we can simply use the mangle table instead of the filter table for our anti-DDoS iptables rules.
It supports most if not all rules that the filter table supports while also supporting all iptables chains.
So you want to know why your iptables DDoS protection rules suck? It’s because you use the filter table and the INPUT chain to block the bad packets!

**Now we will create the script**
Step 1: Create a bash script with the name of iptables.sh
vi /root/iptables.sh

Step 2: Paste the above given script contents in your bash script file iptables.sh

Step 3: Make the Read Write Execute permission
chmod +x /root/iptables.sh

Step 4 : Now run the script
sh /root/iptables.sh

Step 5: Check the IPTABLES rule with following command
iptables -nL
iptables -t mangle -nL
