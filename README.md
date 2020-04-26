# athena-discover-live-assets
Project contains scripts to discover Live Hosts/Assets

## Scripts

### `discover_resolvable_hosts.sh`

```
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
```


### `discover_live_hosts.sh`

```
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
```
