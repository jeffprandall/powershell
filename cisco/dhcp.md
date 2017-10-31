##### Create a pool of ip addresses

    ip dhcp pool 51-dhcp 
      network 172.16.51.0 255.255.255.0  
      domain-name remotedomain.com  
      dns-server <internal dns server> <external dns server>  
      default-router <default router ip> 


##### Assign static IP to a MAC Address

    ip dhcp pool <hostname>
      host 172.16.51.29 255.255.255.0
      client-identifier <client mac address in this format aaaa.bbbb.cccc>

##### Show all dhcp leases
    show ip dhcp binding

#### Clear dhcp bindings
    clear ip dhcp bindings
