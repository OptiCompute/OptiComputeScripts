#!/bin/bash
##Define variables
WAN_INT="enX0"
LAN_INT="enX1"
WN_LAN_INT="enX0"

sudo dnf -y install firewalld
systemctl enable firewalld --now
systemctl restart NetworkManager

#Modify the connections of the interface(s) to reflect the correct zones:
nmcli con mod $WAN_INT connection.zone external
nmcli con mod $LAN_INT connection.zone internal

#Bring the connections up with the modified zones
nmcli con up $WAN_INT
nmcli con up $LAN_INT

#Add the firewall rules to allow NAT through the public interface
firewall-cmd --permanent --new-policy policy_int_to_ext
firewall-cmd --permanent --policy policy_int_to_ext --add-ingress-zone internal
firewall-cmd --permanent --policy policy_int_to_ext --add-egress-zone external
firewall-cmd --permanent --policy policy_int_to_ext --set-priority 100
firewall-cmd --permanent --policy policy_int_to_ext --set-target ACCEPT
firewall-cmd --permanent --zone=external --add-masquerade
firewall-cmd --reload

systemctl restart NetworkManager
