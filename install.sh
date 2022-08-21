# Kakathic
sudo apt install zipalign >/dev/null

Likk="$GITHUB_WORKSPACE"
apktool () { java -jar $Likk/Tools/apktool-2.6.2-f3f199-SNAPSHOT-small.jar "$@"; }
apksign () { java -jar $Likk/Tools/apksigner.jar sign --cert "$Likk/Tools/releasekey.x509.pem" --key "$Likk/Tools/releasekey.pk8" --out "$2" "$1"; }
Taive () { curl -s -L --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L --connect-timeout 20 "$1"; }
Getpro () { grep -m1 "$1=" $Likk/Custom.md | cut -d = -f2; }

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
Url1="$(curl -s -k -L -G -H "$User" "$Upk/apk/google-inc/youtube/youtube-$(Getpro Version)-release/youtube-$(Getpro Version)$2-android-apk-download/" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
Url2="$Upk$(curl -s -k -L -G -H "$User" "$Upk$Url1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
curl -s -k -L -H "$User" $Url2 -o $Likk/lib/$1
}

Taiyt 'YouTube.apk' '-2'

Vision="$(echo $(Getpro Version) | tr '-' '.')"
Vision2="$(echo $(Getpro Version) | sed 's|-||g')"

echo "version=$Vision
versionCode=$Vision2" >> $Likk/Module/module.prop

if [ "$(Getpro Device)" == "arm64-v8a" ];then
lib="lib/x86/* lib/x86_64/* lib/armeabi-v7a/*"
ach="arm64"
elif [ "$(Getpro Device)" == "x86" ];then
lib="lib/x86_64/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x86"
elif [ "$(Getpro Device)" == "x86_64" ];then
lib="lib/x86/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x64"
else
lib="lib/arm64-v8a/* lib/x86/* lib/x86_64/*"
ach="arm"
fi

cp -rf $Likk/bin/sqlite3_$ach $Likk/Module/common/sqlite3
cp -rf "$Likk/lib/YouTube.apk" "$Likk/lib/YouTube2.apk"

[ "$(Getpro Icons)" == 1 ] && icon="-e custom-branding"
if [ "$(Getpro Amoled)" == 1 ];then
amoled="-e amoled"
amoled2=".Amoled"
fi
for vakl in $(Getpro Feature); do
echo -n "-e $vakl " >> $Likk/logk
done

[ "$(Getpro Xoa)" == 1 ] && xoa2='assets/fonts/*'

if [ "$(Getpro Type)" != 1 ];then
Taiyt 'YouTube.apks'
unzip -qo $Likk/lib/YouTube.apks 'base.apk' -d $Likk/Tav
java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/apk/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) -e microg-support $icon $amoled --mount
zip -q -r "$Likk/apk/YouTube.apk" -d 'lib/*' $xoa2
zipalign -f 4 "$Likk/apk/YouTube.apk" "$Likk/Tav/YouTube.apk"
cd $Likk/Tav
tar -cf - * | xz -9kz > $Likk/Module/common/lib.tar.xz
cd $Likk/Module
zip -q -r ''$Likk'/Up/YouTube_Magisk_'$Vision'_'$ach$amoled2'.Zip' *
else
cp -rf $Likk/Tools/Microg.apk $Likk/Up
java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube2.apk" -o "$Likk/apk/YouTube2.apk" -t $Likk/tmp $(cat $Likk/logk) $icon $amoled --mount
zip -q -r -8 "$Likk/apk/YouTube2.apk" -d $lib $xoa2
unzip -qo "$Likk/apk/YouTube2.apk" 'lib/*' -d $Likk/Tav
mv -f $Likk/Tav/lib/$(Getpro Device) $Likk/Tav/lib/$ach
zipalign -f 4 "$Likk/apk/YouTube2.apk" "$Likk/tmp/YouTube2.apk"
apksign "$Likk/tmp/YouTube2.apk" "$Likk/Up/YouTube-NoRoot-$Vision-$ach$amoled2.apk"
fi

