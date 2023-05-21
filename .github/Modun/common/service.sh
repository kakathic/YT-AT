# kakathic
RD="$RANDOM"
while true; do
[ -e /sdcard/Android ] && break || sleep 1
done
MODPATH="${0%/*}"
. $MODPATH/YT.sh

if [ "$(ls -l $MODPATH/system/app/YouTube/YouTube.apk | awk '{print $5}')" == "$(cat $MODPATH/SIZE)" ];then
mountYT "$MODPATH/YouTube.apk" "$MODPATH/system/app/YouTube/YouTube.apk"
offCH
else
installYT $MODPATH/system/app/YouTube/YouTube.apk
ls -l "$MODPATH/system/app/YouTube/YouTube.apk" | awk '{print $5}' > $MODPATH/SIZE
cpLIB $MODPATH/system/app/YouTube/lib "$(linkAPK)"
mountYT $MODPATH/YouTube.apk "$(linkAPK)"
offCH
fi
