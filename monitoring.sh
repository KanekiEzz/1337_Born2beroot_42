#!/bin/bash


# ARCH
arc=$(uname -a)

# CPU PHYSICAL
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# CPU VIRTUCAL
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# DISK
fdisk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

# CPU LOAD
cpul=$(top -bn1 | grep '%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

# LAST BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

# TCP CONTEXIONS
ctcp=$(ss -Ht | wc -l)

# USER LOG
ulog=$(users | tr ' ' '\n' | uniq | wc -w)

# NETWORK
ip=$(hostname -I)
mac=$(ip link show | grep "ether" | awk '{print $2}')

# SUDO
cmds=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)

wall "	#Architecture: $arc
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $uram/${fram}MB ($pram%)
	#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
	#CPU load: $cpul
	#Last boot: $lb
	#LVM use: $lvmu
	#Connections TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd"
