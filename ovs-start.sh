#!/bin/bash

main_path=/home/ovs04
ovs_path=${main_path}/files/openvswitch-2.5.0
ovs_mod_path=${ovs_path}/datapath/linux
ovs_mod=openvswitch.ko

#loads the modules ovs depended and the ovs modules
ovs_depend_mods="nf_conntrack ip_tunnel nf_defrag_ipv6 libcrc32c gre nf_defrag_ipv4"
for mod in $ovs_depend_mods;do
	sudo modprobe $mod
done
cd ${ovs_mod_path}
sudo insmod ${ovs_mod}


#starts the ovs
sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                     --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                     --private-key=db:Open_vSwitch,SSL,private_key \
                     --certificate=db:Open_vSwitch,SSL,certificate \
                     --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                     --pidfile --detach
sudo ovs-vsctl --no-wait init
sudo ovs-vswitchd --pidfile --detach
