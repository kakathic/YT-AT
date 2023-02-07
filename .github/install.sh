# kakathic

sudo rm -rf /usr/share/dotnet
sudo rm -rf /opt/ghc
sudo rm -rf /usr/local/share/boost

Likk="$GITHUB_WORKSPACE"
sudo apt install zipalign bash >/dev/null
User="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
apktool(){ java -jar $Likk/.github/Tools/kikfox.jar "$@"; }
Taive () { curl -s -L -N -H "$User" --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L -N -H "$User" --connect-timeout 20 "$1"; }
apksign () { java -jar $Likk/.github/Tools/apksigner.jar sign --cert "$Likk/.github/Tools/testkey.x509.pem" --key "$Likk/.github/Tools/testkey.pk8" --out "$2" "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }

apktoolur(){
apktool d -q -rs -m -f "$Likk/YouT.apk" -o "$Likk/Nn"
rm -fr "$Likk/Nn"/assets/fonts/* "$Likk/Nn"/res/*.*
for sksb in $Likk/Nn/res/*; do
[ "$(file $sksb | grep -cm1 directory)" == 1 ] || rm -rf $sksb
done
apktool b -q -c "$Likk/Nn" -f -o "$Likk/Nn.apk"
zipalign -f 4 "$Likk/Nn.apk" "$1"
}
cpnn(){
[ "$(wc -m $Likk/Module/install.sh | awk '{print $1}')" == 4394 ] || exit 0
while true; do
[ -e "$Likk/tmp/res/values-vi/strings.xml" ] && break || sleep 1
kakksks2=$(($kakksks2 + 1))
[ "$kakksks2" == 300 ] && break
done
sleep 2
for vakdll in $Likk/Lang/*; do
if [ -e $vakdll/strings.xml ];then
if [ -e $Likk/tmp/res/${vakdll##*/}/strings.xml ];then
cat $vakdll/strings.xml | sed -e 's|<?xml version="1.0" encoding="utf-8"?>||g' -e "/<\/resources>/d" -e "/<resources>/d" >> $Likk/tmp/res/${vakdll##*/}/strings.xml
sed -i "/<\/resources>/d" $Likk/tmp/res/${vakdll##*/}/strings.xml
echo '</resources>' >> $Likk/tmp/res/${vakdll##*/}/strings.xml
else
mkdir -p $Likk/tmp/res/${vakdll##*/}
cp -rf $vakdll $Likk/tmp/res
fi
fi

done
unzip -qo $Likk/lib/YouTube.apks 'base.apk' -d $Likk/Tav
while true; do
[ -e "$Likk/done.txt" ] && break || sleep 1
kakksks=$(($kakksks + 1))
[ "$kakksks" == 300 ] && break
done
sleep 2
}

ListTM="lib
tmp
Up
Nn
Tav
Pak
apk"

for Vak in $ListTM; do
mkdir -p $Vak
done

echo "- Download cli tool...
"

# Tải tool Revanced
Geturl(){ grep -m1 "$1=" $Likk/PathDL.md | cut -d = -f2; }

if [ "$(Geturl Allow_the_use_of_download_links)" == 'true' ];then

Taive "$(Geturl link_cli)" "$Likk/lib/revanced-cli.jar"       
Taive "$(Geturl link_patches)" "$Likk/lib/revanced-patches.jar"       
Taive "$(Geturl link_integrations)" "$Likk/lib/revanced-integrations.apk"       

else
Vsionnnnn="$(Xem https://github.com/revanced/revanced-cli | grep -m1 'revanced/revanced-cli/releases/tag' | sed 's|v||g' | tr "/" "\n" | grep -m1 '\">' | cut -d \" -f1)"
Taive "https://github.com/revanced/revanced-cli/releases/download/v${Vsionnnnn##*/}/revanced-cli-${Vsionnnnn##*/}-all.jar" "$Likk/lib/revanced-cli.jar"       
Vsiogddh="$(Xem https://github.com/revanced/revanced-patches | grep -m1 'revanced/revanced-patches/releases/tag' | sed 's|v||g' | tr "/" "\n" | grep -m1 '\">' | cut -d \" -f1)"
Taive "https://github.com/revanced/revanced-patches/releases/download/v${Vsiogddh##*/}/revanced-patches-${Vsiogddh##*/}.jar" "$Likk/lib/revanced-patches.jar"       
Vdbbd="$(Xem https://github.com/revanced/revanced-integrations | grep -m1 'revanced/revanced-integrations/releases/tag' | sed 's|v||g' | tr "/" "\n" | grep -m1 '\">' | cut -d \" -f1)"
Taive "https://github.com/revanced/revanced-integrations/releases/download/v${Vdbbd##*/}/revanced-integrations-${Vdbbd##*/}.apk" "$Likk/lib/revanced-integrations.apk"       

if [ "$(file $Likk/lib/revanced-integrations.apk | grep -cm1 "Zip archive")" != 1 ];then
echo "Fix Apk"
Taive "https://github.com/revanced/revanced-integrations/releases/download/v0.95.0/revanced-integrations-0.95.0.apk" "$Likk/lib/revanced-integrations.apk"
fi
fi

[ "$(file $Likk/lib/revanced-cli.jar | grep -cm1 "Zip archive")" == 1 ] && echo "Successfully: revanced-cli.jar" || echo "Failed: revanced-cli.jar"
[ "$(file $Likk/lib/revanced-patches.jar | grep -cm1 "Zip archive")" == 1 ] && echo "Successfully: revanced-patches.jar" || echo "Failed: revanced-patches.jar"
[ "$(file $Likk/lib/revanced-integrations.apk | grep -cm1 "Zip archive")" == 1 ] && echo "Successfully: revanced-integrations.apk" || echo "Failed: revanced-integrations.apk"

# Phiên bản Youtube
if [ "$VERSION" == "Default" ];then
Vidon="$(java -jar $Likk/lib/revanced-cli.jar -a $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -l --with-versions 2>/dev/null | grep -m1 hide-create-button | tr ' ' '\n' | sed -e "s| |\n|g" | tail -n2 | sed -e "s|\n||g")"
VERSION="$Vidon"
echo "VS=$Vidon" >> $GITHUB_ENV
elif [ "$VERSION" == "Auto" ];then
Vidon="$(Xem "https://www.apkmirror.com/apk/google-inc/youtube" | grep -m1 'h5 title="YouTube' | tr '\"' '\n' | grep -m1 'YouTube ' | awk '{print $2}')"
[ "$Vidon" ] || Vidon="$(java -jar $Likk/lib/revanced-cli.jar -a $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -l --with-versions 2>/dev/null | grep -m1 hide-create-button | tr ' ' '\n' | sed -e "s| |\n|g" | tail -n2 | sed -e "s|\n||g")"
VERSION="$Vidon"
KEVS=1
echo "VS=$Vidon" >> $GITHUB_ENV
else
echo "VS=$VERSION" >> $GITHUB_ENV
fi

echo -n "
$(java -jar $Likk/lib/revanced-cli.jar -a $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -l --with-versions 2>/dev/null | grep -m1 hide-create-button)"
wc -m $Likk/Module/install.sh | awk '{print $1}'

# Tải Youtube
Taiyt () {
Upk="https://www.apkmirror.com"
Url1="$(curl -s -k -L -G -H "$User" "$Upk/apk/google-inc/youtube/youtube-${VERSION//./-}-release/youtube-${VERSION//./-}$2-android-apk-download/" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
Url2="$Upk$(curl -s -k -L -G -H "$User" "$Upk$Url1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
curl -s -k -L -H "$User" $Url2 -o $Likk/lib/$1
}

echo "
- Download YouTube: $VERSION"
Taiyt 'YouTube.apk' '-2'
Taiyt 'YouTube.apks'

if [ ! -e $Likk/lib/YouTube.apk ];then
echo "
- Lỗi tải Youtube.apk
"
exit 0
fi

if [ "$(unzip -l $Likk/lib/YouTube.apk | grep -cm1 'base.apk')" == 1 ];then
mv $Likk/lib/YouTube.apk $Likk/lib/YouTube.apk2
mv $Likk/lib/YouTube.apks $Likk/lib/YouTube.apk
mv $Likk/lib/YouTube.apk2 $Likk/lib/YouTube.apks
fi

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

echo > $Likk/Module/common/$ach
cp -rf $Likk/.github/Tools/sqlite3_$ach $Likk/Module/common/sqlite3

unzip -qo "$Likk/lib/YouTube.apk" lib/$DEVICE/* -d $Likk/Tav
[ "$DEVICE" == 'x86' ] || mv -f $Likk/Tav/lib/$DEVICE $Likk/Tav/lib/$ach

[ "$ROUND" == 'true' ] || rm -fr $Likk/Module/system
[ "$ICONS" == 'true' ] && echo -n "-e custom-branding " >> $Likk/logk
[ "$SHORTS" == 'true' ] && echo -n "-e hide-shorts-button " >> $Likk/logk
[ "$CREATE" == 'true' ] && echo -n "-e disable-create-button " >> $Likk/logk
[ "$TYPE" != 'true' ] && lib='lib/*/*'

zip -qr $Likk/lib/YouTube.apk -d $lib

if [ "$AMOLED" == 'true' ];then
echo -n "-e theme " >> $Likk/logk
else
amoled2=".Amoled"
fi

for vakl in $FEATURE; do
echo -n "-e $vakl " >> $Likk/logk
done

if [ "$KEVS" != 1 ];then
echo '
version='$VERSION'
versionCode='${VERSION//./}'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-'$ach$amoled2'.json' >> $Likk/Module/module.prop
else
echo '
version='$VERSION'
versionCode='${VERSION//./}'
' >> $Likk/Module/module.prop
fi

# Xử lý revanced patches
Vid2="$(java -jar $Likk/lib/revanced-cli.jar -a $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -l --with-versions 2>/dev/null | grep -m1 hide-create-button | tr ' ' '\n' | sed -e "s| |\n|g" | tail -n2 | sed -e "s|\n||g")"
if [ "$Vid2" != "$VERSION" ];then
unzip -qo "$Likk/lib/revanced-patches.jar" -d $Likk/Pak
for vak in $(grep -Rl "$Vid2" $Likk/Pak); do
cp -rf $vak $Likk/tmp/test
XHex "$Likk/tmp/test" | sed -e "s/$(echo -n "$Vid2" | XHex)/$(echo -n "$VERSION" | XHex)/" | ZHex > $vak
done
cd $Likk/Pak
zip -qr "$Likk/lib/revanced-patches.jar" *
fi

#java -jar $Likk/.github/Tools/res-simplify-1.0.3-all.jar --in $Likk/lib/YouTube.apk --out $Likk/lib/YouTube2.apk
#cp -rf $Likk/lib/YouTube2.apk $Likk/lib/YouTube.apk

# Xây dựng 
echo "
- Build...
"

if [ "$TYPE" != 'true' ];then
( java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/YouT.apk" -t $Likk/tmp $(cat $Likk/logk) -e microg-support >> 123.txt 2>> 123.txt
sed '/WARNING: warn: removing resource/d' 123.txt
[ "$OPTIMIZATION" == 'true' ] && apktoolur "$Likk/Tav/YouTube.apk" || zipalign -f 4 "$Likk/YouT.apk" "$Likk/Tav/YouTube.apk"
cd $Likk/Tav
tar -cf - * | xz -9kz > $Likk/Module/common/lib.tar.xz
cd $Likk/Module
zip -q -r "$Likk/Up/YT-Magisk-$VERSION-$ach$amoled2.Zip" *
if [ "$KEVS" != 1 ];then
echo '{
"version": "'$VERSION'",
"versionCode": "'${VERSION//./}'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/V'$Vidon'/YT-Magisk-'$VERSION'-'$ach$amoled2'.Zip",
"changelog": "https://raw.githubusercontent.com/'$GITHUB_REPOSITORY'/Vip/Zhaglog.md"
}' > $Likk/Up-$ach$amoled2.json
fi
echo > $Likk/done.txt ) & cpnn

else

( java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/YouT.apk" -t $Likk/tmp $(cat $Likk/logk) >> 123.txt 2>> 123.txt
sed '/WARNING: warn: removing resource/d' 123.txt
[ "$OPTIMIZATION" == 'true' ] && apktoolur "$Likk/apk/YouTube.apk" || zipalign -f 4 "$Likk/YouT.apk" "$Likk/apk/YouTube.apk"
apksign "$Likk/apk/YouTube.apk" "$Likk/Up/YT-NoRoot-$VERSION-$ach$amoled2.apk" 
echo > $Likk/done.txt ) & cpnn
fi

echo "
- Complete"
