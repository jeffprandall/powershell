# Install 3 Ranchers on FreeNAS

A small cluster of three RancherOS servers.

- rancher (192.168.2.200) will act as our main rancher server
- rancher-host1 (192.168.2.201) will act as a rancher host
- rancher-host2 (192.168.2.202) will act as a rancher host

## Setting up RancherOS

### Enable iohyve on FreeNAS
Iohyve is already installed in FreeNAS 9.10, so it only needs to be enabled. This is done by adding the following lines to `/conf/base/etc/rc.conf`:

	iohyve_enable="YES"
	iohyve_flags="kmod=1 net=igb0 pool=storage-volume"
The first line enables iohyve generally, while the second line provides some configuration. Specifically, it specifies that iohyve should load the required kernel modules itself, use igb0 as bridge interface for all VMs and use the zpool storage-volume for vm storage.

This change only becomes active after a reboot. Alternatively, `iohyve setup` can be run manually.

### Rancher Manager

On FreeNAS

    iohyve create rancher 32G
    iohyve set rancher loader=grub-bhyve ram=2G cpu=2 con=nmdm0 os=debian
    iohyve install rancher rancheros-v1.1.0.iso

Open new terminal

    iohyve console rancher

At the grub> terminal

    set root=(cd0,msdos1)
    linux /boot/vmlinuz* ro rancher.password=rancher
    initrd /boot/initrd*
    boot

Login with rancher/rancher

Generate an SSH key
    
    ssh-keygen

Copy the contents of `~/.ssh/id_rsa.pub` and paste into the `cloud-config.yml` file ssh section below

Create a `cloud-config.yml` file
    
    #cloud-config
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjMZDfE2eM9NKgHvOvJXWrvbiiLH275O82dVpHDwM4ZYRw/xMvJQP5GRrKbkVpFvmPrzx0RtkYsEmEly+gttExduFuNpBTuwy3fIlaZw9Z2SoJi2yxl0AveoJnLH4pSjNKJVdOxIKEfyO8XFD4fQmC4NQJnIDakEaR5DhOUe0Zetz42hGfVXsybqGr7OlgT5pOa7jsnTuhbXNzWbSm5edLavXlozIPVh/ktKsCq4+iq0X3beL5IyrkxDTSE4aVRHcq1nJqXy0uZrB1IYJofBvGTb6vJTYq83y3Zal0L7pflRYnmxf4O1rV5A+ohIPFqyOALXgSsoSfunK5mPm1MhKN rancher@rancher

	hostname: rancher    
    #/var/lib/rancher/conf/cloud-config.d/netconfig-config.yml
    rancher:
      network:
        interfaces:
          eth0:
            addresses:
              - 192.168.2.200/24
            gateway: 192.168.2.1
            dhcp: false
        dns:
          nameservers:
            - 8.8.8.8
            - 8.8.4.4

Validate the conf file and then install - should show no errors

    sudo ros config validate -i cloud-config.yml
    sudo ros install -c cloud-config.yml -d /dev/sda

Back on FreeNAS create `/mnt/iohyve/rancher/grub.cfg`.  Set your password here.
    
     set root=(hd0,1)
     linux /boot/vmlinuz* printk.devkmsg=on rancher.state.dev=LABEL=RANCHER_STATE rancher.state.wait console=tty0 ro rancher.password=SecretPassword
     initrd /boot/initrd*
     boot

Apply those new settings to rancher

    iohyve set rancher os=custom
    iohyve set rancher boot=1

### Rancher Host 1

On FreeNAS

    iohyve create rancher-host1 32G
    iohyve set rancher-host1 loader=grub-bhyve ram=2G cpu=2 con=nmdm1 os=debian
    iohyve install rancher-host1 rancheros-v1.1.0.iso

Open new terminal

    iohyve console rancher-host1

At the grub> terminal

    set root=(cd0,msdos1)
    linux /boot/vmlinuz* ro rancher.password=rancher
    initrd /boot/initrd*
    boot

Login with rancher/rancher

Generate an SSH key
    
    ssh-keygen

Copy the contents of `~/.ssh/id_rsa.pub` and paste into the `cloud-config.yml` file ssh section below

