while read line; do echo ${line} | grep com.google.android.youtube | awk '{print $2}' | xargs umount -l; done< /proc/mounts
