# Kakathic

echo "$VERSION"

Likk="$GITHUB_WORKSPACE"

Taive () { curl -s -L --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L --connect-timeout 20 "$1"; }
apksign () { java -jar $Likk/Tools/apksigner.jar sign --cert "$Likk/Tools/releasekey.x509.pem" --key "$Likk/Tools/releasekey.pk8" --out "$2" "$1"; }

ListTM="lib
tmp
Up
Nn
Tav
apk"

for Vak in $ListTM; do
mkdir -p $Vak
done

# Tải tool Revanced
Tv1="$(Xem https://github.com/revanced/revanced-cli/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv1" "$Likk/lib/revanced-cli.jar"
Tv2="$(Xem https://github.com/revanced/revanced-patches/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv2" "$Likk/lib/revanced-patches.jar"
Tv3="$(Xem https://github.com/revanced/revanced-integrations/releases | grep '/releases/download' | grep -m1 '.apk' | cut -d \" -f2)"
Taive "https://github.com$Tv3" "$Likk/lib/revanced-integrations.apk"

# Tải Youtube

Taiyt () {
Upk="https://www.apkmirror.com"
User="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
Url1="$(curl -s -k -L -G -H "$User" "$Upk/apk/google-inc/youtube/youtube-${{ github.event.inputs.VERSION }}-release/youtube-${{ github.event.inputs.VERSION }}$2-android-apk-download/" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
Url2="$Upk$(curl -s -k -L -G -H "$User" "$Upk$Url1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
curl -s -k -L -H "$User" $Url2 -o $Likk/lib/$1
}

Taiyt 'YouTube.apk' '-2'

Vision="$(echo ${{ github.event.inputs.VERSION }} | tr '-' '.')"
Vision2="$(echo ${{ github.event.inputs.VERSION }} | sed 's|-||g')"

if [ "${{ github.event.inputs.DEVICE }}" == "arm64-v8a" ];then
lib="lib/x86/* lib/x86_64/* lib/armeabi-v7a/*"
ach="arm64"
elif [ "${{ github.event.inputs.DEVICE }}" == "x86" ];then
lib="lib/x86_64/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x86"
elif [ "${{ github.event.inputs.DEVICE }}" == "x86_64" ];then
lib="lib/x86/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x64"
else
lib="lib/arm64-v8a/* lib/x86/* lib/x86_64/*"
ach="arm"
fi

echo > $Likk/Module/common/$ach
cp -rf $Likk/bin/sqlite3_$ach $Likk/Module/common/sqlite3

unzip -qo "$Likk/lib/YouTube.apk" "lib/${{ github.event.inputs.DEVICE }}/*" -d $Likk/Tav
[ "${{ github.event.inputs.DEVICE }}" == 'x86' ] || mv -f $Likk/Tav/lib/${{ github.event.inputs.DEVICE }} $Likk/Tav/lib/$ach

[ "${{ github.event.inputs.OPTIMIZATION }}" == 1 ] && xoa2='assets/fonts/*'
[ "${{ github.event.inputs.ROUND }}" == 1 ] || rm -fr $Likk/Module/system

if [ "${{ github.event.inputs.TYPE }}" != 1 ];then
Taiyt 'YouTube.apks'
unzip -qo $Likk/lib/YouTube.apks 'base.apk' -d $Likk/Tav
zip -q -9 "$Likk/lib/YouTube.apk" -d 'lib/*' $xoa2
else
zip -q -9 "$Likk/lib/YouTube.apk" -d $lib $xoa2
fi

[ "${{ github.event.inputs.ICONS }}" == 1 ] && icon="-e custom-branding"
if [ "${{ github.event.inputs.AMOLED }}" == 1 ];then
amoled="-e amoled"
else
amoled2=".Amoled"
fi
for vakl in ${{ github.event.inputs.FEATURE }}; do
echo -n "-e $vakl " >> $Likk/logk
done

echo '
version='$Vision'
versionCode='$Vision2'
updateJson=https://github.com/kakathic/YT-AT/releases/download/Up/Up-'$ach$amoled2'.json' >> $Likk/Module/module.prop


if [ "${{ github.event.inputs.TYPE }}" != 1 ];then
java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/Tav/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) -e microg-support $icon $amoled --mount
cd $Likk/Tav
tar -cf - * | xz -9kz > $Likk/Module/common/lib.tar.xz
cd $Likk/Module
zip -q -r ''$Likk'/Up/YouTube_Magisk_'$Vision'_'$ach$amoled2'.Zip' *
echo '{
"version": "'$Vision'",
"versionCode": "'$Vision2'",
"zipUrl": "https://github.com/kakathic/YT-AT/releases/download/Download/YouTube_Magisk_'$Vision'_'$ach$amoled2'.Zip",
"changelog": "https://raw.githubusercontent.com/kakathic/YT-AT/Vip/Zhaglog.md"
}' > $Likk/Up-$ach$amoled2.json
else
java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/apk/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) $icon $amoled --mount
apksign "$Likk/apk/YouTube.apk" "$Likk/Up/YouTube-NoRoot-$Vision-$ach$amoled2.apk"
fi
