#!/bin/bash
# Script takes a list of hosts (IPs/domains) as input and then determines using the 'host' command 
# whether or not it is resolvable. If an IP address is provided, it is output as-is. If a domain 
# name is provided, then it is checked to see if it is resolvable.
# 
# Input: 
#     List of hosts (one-per-line) which can be IP or domain name
# 
# Examples
#     To resolve a list of hosts from a file hosts.txt:
#         cat hosts.txt | ./discover_resolvable_hosts.sh
# 
#     To check if www.google.com, www.msn.com are resolvable:
#         echo -e "www.google.com\nwww.msn.com\n" | ./discover_resolvable_hosts.sh
#  
#     To perform resolution on domains in a file, hosts.txt, in-parallel:
#         cat hosts.txt | parallel --will-cite --pipe -n1 ./discover_resolvable_hosts.sh
#

# Constants

# Regex for determining if value provided is IP
IP_REGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"

# Regex to determine if value provided is a domain
DOMAIN_REGEX="^([a-zA-Z0-9\_\-]+\.)+[a-zA-Z0-9\_\-]{1,6}$"

function is_host_ip {
    # Function prints the IP address out if hostname is an IP address
    # 
    # Arguments:
    #     host: Host name to check if it is an IP e.g. 1.1.1.1
    #
    # Output:
    #     IP address, if it turns out that the host is an IP address
    # 
    # Examples:
    #     is_host_ip "1.1.1.1" ~> Prints "1.1.1.1"
    # 
    local host="$1"

    # Check via regex search if host is an IP
    local is_host_ip_flag=$(echo "$host" | grep -Ei "$IP_REGEX")

    # Print the hostname in response if it turns out that the host is an IP
    if [ ! -z "$is_host_ip_flag" ]; then
        echo "$host"
    fi
}

function is_host_domain {
    # Function prints the host if it is a domain. Note that if an IP provided,
    # then it is not printed since it is NOT a domain name
    # 
    # Arguments
    #     host: Host name to check if it is a domain e.g. www.google.com
    # 
    # Output:
    #     hostname/domain name, if it turns out that host is a domain name
    # 
    # Example: 
    #     is_host_domain "1.1.1.1" ~> Prints nothing
    #     is_host_domain "www.google.com" ~> Prints www.google.com
    #     
    local host="$1"

    # First check if the host is an IP
    local is_host_ip_flag=$(is_host_ip "$host")

    # If it is an IP, then don't print anything - it is not a domain!
    # Otherwise, continue search for a domain name
    if [ -z "$is_host_ip_flag" ]; then

        # Check via regex search if host is a domain
        local is_host_domain_flag=$(echo "$host" | grep -Ei "$DOMAIN_REGEX")
    
        # If regex search returns a value, then a domain - just print it out.
        if [ ! -z "$is_host_domain_flag" ]; then
            echo "$host"
        fi
        
    fi
}

# Get the list of hosts to resolve from user
hosts_list="$(cat -)"

# Loop through each host
for host in $hosts_list; do

    # Check if host is an IP
    is_host_ip_flag=$(is_host_ip "$host")
    if [ ! -z "$is_host_ip_flag" ]; then
        # Print out the host as it is an IP
        echo "$host"
    fi

    # Check if host is a domain
    is_host_domain_flag=$(is_host_domain "$host")
    if [ ! -z "$is_host_domain_flag" ]; then

        # If host, then check if it is resolvable, and check the DNS value for host
        is_host_resolvable=$(host -t a "$host" | grep -Ei "has address|has IPv6 address")

        # Since host is resolvable, print it out
        if [ ! -z "$is_host_resolvable" ]; then
            echo "$host"
        fi
    fi
done


