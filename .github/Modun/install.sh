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
. $TMPDIR/YT.sh

# Lấy dữ liệu
Getp () { grep_prop $1 $TMPDIR/module.prop; }
settings put global package_verifier_enable 0

# Giới thiệu
print_modname() {

if [ "$(settings get system system_locales)" == "vi-VN" ];then
TT="EAQCAICEN5XGC5DFEBKGKY3IMNXW2YTBNZVTUIBRHEYDGNBZGAZDMMBUGAYTOCQKEAQCAICUMVWGKZ3SMFWTUICAORXW63DWNYFA===="
else
TT="EAQCAICEN5XGC5DFHIQGQ5DUOA5C6L3QMF4XAYLMFZWWKL3LMFVWC5DINFRQUCRAEAQCAVDFNRSWO4TBNU5CAQDUN5XWY5TOBI======"
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
cp -f $TMPDIR/YT.sh $MODPATH >&2
[ -e /vendor/overlay/YT.apk ] || unzip -qo "$ZIPFILE" "system/*" -d $MODPATH >&2
chmod -R 755 $MODPATH/sqlite3

checkYT

ui_print2 "Install YouTube"
ui_print
tar -xJf $TMPDIR/lib.tar.xz -C $MODPATH

installYT $MODPATH/base.apk

ls -l "$MODPATH/base.apk" | awk '{print $5}' > $MODPATH/SIZE

ui_print2 "Copy lib"
ui_print
cpLIB $MODPATH/lib "$(linkAPK)"


ui_print2 "Mount YouTube"
ui_print
mountYT $MODPATH/YouTube.apk "$(linkAPK)" &

ui_print2 "Turn off update"
ui_print

offCH

[ "$(Getp author)" == 'kakathic' ] || abort "Copyright infringement"

if [ -z "$(pm path com.google.android.youtube)" ];then
ui_print2 "Failure"
ui_print
abort
fi

[ "$TT" ] || abort "Copyright infringement"

ui_print2 "Complete"
ui_print

}

# Cấp quyền
set_permissions() { 
set_perm_recursive $MODPATH 0 0 0755 0644
chmod -R 755 $MODPATH/sqlite3
}
