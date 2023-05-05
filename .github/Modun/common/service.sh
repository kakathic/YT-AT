# kakathic
RD="$RANDOM"
while true; do
[ -e /sdcard/Android ] && break || sleep 1
done
MODPATH="${0%/*}"
. $MODPATH/YT.sh

if [ "$(ls -l $(linkAPK) | awk '{print $5}')" == "$(cat $MODPATH/SIZE)" ];then
mountYT "$MODPATH/YouTube.apk" "$(linkAPK)"
offCH
else
installYT $MODPATH/base.apk
ls -l "$(linkAPK)" | awk '{print $5}' > $MODPATH/SIZE
cpLIB $MODPATH/lib "$(linkAPK)"
mountYT $MODPATH/YouTube.apk "$(linkAPK)"
offCH
fi
