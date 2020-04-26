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