Create a `cloud-config.yml` file
    
    #cloud-config
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+6lBwms1+ctiKSCqeQtIhH+ZQFQPcC88/VgnUgmAamighFXuX+jTMrxnvtPQPKky//ROGHozVhByBvqpsuCq7Uk1P9yBWdbYxez4ij8yn7YkAHvdEy8jvlFMAwThZJbEq5dbAlL139RHwQUCDY/FZky1k9WjltIiQj0+swOgm0OMs+1c4UWajYs3cz/Xn3uEVIsJ8b1PEFb1Ta+WfewqpHuZONSvRf4MHUvk7wQN9l3hU4RnbRnfhf7yzYhNd7hIEcPFv+hypMW+WAJar3Qam8PCf2oDxfkEyaCbaWyynuVdqaq59aUjyhoGZOlC0b26aOLFScpMeQN3Y1dLTGdUL rancher@rancher

    hostname: rancher-host1

    #/var/lib/rancher/conf/cloud-config.d/netconfig-config.yml
    rancher:
      network:
        interfaces:
          eth0:
            addresses:
              - 192.168.2.201/24
            gateway: 192.168.2.1
            dhcp: false
        dns:
          nameservers:
            - 8.8.8.8
            - 8.8.4.4

Validate the conf file and then install - should show no errors

    sudo ros config validate -i cloud-config.yml
    sudo ros install -c cloud-config.yml -d /dev/sda

Back on FreeNAS create `/mnt/iohyve/rancher-host1/grub.cfg`.  Set your password here.
    
     set root=(hd0,1)
     linux /boot/vmlinuz* printk.devkmsg=on rancher.state.dev=LABEL=RANCHER_STATE rancher.state.wait console=tty0 ro rancher.password=SecretPassword
     initrd /boot/initrd*
     boot

Apply those new settings to rancher-host1

    iohyve set rancher-host1 os=custom
    iohyve set rancher-host1 boot=1

### Rancher Host 2

On FreeNAS

    iohyve create rancher-host2 32G
    iohyve set rancher-host2 loader=grub-bhyve ram=2G cpu=2 con=nmdm2 os=debian
    iohyve install rancher-host2 rancheros-v1.1.0.iso

Open new terminal

    iohyve console rancher-host2

At the grub> terminal

    set root=(cd0,msdos1)
    linux /boot/vmlinuz* ro rancher.password=rancher
    initrd /boot/initrd*
    boot

Login with rancher/rancher

Generate an SSH key
    
    ssh-keygen

Copy the contents of `~/.ssh/id_rsa.pub` and paste into the `cloud-config.yml` file ssh section below

Create a `cloud-config.yml` file
    
    #cloud-config
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjMZDfE2eM9NKgHvOvJXWrvbiiLH275O82dVpHDwM4ZYRw/xMvJQP5GRrKbkVpFvmPrzx0RtkYsEmEly+gttExduFuNpBTuwy3fIlaZw9Z2SoJi2yxl0AveoJnLH4pSjNKJVdOxIKEfyO8XFD4fQmC4NQJnIDakEaR5DhOUe0Zetz42hGfVXsybqGr7OlgT5pOa7jsnTuhbXNzWbSm5edLavXlozIPVh/ktKsCq4+iq0X3beL5IyrkxDTSE4aVRHcq1nJqXy0uZrB1IYJofBvGTb6vJTYq83y3Zal0L7pflRYnmxf4O1rV5A+ohIPFqyOALXgSsoSfunK5mPm1MhKN rancher@rancher
 
	hostname: rancher-host2

    #/var/lib/rancher/conf/cloud-config.d/netconfig-config.yml
    rancher:
      network:
        interfaces:
          eth0:
            addresses:
              - 192.168.2.202/24
            gateway: 192.168.2.1
            dhcp: false
        dns:
          nameservers:
            - 8.8.8.8
            - 8.8.4.4

Validate the conf file and then install - should show no errors

    sudo ros config validate -i cloud-config.yml
    sudo ros install -c cloud-config.yml -d /dev/sda

Back on FreeNAS create `/mnt/iohyve/rancher-host2/grub.cfg`.  Set your password here.
    
     set root=(hd0,1)
     linux /boot/vmlinuz* printk.devkmsg=on rancher.state.dev=LABEL=RANCHER_STATE rancher.state.wait console=tty0 ro rancher.password=SecretPassword
     initrd /boot/initrd*
     boot

Apply those new settings to rancher-host2

    iohyve set rancher-host2 os=custom
    iohyve set rancher-host2 boot=1

### Turn on all the Ranchers
    iohyve start rancher
	iohyve start rancher-host1
	iohyve start rancher-host2

## Setting up Rancher
SSH into rancher which will be our main rancher server

`ssh rancher@192.168.2.200`

Install the Rancher Docker container

`sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server`

Open up a browser and navigate to `http://192.168.2.200:8080` to verify the site is up.

Navigate to the INFRASTRUCTURE > HOSTS page

Click Add Host
 


##### Reference Documentation
[A practical guide to containers on FreeNAS for a depraved psychopath.](https://medium.com/@andoriyu/a-practical-guide-to-containers-on-freenas-for-a-depraved-psychopath-c212203c0394)
