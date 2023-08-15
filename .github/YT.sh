# load dữ liệu 
lib1="lib/revanced-cli.jar"
lib2="lib/revanced-patches.jar"
lib3="lib/revanced-integrations.apk"

# Tải tool sta
pbsta(){
Vsion1="$(Xem https://github.com/ReVanced/$1 | grep -om1 'ReVanced/'$1'/releases/tag/.*\"' | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$1-${Vsion1##*/}$3.$2" "lib/$1.$2"; 

echo "- Url: https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$1-${Vsion1##*/}$3.$2
"
}
 
# tải tool dev
pbdev(){
Vsion2="$(Xem https://github.com/ReVanced/$1/releases | grep -om1 'ReVanced/'$1'/releases/tag/.*dev*..\"' | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/ReVanced/$1/releases/download/v${Vsion2##*/}/$1-${Vsion2##*/}$3.$2" "lib/$1.$2"; }

# tải apk
TaiYT(){
urrl="https://www.apkmirror.com"
uak1="$urrl$(Xem "$urrl/apk/$2" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
uak2="$urrl$(Xem "$uak1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2 | sed 's|amp;||')"
Taive "$uak2" "apk/$1"
echo "Link: $uak2"
[ "$(file apk/$1 | grep -cm1 'Zip')" == 1 ] && echo > "apk/$1.txt"; }

# Tải tool cli
echo "- Tải tool cli, patches, integrations..."
if [ "$DEV" == "Develop" ];then
echo "  Dùng Dev"
echo
pbdev revanced-cli jar -all
pbdev revanced-patches jar
pbdev revanced-integrations apk
else
echo "  Dùng Sta"
echo
pbsta revanced-cli jar -all
pbsta revanced-patches jar
pbsta revanced-integrations apk
fi

# kiểm tra tải tool
checkzip "lib/revanced-cli.jar"
checkzip "lib/revanced-patches.jar"
checkzip "lib/revanced-integrations.apk"
echo

java -jar "$lib1" -a "$lib3" -b "$lib2" -l --with-versions | grep -m1 'copy-video-url'
echo
chmod 777 $lib2

# Load dữ liệu cài đặt 
. $HOME/.github/options/YouTube.md

# lấy dữ liệu phiên bản mặc định
echo "- Lấy dữ liệu phiên bản YouTube..."
for kck in $Vik; do
Vidon="$(java -jar "$lib1" -a "$lib3" -b "$lib2" -l --with-versions | grep -m1 "$kck" | tr ' ' '\n' | sed -e "s| |\n|g" | tail -n2 | sed -e "s|\n||g")"
[ "$Vidon" ] && break
done

# là amoled
[ "$AMOLED" == 'true' ] && amoled2='-Amoled'
[ "$AMOLED" == 'true' ] || theme='-e theme'
[ "$TYPE" == 'true' ] && Mro="-e vanced-microg-support"

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

echo "  $Vidon"
if [ "$VERSION" == 'Auto' ];then
VER="$Vidon"
Kad=Build
V=V
elif [ "$VERSION" == 'Autu' ];then
VER="$Vidon"
Kad=Auto
V=U
if [ "$(Xem https://github.com/kakathic/YT-AT/releases/download/Up/Up-Z${V}notes.json | grep -cm1 "${VER//./}")" == 1 ];then
echo
echo "! Là phiên bản mới nhất."
exit 0
fi
else
VER="$VERSION"
Kad=News
V=N
fi

Upenv V "$V"
Upenv Kad "$Kad"
Upenv VER "$VER"
echo

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
mv apk/YouTube.apk apk/YouTube.apk2
mv apk/YouTube.apks apk/YouTube.apk
mv apk/YouTube.apk2 apk/YouTube.apks
fi

[ "$TYPE" == 'true' ] && lib='lib/*/*'

# Copy 
echo > $HOME/.github/Modun/common/$ach
cp -rf $HOME/.github/Tools/sqlite3_$ach $HOME/.github/Modun/common/sqlite3

# Xoá lib
unzip -qo "apk/YouTube.apk" lib/$DEVICE/* -d Tav
mv -f Tav/lib/$DEVICE Tav/lib/$ach
unzip -qo apk/YouTube.apks 'base.apk' -d Tav
zip -qr apk/YouTube.apk -d $lib

# Xử lý revanced patches
if [ "$Vidon" != "$VER" ];then
echo "- Chuyển đổi phiên bản $VER"
unzip -qo "$lib2" -d $HOME/jar
for vak in $(grep -Rl "$Vidon" $HOME/jar); do
cp -rf $vak test
XHex test | sed -e "s/$(echo -n "$Vidon" | XHex)/$(echo -n "$VERSION" | XHex)/" | ZHex > $vak
done
cd $HOME/jar
rm -fr $lib2
zip -r "$lib2" *
cd $HOME
fi

# MOD YouTube 
(

echo "▼ Bắt đầu quá trình xây dựng..."
java -Djava.io.tmpdir=$HOME -jar "$lib1" -b "$lib2" -m "$lib3" -a apk/YouTube.apk -o YT.apk \
-t tmp $Tof $Ton $Mro $theme $feature > Log.txt 2>> Log.txt
sed '/WARNING: warn: removing resource/d' Log.txt
echo > 2.txt

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

echo > 1.txt

)

# Chờ xây dựng xong
Loading "1.txt" "2.txt" >/dev/null
if [ "$TYPE" == 'true' ];then
mv YT.apk $HOME/Tav/YouTube.apk
else
apksign YT.apk $HOME/Up/YT-$VER-$ach${amoled2}.apk
ls Up
exit 0
fi
cd Tav
tar -cf - * | xz -9kz > $HOME/.github/Modun/common/lib.tar.xz
cd $HOME

# Tạo module.prop
echo 'id=YouTube
name=YouTube PiP '$Kad'
author=kakathic
description=Build '$(date)', YouTube edited tool by Revanced mod added disable play store updates, mod rounded pip window.
version='$VER'
versionCode='${VER//./}'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-Z'$V$ach$amoled2'.json
' > $HOME/.github/Modun/module.prop

# Tạo json
echo '{
"version": "'$VER'",
"versionCode": "'${VER//./}'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Z'$V$VER'/YT-Magisk-'$VER'-'$ach$amoled2'.Zip",
"changelog": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-Z'$V'notes.json"
}' > Up-Z$V$ach$amoled2.json

echo 'Update '$(date)', YouTube: '$VER', Version: '${VER//./}', Download: https://github.com/kakathic/YT-AT/releases ' > Up-Z${V}notes.json

# Tạo module magisk
cd $HOME/.github/Modun
zip -qr $HOME/Up/YT-Magisk-$VER-$ach$amoled2.zip *
cd $HOME
ls Up
