<h1 align="center">1337🇲🇦_Born2beroot-Tutorial 🖥🇬🇧 - 42 Kaneki</h1>
<p align="center">
  <a href="https://github.com/KanekiEzz/1337_Born2beroot_42">
    <img src="https://raw.githubusercontent.com/KanekiEzz/kaneki_badges/refs/heads/main/born2berootm.png" alt="42 Badge">
  </a>
</p>

# System Administration Scripts and Setup 🖥️⚙️

This repository contains various scripts and commands designed to automate and simplify system administration tasks. It includes scripts for monitoring, speed testing, configuring SSH, firewall (UFW), password policies, cron jobs, network management, and changing hostnames.

---

## 📑 Table of Contents

1. [Speedtest CLI](#speedtest-cli)
2. [UFW & SSH Configuration](#ufw--ssh-configuration)
3. [Password Policy Setup](#password-policy-setup)
4. [Cron Jobs](#cron-jobs)
5. [My Scripts](#my-scripts)
6. [Network Management](#network-management)
7. [Change Hostname](#change-hostname)

---

## 🌐 Speedtest CLI

To test your network speed via the command line, use the `speedtest-cli` tool. This tool allows you to run speed tests and view detailed results from different servers.

### 🔎 List Available Servers

To view a list of available servers for the speed test, use:
---

This will show a list of servers, sorted by distance, that you can choose to run the test against.

### ⚡ Run a Simple Speed Test

To run a basic speed test and get results, use:


This will output the following key results:

- **Ping**: The round-trip time for a network packet.
- **Download**: Download speed in Mbps.
- **Upload**: Upload speed in Mbps.

---

## 🔒 Sudo Setup
Log in as root:
```bash
$ su -
```

Install sudo:
```bash
# apt update
# apt upgrade
# apt install sudo
```

Add user to sudo group:
```bash
# adduser <username> sudo
```
Then ```exit``` root session and ```exit``` again to return to login prompt. Log in again as user.
Let's check if this user has sudo privileges:
```bash
$ getent group sudo
```
`reboot` for changes to take effect, then log in and verify *sudopowers* via `sudo -v`.
```
# reboot
<--->
Debian GNU/Linux 10 <hostname> tty1

<hostname> login: <username>
Password: <password>
<--->
$ sudo -v
[sudo] password for <username>: <password>
```
Edit sudoers.tmp file as root with the command:
```bash
# sudo visudo
```
And add these default settings as per subject instructions:
```bash
Defaults     passwd_tries=3
Defaults     badpass_message="Wrong password. Try again!"
Defaults     logfile="/var/log/sudo/sudo.log"
Defaults     log_input
Defaults     log_output
Defaults     requiretty
```
To set *sudo* paths to `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin`:
```
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```
If ```var/log/sudo``` directory does not exist, ```mkdir var/log/sudo```.

---

## 🔒 UFW & SSH Configuration

### 🔑 Change SSH Port

For better security, it's recommended to change the default SSH port. Follow these steps:

1. Edit the SSH configuration file:


2. After making changes, restart the SSH service:


### 🔍 Check SSH Service Status

To check if the SSH service is running:


### 🛡️ UFW Firewall Configuration

#### 🔧 Check UFW Status

To check if UFW (Uncomplicated Firewall) is active:


#### 🔓 View Allowed Ports in UFW

To see which ports are allowed through the firewall:


#### 🚪 Allow a Specific Port (e.g., port 4242)

To allow a specific port through the firewall (e.g., port 4242):


#### 📝 List All Numbered Rules in UFW

To list all allowed ports with their rule numbers:


#### ❌ Remove a Port Rule

To remove a specific port rule from UFW, use the rule number displayed by the previous command:


Replace `<number>` with the rule number you wish to delete.

## UFW Setup
Install and enable UFW:
```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install ufw
$ sudo ufw enable
```

Check UFW status:
```bash
$ sudo ufw status verbose
```

Allow or deny ports:
```bash
$ sudo ufw allow <port>
$ sudo ufw deny <port>
```

Remove port rule:
```bash
$ sudo ufw delete allow <port>
$ sudo ufw delete deny <port>
```
Or, another method for rule deletion:
```bash
$ sudo ufw status numbered
$ sudo ufw delete <port index number>
```
Careful with the numbered method, the index numbers change after a deletion, check between deletes to get the correct port index number!

## SSH Setup
Install OpenSSH:
```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install openssh-server
```

Check SSH status:
```bash
$ sudo systemctl status ssh
```

Change SSH listening port to 4242:
```bash
$ sudo nano /etc/ssh/sshd_config
```
Find this line:
```bash
#Port 22
```
And uncomment (delete #) and change it to 4242:
```bash
Port 4242
```

Restart SSH service
```bash
$ sudo systemctl restart ssh
```
Don't forget to add a UFW rule to allow port 4242!

Forward the host port 4242 to the guest port 4242: in VirtualBox, 
* go to VM >> Settings >> Network >> Adapter 1 >> Advanced >> Port Forwarding.
* add a rule: Host port 4242 and guest port 4242.

Restart SSH service after this change.

In the host terminal, connect like this:
```bash
$ ssh <username>@localhost -p 4242
```
Or like this:
```bash
$ ssh <username>@127.0.0.1 -p 4242
```
To quit the ssh connection, just ```exit```.


---

## 🔐 Password Policy Setup

Setting up a strong password policy is crucial for system security.

### 🛠️ Configure Password Policy

To configure strong password policies (e.g., minimum length, complexity), edit the `/etc/login.defs` file:


### 🕒 Check Password Expiration for a User

To check the password expiration for a specific user:


Replace `<username>` with the target username.

### 📝 Edit Password Rules in PAM

To enforce stronger password rules, edit the `/etc/pam.d/common-password` file:


### 🛡️ Check Sudoers File for Secure Usage

To review and configure sudo access, check the sudoers file:


## Password Policy
Edit ```/etc/login.defs``` and find "password aging controls". Modify them as per subject instructions:
```bash
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
```
These changes aren't automatically applied to existing users, so use chage command to modify for any users and for root:
```bash
$ sudo chage -M 30 <username/root>
$ sudo chage -m 2 <username/root>
$ sudo chage -W 7 <username/root>
```
Use ```chage -l <username/root>``` to check user settings.

Install password quality verification library:
```bash
$ sudo apt install libpam-pwquality
```

Then, edit the ```/etc/security/pwquality.conf``` file like so:
``` bash
# Number of characters in the new password that must not be present in the 
# old password.
difok = 7
# The minimum acceptable size for the new password (plus one if 
# credits are not disabled which is the default)
minlen = 10
# The maximum credit for having digits in the new password. If less than 0 
# it is the minimun number of digits in the new password.
dcredit = -1
# The maximum credit for having uppercase characters in the new password. 
# If less than 0 it is the minimun number of uppercase characters in the new 
# password.
ucredit = -1
# ...
# The maximum number of allowed consecutive same characters in the new password.
# The check is disabled if the value is 0.
maxrepeat = 3
# ...
# Whether to check it it contains the user name in some form.
# The check is disabled if the value is 0.
usercheck = 1
# ...
# Prompt user at most N times before returning with error. The default is 1.
retry = 3
# Enforces pwquality checks on the root user password.
# Enabled if the option is present.
enforce_for_root
# ...
```
Change user passwords to comply with password policy:
```bash
$ sudo passwd <user/root>
```


---

## ⏰ Cron Jobs

Cron jobs are used to schedule tasks to run at specific intervals.

### 🔍 Cron Service Status

To check if the cron service is running:


### ▶️ Start/Stop the Cron Service

To start or stop the cron service:


### ✍️ Edit Cron Jobs for the Root User

To edit the cron jobs for the root user:


### ⏳ Example Cron Job

For example, to run `monitoring.sh` and `sleep.sh` every 10 minutes:


---

## 🛠️ My Scripts

These scripts are located in `/usr/local/bin/` and include:

- **monitoring.sh**: Monitors system performance.
- **sleep.sh**: Controls system sleep behavior.
- **speedtest_with_art.sh**: Runs a speed test and logs the results.

## Monitoring.sh
Write [```monitoring.sh```](https://github.com/KanekiEzz/1337_Born2beroot_42/blob/main/monitoring.sh) file as root and put it in /root directory.

Check the following commands to figure out how to write the script:
* ```uname``` : architecture information
* ```/proc/cpuinfo``` : CPU information
* ```free``` : RAM information
* ```df``` : disk information
* ```top -bn1``` : process information
* ```who``` : boot and connected user information
* ```lsblk``` : partition and LVM information
* ```/proc/net/sockstat``` : TCP information
* ```hostname``` : hostname and IP information
* ```ip link show``` / ```ip address``` : IP and MAC information

Remember to give the script execution permissions, i.e.:
```bash
chmod 755 monitoring.sh
```

The ```wall``` command allows us to broadcast a message to all users in all terminals. This can be incorporated into the monitoring.sh script or added later in cron.

To schedule the broadcast every 10 minutes, we need to enable cron:
```bash
# systemctl enable cron
```
Then start a crontab file for root:
```bash
# crontab -e
```
And add the job like this:
```bash
*/10 * * * * bash /root/monitoring.sh
```
Or, if the wall command isn't incorporated into the monitoring script:
```bash
*/10 * * * * bash /root/monitoring.sh | wall
```
From here, ```monitoring.sh``` will be executed every 10th minute. To make it execute every ten minutes **from system startup**, we can create a [```sleep.sh```](https://github.com/KanekiEzz/1337_Born2beroot_42/blob/main/sleep.sh) script that calculates the delay between server startup time and the tenth minute of the hour, then add it to the cron job to apply the delay.
```bash
*/10 * * * * bash /root/sleep.sh && bash /root/monitoring.sh
```

---

## 🌐 Network Management

To manage your network interfaces, use the following commands:

### ⚙️ Manage Network Services

Start, stop, or restart `NetworkManager`:


Check the status of `NetworkManager`:


### 📶 List Available Wi-Fi Networks

To list available Wi-Fi networks:


---

## 🏷️ Change Hostname

To change your system's hostname, follow these steps:

### Set a New Hostname


Replace `<new_hostname>` with the desired hostname.

### 👥 Check the Current Hostname
## 👥 Hostname, Users and Groups
The hostname must be ```your_intra_login42```, but the hostname must be changed during the Born2beroot evaluation. The following commands might help:
```bash
$ sudo hostnamectl set-hostname <new_hostname>
$ hostnamectl status
```

There must be a user with ```your_intra_login``` as username. During evaluation, you will be asked to create, delete, modify user accounts. The following commands are useful to know:
* ```useradd``` : creates a new user.
* ```usermod``` : changes the user’s parameters: ```-l``` for the username, ```-c``` for the full name, ```-g``` for groups by group ID.
* ```userdel -r``` : deletes a user and all associated files.
* ```id -u``` : displays user ID.
* ```users``` : shows a list of all currently logged in users.
* ```cat /etc/passwd | cut -d ":" -f 1``` : displays a list of all users on the machine.
* ```cat /etc/passwd | awk -F '{print $1}'``` : same as above.

The user named your_intra_login must be part of the ```sudo``` and ```user42``` groups. You must also be able to manipulate user groups during evaluation with the following commands:
* ```groupadd``` : creates a new group.
* ```gpasswd -a``` : adds a user to a group.
* ```gpasswd -d``` : removes a user from a group.
* ```groupdel``` : deletes a group.
* ```groups``` : displays the groups of a user.
* ```id -g``` : shows a user’s main group ID.
* ```getent group``` : displays a list of all users in a group.



---     
## Failed to send host log message
The error message that appears at VM boot, "[drm:vmw_host_log [vmwgfx]] *ERROR* Failed to send host log message" can easily be fixed. It is a graphics controller error. All we have to do is:
* Shut down VM
* In VirtualBox, go to VM settings
* ```Display``` >> ```Screen``` >> ```Graphics Controller``` >> Choose ```VBoxVGA```.

## Signature.txt
To extract the VM's signature for the correction, go to the Virtual Box VMs folder in your local computer:
* Windows: ```%HOMEDRIVE%%HOMEPATH%\VirtualBox VMs\```
* Linux: ```~/VirtualBox VMs/```
* MacM1: ```~/Library/Containers/com.utmapp.UTM/Data/Documents/```
* MacOS: ```~/VirtualBox VMs/```

Then use the following command (replace ```centos_serv``` with your machine name):
* Windows: ```certUtil -hashfile centos_serv.vdi sha1```
* Linux: ```sha1sum centos_serv.vdi```
* For Mac M1: ```shasum Centos.utm/Images/disk-0.qcow2```
* MacOS: ```shasum centos_serv.vdi```

And save the signature to a file named ```signature.txt```.

---

<h1 align="center">Born2beroot Bonuses</h1>
 

For the Born2beroot bonuses, we have to install WordPress with Lighttpd, MariaDB and PHP. We also have to install another service of our own choice, and justify that choice.

## 🌐  Installing WordPress(Bonus)

### 📦  Installing PHP

To get the latest version of PHP (8.1 at the time of this writing), we need to add a different APT repository, Sury's repository.

```bash
$ sudo apt update
$ sudo apt install curl
$ sudo curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
$ sudo apt update 
```

Install PHP version 8.1:
```bash
$ sudo apt install php8.1
$ sudo apt install php-common php-cgi php-cli php-mysql
```

Check php version:
```bash
$ php -v
```

### 🚀 Installing Lighttpd

Apache may be installed due to PHP dependencies. Uninstall it if it is to avoid conflicts with lighttpd:

```bash
$ systemctl status apache2
$ sudo apt purge apache2
```

Install lighttpd:

```bash
$ sudo apt install lighttpd
```

Chack version, start, enable lighttpd and check status:

```bash
$ sudo lighttpd -v
$ sudo systemctl start lighttpd
$ sudo systemctl enable lighttpd
$ sudo systemctl status lighttpd
```

Next, allow http port (port 80) through UFW:
```bash
$ sudo ufw allow http
$ sudo ufw status
```

And forward host port 8080 to guest port 80 in VirtualBox:

* Go to VM >> ```Settings``` >> ```Network``` >> ```Adapter 1``` >> ```Port Forwarding```
* Add rule for host port ```8080``` to forward to guest port ```80```

To test Lighttpd, go to host machine browser and type in address ```http://127.0.0.1:8080``` or ```http://localhost:8080```. You should see a Lighttpd "placeholder page".

Back in VM, activate lighttpd FastCGI module:
```bash
$ sudo lighty-enable-mod fastcgi
$ sudo lighty-enable-mod fastcgi-php
$ sudo service lighttpd force-reload
```

To test php is working with lighttpd, create a file in ```/var/www/html``` named ```info.php```. In that php file, write:
```php
<?php
phpinfo();
?>
```

Save and go to host browser and type in the address ```http://127.0.0.1:8080/info.php```. You should get a page with PHP information.

### 🗄️  Installing MariaDB

Install MariaDB:
```bash
$ sudo apt install mariadb-server
```

Start, enable and check MariaDB status:
```bash
$ sudo systemctl start mariadb
$ sudo systemctl enable mariadb
$ systemctl status mariadb
```

Then do the MySQL secure installation:
```bash
$ sudo mysql_secure_installation
```

Answer the questions like so (root here does not mean root user of VM, it's the root user of the databases!):
```
Enter current password for root (enter for none): <Enter>
Switch to unix_socket authentication [Y/n]: Y
Set root password? [Y/n]: Y
New password: 101Asterix!
Re-enter new password: 101Asterix!
Remove anonymous users? [Y/n]: Y
Disallow root login remotely? [Y/n]: Y
Remove test database and access to it? [Y/n]:  Y
Reload privilege tables now? [Y/n]:  Y
```

Restart MariaDB service:
```bash
$ sudo systemctl restart mariadb
```

Enter MariaDB interface:
```bash
$ mysql -u root -p
```

Enter MariaDB root password, then create a database for WordPress:
```mysql
MariaDB [(none)]> CREATE DATABASE wordpress_db;
MariaDB [(none)]> CREATE USER 'admin'@'localhost' IDENTIFIED BY 'WPpassw0rd';
MariaDB [(none)]> GRANT ALL ON wordpress_db.* TO 'admin'@'localhost' IDENTIFIED BY 'WPpassw0rd' WITH GRANT OPTION;
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> EXIT;
```

Check that the database was created successfully, go back into MariaDB interface:
```bash
$ mysql -u root -p
```

And show databases:
```mysql
MariaDB [(none)]> show databases;
```

You should see something like this:
```
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| wordpress_db       |
+--------------------+
```
If the database is there, everything's good!

### 🎯 Installing WordPress

We need to install two tools:
```bash
$ sudo apt install wget
$ sudo apt install tar
```

Then download the latest version of Wordpress, extract it and place the contents in ```/var/www/html/``` directory. Then clean up archive and extraction directory:
```bash
$ wget http://wordpress.org/latest.tar.gz
$ tar -xzvf latest.tar.gz
$ sudo mv wordpress/* /var/www/html/
$ rm -rf latest.tar.gz wordpress/
```

Create WordPress configuration file:
```bash
$ sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```

Edit ```/var/www/html/wordpress/wp-config.php``` with database info:
```php
<?php
/* ... */
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress_db' );

/** Database username */
define( 'DB_USER', 'admin' );

/** Database password */
define( 'DB_PASSWORD', 'WPpassw0rd' );

/** Database host */
define( 'DB_HOST', 'localhost' );
```

Change permissions of WordPress directory to grant rights to web server and restart lighttpd:
```bash
$ sudo chown -R www-data:www-data /var/www/html/
$ sudo chmod -R 755 /var/www/html/
$ sudo systemctl restart lighttpd
```

In host browser, connect to ```http://127.0.0.1:8080``` and finish WordPress installation.















---
# 👨‍💻 Author ✍🏼

<table>
  <tr>
    <td align="center"><a href="https://github.com/KanekiEzz/"><img src="https://avatars.githubusercontent.com/u/110631781?s=400&u=0cd1de60c073f367d291df9c6ccef5c18ac64e41&v=4" width="100px;" alt="100px"/><br /><sub><b>iezzam</b></sub></a><br /><a href="https://profile.intra.42.fr/users/iezzam" title="Intra 42">iezzam42</a></td>
  </tr>
</table>


# 🔍 You might be interested!

### 📚  - To see my progress in the common core 42 ↙️

[HERE](https://github.com/KanekiEzz/42cursus)

### 👤 - My profile on the intra 42 ↙️

[HERE](https://profile.intra.42.fr/users/iezzam)
