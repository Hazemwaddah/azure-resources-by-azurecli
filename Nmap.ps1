
########################################### Do port scan using Nmap
nmap 
nmap -v scanme.nmap.org
nmap -v -A scanme.nmap.org


nmap -v scanme.nmap.org
nmap -v -A mycompany.org
nmap -v -A 40.118.40.109
nmap -A -v -Pn 20.218.83.190

# This option scans all reserved TCP ports on the machine
# scanme.nmap.org . The -v option enables verbose mode.

nmap -sS -O scanme.nmap.org/24

# Launches a stealth SYN scan against each machine that is up out of   
# the 256 IPs on the /24 sized network where Scanme resides. It also   
# tries to determine what operating system is running on each host     
# that is up and running. This requires root privileges because of     
# the SYN scan and OS detection.

nmap -sV -p 22,53,110,143,4564 198.116.0-255.1-127

# Launches host enumeration and a TCP scan at the first half of each   
# of the 255 possible eight-bit subnets in the 198.116.0.0/16 address  
# space. This tests whether the systems run SSH, DNS, POP3, or IMAP    
# on their standard ports, or anything on port 4564. For any of these  
# ports found open, version detection is used to determine what        
# application is running.

nmap -v -iR 100000 -Pn -p 80

# Asks Nmap to choose 100,000 hosts at random and scan them for web    
# servers (port 80). Host enumeration is disabled with -Pn since       
# first sending a couple probes to determine whether a host is up is   
# wasteful when you are only probing one port on each target host      
# anyway.

nmap -Pn -p80 -oX logs/pb-port80scan.xml -oG
logs/pb-port80scan.gnmap 216.163.128.20/20

# This scans 4096 IPs for any web servers (without pinging them) and   
# saves the output in grepable and XML formats.



