#!/bin/bash
#set -x

DEST="172.16.99.21:backup"
MAXSNAP="70"

exec > >(logger  -p local0.notice -t `basename "$0"`) 
exec 2> >(logger  -p local0.error -t `basename "$0"`)

pgrep pve-zsync && exit 0

echo Strated

for NODE in `pvesh ls nodes | awk '{print $2'}`; do

    echo ssh root@$NODE pve-zsync sync -source rpool/ROOT/pve-1 -dest "${DEST}/${NODE}" -name auto --maxsnap ${MAXSNAP}
         ssh root@$NODE pve-zsync sync -source rpool/ROOT/pve-1 -dest "${DEST}/${NODE}" -name auto --maxsnap ${MAXSNAP}


    for VMID in `ssh root@$NODE pvesh ls nodes/localhost/lxc | awk '{print $2'}`; do
        echo ssh root@$NODE pve-zsync sync -source ${VMID} -dest "${DEST}/data" -name auto --maxsnap ${MAXSNAP}
             ssh root@$NODE pve-zsync sync -source ${VMID} -dest "${DEST}/data" -name auto --maxsnap ${MAXSNAP}
    done


    for VMID in `ssh root@$NODE pvesh ls nodes/localhost/qemu | awk '{print $2'}`; do
        echo ssh root@$NODE pve-zsync sync -source ${VMID} -dest "${DEST}/data" -name auto --maxsnap ${MAXSNAP}
             ssh root@$NODE pve-zsync sync -source ${VMID} -dest "${DEST}/data" -name auto --maxsnap ${MAXSNAP}
    done

done
echo Done


