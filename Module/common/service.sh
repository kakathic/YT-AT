while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 1; done
sleep 1

RD="$RANDOM"
while true; do
echo > /sdcard/$RD
if [ -e /sdcard/$RD ];then
rm -fr /sdcard/$RD
break
else
sleep 2
fi
done

sqlite3 () {
${0%/*}/sqlite3 "$@"
}

PK=com.google.android.youtube
base_path="${0%/*}/YouTube.apk"
stock_path=$(pm path $PK | cut -d : -f2)

if [ "$stock_path" ];then
chcon u:object_r:apk_data_file:s0 $base_path
mount -o bind $base_path $stock_path
cp -rf ${0%/*}/lib ${stock_path%/*}
cmd package compile -m speed $PK
else
pm install -r ${0%/*}/base.apk
apk_path=$(pm path $PK | cut -d : -f2)
sleep 2
cp -rf ${0%/*}/lib ${apk_path%/*}
chcon u:object_r:apk_data_file:s0 $base_path
mount -o bind $base_path $apk_path
cmd package compile -m speed $PK
fi

PS=com.android.vending
DB=/data/data/$PS/databases
LDB=$DB/library.db
LADB=$DB/localappstate.db

GET_LDB=$(sqlite3 $LDB "SELECT doc_id,doc_type FROM ownership" | grep $PK | head -n 1 | grep -o 25)

if [ "$GET_LDB" != "25" ]; then
	cmd appops set --uid $PS GET_USAGE_STATS ignore
	pm disable $PS > /dev/null 2>&1
	sqlite3 $LDB "UPDATE ownership SET doc_type = '25' WHERE doc_id = '$PK'";
	sqlite3 $LADB "UPDATE appstate SET auto_update = '2' WHERE package_name = '$PK'";
	rm -rf /data/data/$PS/cache/*
	pm enable $PS > /dev/null 2>&1
fi
