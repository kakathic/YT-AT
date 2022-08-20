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
TT="EAQCAIHBXOTG4ZZANDQ3XGIKBIQCAIBAKRSWG23PNVRGC3TLHIQDCOJQGM2DSMBSGYYDIMBRG4FA
UIBAEAQE233NN4WCAVTJMV2HIZLMEBIGC6J2EAYDGNBUGQYTGMJVHEFAUIBAEAQFM5LJEBWMHMTO
M4QGW2GDWRXGOIDH4G5Y22JAYSIWTYN3Q5XCA5WDUBXSA47BXOISBRERNHQ3XB3OEB2GQ37BXKQW
SIDD4G52OYJAOTB3I2JANDB2G6JANZUODOVPNYQHI2LOEB2ODO43NEXAUIBAEAQAUIBAEAQEXQ5K
NZUCAVDFNRSWO4TBNU5CAQDUN5XWY5TJBI======"
else
TT="EAQCAIHBXOTG4ZZANDQ3XGIKBIQCAIBAKBQXS4DBNQ5CA2DUORYDULZPOBQXS4DBNQXG2ZJPNNQW
WYLUNBUWGCRAEAQCACRAEAQCAS6DVJXGQICUMVWGKZ3SMFWTUICAORXW63DWNEFA===="
fi

ui_print
ui_print2 "Name: $(Getp name)"
ui_print
ui_print2 "Version: $(Getp version) | Author: $(Getp author)"
ui_print
ui_print2 "$TT" | base32 -d
ui_print
}

# Bắt đầu cài đặt
on_install() {

[ "$ARCH" == "arm64" ] || abort "    This module only supports arm64 devices
"

ui_print2 "Automatic..."
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

cp -f $TMPDIR/base.apk $apks
pm install -r $apks/*.apk
hhkkdf="$( pm path com.google.android.youtube | grep base | cut -d : -f2 )"
unzip -qo "$ZIPFILE" "lib/*" ${hhkkdf%/*} 

cp -f $TMPDIR/YouTube.apk $MODPATH/YouTube.apk >&2
chcon u:object_r:apk_data_file:s0 "$MODPATH/YouTube.apk"
su -mm -c mount -o bind "$MODPATH/YouTube.apk" "$hhkkdf"

ui_print2 "Turn off updates"
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

ui_print2 "Clean up"
ui_print
rm -fr /data/local/tmp/apks
ui_print2 "Remember to save the LOG if there is an error."
ui_print

if [ -z "$(pm path com.google.android.youtube)" ];then
ui_print2 "Failure"
ui_print
abort
fi
}

# Cấp quyền
set_permissions() { 
set_perm_recursive $MODPATH 0 0 0755 0644
chmod -R 755 $MODPATH/sqlite3
}
