##### Enable SSH into a Jail - https://doc.freenas.org/9.3/freenas_jails.html
    echo "sshd_enable="YES"" >> /etc/rc.conf
    service sshd start
    adduser (make sure add to group wheel if needs to be admin)
#### Update Jails
    portsnap fetch
    portsnap extract
    portsnap update
#### Install Nano 
    pkg install nano
