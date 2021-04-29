#!/bin/bash
# EBS configuration script

# update system
sudo yum update -y

# create a partition for attached EBS volumes

echo "${ebs_vol1}"> disk_file.txt
echo "${ebs_vol2}">> disk_file.txt
echo "${ebs_vol3}">> disk_file.txt


num=1
counter=1
while read LINE
do 
sudo fdisk $LINE <<EOT
n
P
1
2048
16777215
w
EOT
sudo pvcreate $LINE$num
sudo vgcreate stack_vg$counter $LINE$num
sudo lvcreate -L 5G -n Lv_u0$counter stack_vg$counter
sudo mkfs.ext4 /dev/stack_vg$counter/Lv_u0$counter
sudo mkdir /u0$counter
sudo mount /dev/stack_vg$counter/Lv_u0$counter /u0$counter
sudo lvextend -L +2G /dev/mapper/stack_vg$counter-Lv_u0$counter
sudo resize2fs /dev/mapper/stack_vg$counter-Lv_u0$counter
sudo echo /dev/mapper/stack_vg$counter-Lv_u0$counter /u0$counter ext4 defaults 1 2 >> /etc/fstab
((counter++))
done < disk_file.txt




