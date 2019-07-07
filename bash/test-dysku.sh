#!/bin/bash

disksata=`lsblk | grep -Eo "sd.."` 

#count=`lsblk | grep -Eo "sd.." | wc -l`
apt  --installed list | grep hdparm >/dev/null
if [ $? -eq 0 ]; 
then
echo hdparm OK
else
apt install hdparm >/dev/null
fi
echo "test disk in progress."
dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync 2> /tmp/test-dysku-zapis
rm -rf tmp/test1.img
echo "test disk in progress.."
dd if=/dev/zero of=/tmp/test2.img bs=64M count=1 oflag=dsync 2>> /tmp/test-dysku-zapis
rm -rf /tmp/test2.img
echo "test disk in progress..."
dd if=/dev/zero of=/tmp/test3.img bs=1M count=256 conv=fdatasync 2>> /tmp/test-dysku-zapis
rm -rf /tmp/test2.img
echo "test disk in progress...."
dd if=/dev/zero of=/tmp/test4.img bs=8k count=10k 2>> /tmp/test-dysku-zapis
rm -rf /tmp/test2.img
echo "test disk in progress....."
dd if=/dev/zero of=/tmp/test4.img bs=512 count=1000 oflag=dsync 2>> /tmp/test-dysku-zapis
rm -rf /tmp/test4.img
echo "test disk in progress......."
for dysk in $disksata
do
hdparm -Tt /dev/$dysk >>/tmp/test-dysku-odczyt
echo "test disk in progress........"
done
cat /tmp/test-dysku-zapis | grep -e MB/s -e kB/s -e GB/s -e TB/s -e B/s -e b/s
cat /tmp/test-dysku-odczyt
rm -rf /tmp/test-dysku-zapis /tmp/test-dysku-odczyt


