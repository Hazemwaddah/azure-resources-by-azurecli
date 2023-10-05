###################################### Capture traffic using TCPdump

# Change the default Linux distribution installed
wsl --install -d kali-linux

# To see a list of available Linux distributions available for download
wsl --list --online
wsl -l -o


tcpdump -X -n -s 0

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart


root@kali:~# tcpdump -X -n -s 0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
21:46:19.321394 ARP, Request who-has 192.168.1.6 tell 192.168.1.1, length 28
        0x0000:  0001 0800 0604 0001 0015 5d01 0601 c0a8  ..........].....
        0x0010:  0101 0000 0000 0000 c0a8 0106            ............
21:46:25.014043 IP 192.168.1.6.17500 > 255.255.255.255.17500: UDP, length 132
        0x0000:  4500 00a0 19a6 0000 8011 5ef9 c0a8 0106  E.........^.....
        0x0010:  ffff ffff 445c 445c 008c fd00 7b22 686f  ....D\D\....{"ho"
#

# Change the default Linux distribution installed
wsl --install -d kali-linux

# To see a list of available Linux distributions available for download
wsl --list --online
wsl -l -o


tcpdump -X -n -s 0

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart








