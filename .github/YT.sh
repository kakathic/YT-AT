# Load dữ liệu cài đặt 
. $HOME/.github/options/YouTube.md

# lấy dữ liệu phiên bản mặc định
echo "- Lấy dữ liệu phiên bản YouTube..."
for kck in $Vik; do
Vidon="$(java -jar "$lib1" -a "$lib3" -b "$lib2" -l --with-versions | grep -m1 "$kck" | tr ' ' '\n' | sed -e "s| |\n|g" | tail -n2 | sed -e "s|\n||g")"
[ "$Vidon" ] && break
done
[ "$VERSION" == 'Auto' ] && VER="$Vidon" || VER="$VERSION"
Upenv VER "$VER"
echo "  $VER"

echo "- Tải YouTube apk apks..."
# Tải YouTube apk
kkk1="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-2-android-apk-download"
kkk2="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-android-apk-download"

# Tải
TaiYT 'YouTube.apk' "$kkk1" & TaiYT 'YouTube.apks' "$kkk2"

# Chờ tải xong
Loading apk/YouTube.apk.txt apk/YouTube.apks.txt

# Xem xét apk
if [ "$(unzip -l apk/YouTube.apk | grep -cm1 'base.apk')" == 1 ];then
echo "- Thay đổi apks thành apk."
echo
mv apk/YouTube.apk apk/YouTube.apk2
mv apk/YouTube.apks apk/YouTube.apk
mv apk/YouTube.apk2 apk/YouTube.apks
fi

# Xoá lib dựa vào abi
if [ "$DEVICE" == "arm64-v8a" ];then
lib="lib/x86/* lib/x86_64/* lib/armeabi-v7a/*"
ach="arm64"
elif [ "$DEVICE" == "x86" ];then
lib="lib/x86_64/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x86"
elif [ "$DEVICE" == "x86_64" ];then
lib="lib/x86/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x64"
else
lib="lib/arm64-v8a/* lib/x86/* lib/x86_64/*"
ach="arm"
fi

# Copy 
echo > $HOME/.github/Modun/common/$ach
cp -rf $HOME/.github/Tools/sqlite3_$ach $HOME/.github/Modun/common/sqlite3

# Xoá lib
unzip -qo "apk/YouTube.apk" lib/$DEVICE/* -d Tav
mv -f Tav/lib/$DEVICE Tav/lib/$ach
unzip -qo apk/YouTube.apks 'base.apk' -d Tav
zip -qr apk/YouTube.apk -d 'lib/*/*'

# Xử lý revanced patches
if [ "$Vidon" != "$VER" ];then
echo "- Chuyển đổi phiên bản thành $VER"
unzip -qo "lib/revanced-patches.jar" -d jar
for vak in $(grep -Rl "$Vidon" jar); do
cp -rf $vak test
XHex test | sed -e "s/$(echo -n "$Vidon" | XHex)/$(echo -n "$VERSION" | XHex)/" | ZHex > $vak
done
cd jar
zip -qr "lib/revanced-patches.jar" *
cd $HOME
fi

# là amoled
[ "$AMOLED" == 'true' ] && amoled2='-Amoled'
[ "$AMOLED" == 'true' ] || theme='-e theme'
[ "$TYPE" == 'true' ] && Mro="-e vanced-microg-support"

# MOD YouTube 
(

echo "▼ Bắt đầu quá trình xây dựng..."
java -Djava.io.tmpdir=$HOME -jar $lib1 -b $lib2 -m $lib3 -a apk/YouTube.apk -o YT.apk \
-t tmp $Tof $Ton $Mro $theme $feature > Log.txt 2>> Log.txt
sed '/WARNING: warn: removing resource/d' Log.txt

) & (

Loading "tmp/res/values" "tmp/res/values" >/dev/null
zip -qr apk/YouTube.apk -d res/*
sleep 2

for kvc in $(ls $HOME/.github/Language); do
mkdir -p $HOME/tmp/res/${kvc%.*}
sed -i "/<\/resources>/d" $HOME/tmp/res/${kvc%.*}/strings.xml
[ -e $HOME/tmp/res/${kvc%.*} ] && cat $HOME/.github/Language/$kvc | sed -e 's|<?xml version="1.0" encoding="utf-8"?>||g' -e "/<\/resources>/d" -e "/<resources>/d" >> $HOME/tmp/res/${kvc%.*}/strings.xml || cat $HOME/.github/Language/$kvc | sed "/<\/resources>/d" >> $HOME/tmp/res/${kvc%.*}/strings.xml
echo '</resources>' >> $HOME/tmp/res/${kvc%.*}/strings.xml
done

)

# Chờ xây dựng xong
Loading "YT.apk" "YT.apk" >/dev/null
if [ "$TYPE" == 'true' ];then
mv YT.apk $HOME/Tav/YouTube.apk
else
mv YT.apk $HOME/Up/YT-$VER-$ach${amoled2}.apk
ls Up
exit 0
fi
cd Tav
tar -cf - * | xz -9kz > $HOME/.github/Modun/common/lib.tar.xz
cd $HOME

# Tạo module.prop
echo 'id=YouTube
name=YouTube PiP
author=kakathic
description=Build '$(date)', YouTube edited tool by Revanced mod added disable play store updates, mod rounded pip window.
version='$VER'
versionCode='${VER//./}'
updateJson=https://github.com/kakathic/YT-AT/releases/download/Up/Up-'$ach'.json
' > $HOME/.github/Modun/module.prop

# Tạo json
echo '{
"version": "'$VER'",
"versionCode": "'${VER//./}'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/V'$VER'/YT-Magisk-'$VER'-'$ach$amoled2'.Zip",
"changelog": "https://raw.githubusercontent.com/'$GITHUB_REPOSITORY'/Vip/Zhaglog.md"
}' > Up-$ach$amoled2.json

echo 'Update '$(date)'' > Up-notes.json

# Tạo module magisk
cd $HOME/.github/Modun
zip -qr $HOME/Up/YT-Magisk-$VER-$ach$amoled2.zip *
cd $HOME
ls Up
