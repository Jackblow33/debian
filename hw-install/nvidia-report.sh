#!/bin/bash

# After first reboot
# Report.txt path.
REPORT_PATH='/home/jack/Downloads/nvidia-report.txt'       ###### CHANGE THE PATH ON FINAL VERSION

# Check if nouveau have been blaclisted properly
lsmod | grep nouveau
if [ $? -eq 0 ]; then
    echo 'Nouveau NVIDIA driver still present' >> $REPORT_PATH
else
    echo 'Nouveau NVIDIA driver have been blacklisted' >> $REPORT_PATH
fi

# Check if nvidia_drm-modeset is Y
modeset_value=$(sudo cat /sys/module/nvidia_drm/parameters/modeset)

if [ "$modeset_value" == "Y" ]; then
    echo 'nvidia_drm-modeset have been enabled' >> $REPORT_PATH
else
    echo 'nvidia_drm-modeset not enabled' >> $REPORT_PATH
fi


# Check if FIX sleep issue have been applied
preserve_value=$(cat /proc/driver/nvidia/params | grep "PreserveVideoMemoryAllocations" | awk -F": " '{print $2}')

if [ "$preserve_value" == "1" ]; then
    echo 'Fix sleep issue have been applied properly' >> $REPORT_PATH
else
    echo 'Fix sleep issue not applied properly' >> $REPORT_PATH
fi


# Check iommu status
iommu_status=$(dmesg | grep -i iommu)

if [[ "$iommu_status" == *"IOMMU enabled"* ]]; then
    echo 'IOMMU enabled' >> $REPORT_PATH
else
    echo 'IOMMU not enabled' >> $REPORT_PATH
fi
