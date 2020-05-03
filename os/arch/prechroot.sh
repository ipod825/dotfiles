trap "exit 1" TERM
export TOP_PID=$$

getoptions(){
  options=()
  options_arr=()
  for item in $2; do
    options+=("${item%$'\n'}" "")
    options_arr+=("$item")
  done
  res=$(whiptail --title "${1}" --menu "${3}" 0 0 0 "${options[@]}" --default-item "${options_arr[$4]}" --cancel-button "Exit" 3>&1 1>&2 2>&3)
  if [ "$?" == "1" ]; then
      kill -s TERM $TOP_PID
  else
      echo "${res}"
  fi
}

device=$(getoptions "Select Install Device" "`lsblk -d -p -n -l -o NAME -e 7,11`")
while true; do
    partitions="`lsblk $device -p -l -n -o NAME -e 7,11 | tail -n +2` NONE"
    bootdevice=$(getoptions "Select Partition" "${partitions}" "Boot" 0)
    rootdevice=$(getoptions "Select Partition" "${partitions}" "Root" 1)
    swapdevice=$(getoptions "Select Partition" "${partitions}" "Swap" 2)
    homedevice=$(getoptions "Select Partition" "${partitions}" "Home" 3)

    if (whiptail --title "Confirm Partitions" --yesno "${bootdevice} Boot\n${rootdevice} Root\n${swapdevice} Swap\n${homedevice} Home\n " 0 0 3>&1 1>&2 2>&3) then
        break
    fi
done


if [ "$rootdevice" != "NONE" ]; then
    mkfs.ext4 $rootdevice
    mount $rootdevice /mnt
else
    echo "Root device is necessary!"
    exit -1
fi

if [ "$swapdevice" != "NONE" ]; then
    mkswap $swapdevice
    swapon $swapdevice
fi

mkdir -p /mnt/home

if [ "$homedevice" != "NONE" ]; then
    mount $homedevice /mnt/home
fi

mkdir -p /mnt/boot/efi
if [ "$bootdevice" != "NONE" ]; then
    mount $bootdevice /mnt/boot/efi
fi

pacstrap /mnt base base-devel linux linux-firmware
genfstab -U -p /mnt > /mnt/etc/fstab
echo "run: arch-chroot /mnt"
