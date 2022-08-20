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
Taiyt 'YouTube.apks'

Vision="$(echo $(Getpro Version) | tr '-' '.')"
Vision2="$(echo $(Getpro Version) | sed 's|-||g')"

echo "version=$Vision
versionCode=$Vision2" >> $Likk/Module/module.prop

unzip -qo $Likk/lib/YouTube.apks 'base.apk' -d $Likk/Tav

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

cp -rf $Likk/Tools/Microg.apk $Likk/Up
cp -rf $Likk/bin/sqlite3_$ach $Likk/Module/common/sqlite3
cp -rf "$Likk/lib/YouTube.apk" "$Likk/lib/YouTube2.apk"

[ "$(Getpro Icons)" == 1 ] && icon="-e custom-branding"
[ "$(Getpro Amoled)" == 1 ] && amoled="-e amoled"

for vakl in $(Getpro Feature); do
echo -n "-e $vakl " >> $Likk/logk
done

java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/apk/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) -e microg-support $icon $amoled --mount

java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube2.apk" -o "$Likk/apk/YouTube2.apk" -t $Likk/tmp $(cat $Likk/logk) $icon $amoled --mount

apktool d -s -f "$Likk/lib/YouTube.apk" -o "$Likk/YouTube"
apktool d -s -f "$Likk/lib/YouTube2.apk" -o "$Likk/YouTube2"

if [ "$(grep -cm1 'vote_upvote' $Likk/*/res/values-vi/strings.xml)" != 1 ];then
sed -i 's|</resources>||' $Likk/*/res/values-vi/strings.xml
cat $Likk/Tools/strings.xml >> $Likk/YouTube/res/values-vi/strings.xml
cat $Likk/Tools/strings.xml >> $Likk/YouTube2/res/values-vi/strings.xml
fi

[ "$(Getpro Xoa)" == 1 ] && rm -fr $Likk/*/assets/fonts

if [ "$(Getpro Language)" ];then
cp -rf $Likk/*/res/values-"$(Getpro Language)"* $Likk/Nn
cp -rf $Likk/*/res/values $Likk/Nn
for kggh in $Likk/*/res/*/strings.xml; do
rm -fr ${kggh%/*}
done
cp -rf $Likk/Nn/* $Likk/*/res
fi

apktool b -c -f "$Likk/YouTube" -o "$Likk/YouTube.apk"
apktool b -c -f "$Likk/YouTube2" -o "$Likk/YouTube2.apk"

zip -q -r "$Likk/YouTube.apk" -d 'lib/*'
zip -q -r "$Likk/YouTube2.apk" -d $lib

unzip -qo "$Likk/YouTube2.apk" 'lib/*' -d $Likk/Tav
mv -f $Likk/Tav/lib/$(Getpro Device) $Likk/Tav/lib/$ach

zipalign -f 4 "$Likk/YouTube.apk" "$Likk/Tav/YouTube.apk"
zipalign -f 4 "$Likk/YouTube2.apk" "$Likk/tmp/YouTube2.apk"
#apksign "$Likk/tmp/YouTube2.apk" "$Likk/Up/YouTube-$Vision-$ach.apk"

cd $Likk/Tav
tar -cf - * | xz -9kz > $Likk/Module/common/lib.tar.xz

cd $Likk/Module
zip -q -r ''$Likk'/Up/YouTube_'$Vision'_'$ach'.Zip' *
