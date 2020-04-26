#!/bin/bash
# Script takes a list of hosts (IPs/domains) as input and then determines using either 'ping' or 
# 'nmap' command to determine whether or not it is live. To run the nmap scan, 'sudo' access is 
# needed.
# 
# 
# This script has been tested on both Mac/Linux
#
# Usage:
#     cat [hosts-list] | ./discover_live_hosts.sh [method='nmap'|'ping'] \
#                                                 [ports='top'|'common'|'all'|22,80,443]
# 
# Input: 
#     List of hosts (one-per-line) which can be IP or domain name, to determine if it is live or 
#     not
#
# Arguments:
#     method: Method to use for scanning which can be 'ping' or 'nmap'. With 'nmap' only TCP port 
#             scan performed
#     ports:  Ports to use for live scanning if method is chosen which is 'nmap' eg. 'common' for 
#             top-1000 ports of Nmap, 'top' ports for the most common ports open (around 20), or
#             'all' for ALL TCP ports
#             
# Examples
#     To determine if a list of hosts from a file hosts.txt are live or not with nmap with around 
#     20 ports:
#         cat hosts.txt | ./discover_live_hosts.sh
# 
#     To check if www.google.com, www.msn.com are live with common nmap ports:
#         echo -e "www.google.com\nwww.msn.com\n" | ./discover_live_hosts.sh 'nmap' 'common'
#  
#     To check if hosts in this file, hosts.txt, are live via 'ping' in parallel:
#         cat hosts.txt | parallel --will-cite --pipe -n1 ./discover_live_hosts.sh 'ping'
#

# Constants 

# Amount of timeout for ping. In Mac, milliseconds is used for timeout, whereas seconds for linux.
PING_LINUX_TIMEOUT=2
PING_MAC_TIMEOUT=2000
# Number of tries
PING_TRIES=2
# Nmap ports to scan
NMAP_TOP_PORTS="22,25,53,80,110,139,143,389,443,445,636,1433,1434,3306,3389,8000,8080,8443,9080,9443"

# Get the list of hosts to resolve from user
hosts_list="$(cat -)"

# Get the user arguments
method=${1:-"nmap"}
ports=${2:-"top"}

# Determine the OS in use
os="$(uname)"

# Loop through each host
for host in $hosts_list; do
    if [ "$method" == "ping" ]; then

        # Run a ping test to see if the host is alive
        if [ "$os" == "Darwin" ]; then
            ping_test=$(ping -c "$PING_TRIES" -W "$PING_MAC_TIMEOUT" "$host")
        else
            ping_test=$(ping -c "$PING_TRIES" -w "$PING_LINUX_TIMEOUT" "$host")
        fi
        

        # Check if host is alive
        is_host_alive=$(echo "$ping_test" | grep -i "64 bytes from")
        if [ ! -z "$is_host_alive" ]; then
            echo "$host"
        fi
    
    else
        # Determine the ports 
        if [ "$ports" == "common" ]; then
            ports_to_scan_arg="--top-ports 1000"
        elif [ "$ports" == "top" ]; then
            ports_to_scan_arg="-p $NMAP_TOP_PORTS"
        elif [ "$ports" == "all" ]; then
            ports_to_scan_arg="-p-"
        else
            # Just take the ports that user provides as comma-separated
            ports_to_scan_arg="-p $ports"
        fi
        
        # Run the nmap scan now
        nmap_scan=$(nmap -Pn -sS --open "$ports_to_scan_arg" "$host")

        # Check if host is alive
        is_host_alive=$(echo "$nmap_scan" | grep -Ei "/tcp.*open")
        if [ ! -z "$is_host_alive" ]; then
            echo "$host"
        fi
    fi
done
