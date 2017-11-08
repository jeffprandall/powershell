 Configuration options for HP MSR1000 FlexNet Series Routers
 
 
    system-view
    
    # Create User Account
    local-user admin
      password hash simple SuperPa$$w0rd
      service-type web
      service-type ssh level 3
      authorization-attribute level 3 

    # Enable HTTP Web Interface
    ip http enable 

    # Enable SSH
    public-key local create rsa
      public-key local create dsa
      ssh server enable

    # Set the authentication mode
    user-interface vty 0 4
      authentication-mode scheme
      protocol inbound ssh

    # Name the device
    sysname hp-router-device

    # Create a DHCP Scope
    dhcp server ip-pool default extended
      network ip range <start range> <end range>
      network mask <subnet mask>
      gateway-list <default gateway>
      dns-list <dns1> <dns2>
    dhcp enable

    # Assign DHCP to an Interface
    interface Vlan1
      dhcp server apply ip-pool default

    # Assign Static IP address to an Interface
    interface GigabitEthernet0/2
      ip address <ip address> <external subnet>
      dns server <dns1>
      dns server <dns2>
      description <anything here>

    # Assign NAT to an External Interface
    interface GigabitEthernet0/1
      nat outbound
      ip address <ip address> <external subnet>
      dns server <dns1>
      dns server <dns2>

     # Configure Static Route/Last Resort
    ip route-static 0.0.0.0 0.0.0.0 <external interface> <gateway ip address>

    # SNMP
    snmp-agent
    snmp-agent community read <community name>
    snmp-agent sys-info version v2c
