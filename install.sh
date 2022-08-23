# Kakathic

Likk="$GITHUB_WORKSPACE"

Dx(){ java -jar $Likk/Tools/dx.jar --dex --no-strict --min-sdk-version 26 --core-library --output "$2" "$1"; }
smali(){ java -jar $Likk/Tools/smali-2.5.2.jar "$@"; }
baksmali(){ java -jar $Likk/Tools/baksmali-2.5.2.jar "$@"; }
Taive () { curl -s -L --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L --connect-timeout 20 "$1"; }
apksign () { java -jar $Likk/Tools/apksigner.jar sign --cert "$Likk/Tools/releasekey.x509.pem" --key "$Likk/Tools/releasekey.pk8" --out "$2" "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }
VHstring(){
echo '<?xml version="1.0" encoding="utf-8"?>
<resources>' >> $3
for vahhd in $(grep 'name=' $2 | cut -d \" -f2); do
[ "$(grep -cm1 'name=\"'$vahhd'\"' $1)" == 1 ] && Stv="$(grep -m1 'name=\"'$vahhd'\"' $1 | cut -d '>' -f2 | cut -d '<' -f1)" || Stv="$(grep -m1 'name=\"'$vahhd'\"' $2 | cut -d '>' -f2 | cut -d '<' -f1)"
echo '<string name="'$vahhd'">'$Stv'</string>' >> $3
sed -i '/name=\"'$vahhd'\"/d' $2
done
echo '</resources>'  >> $3
cp -rf $3 $2
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
Url1="$(curl -s -k -L -G -H "$User" "$Upk/apk/google-inc/youtube/youtube-$VERSION-release/youtube-$VERSION$2-android-apk-download/" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
Url2="$Upk$(curl -s -k -L -G -H "$User" "$Upk$Url1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
curl -s -k -L -H "$User" $Url2 -o $Likk/lib/$1
}

Taiyt 'YouTube.apk' '-2'

Vision="$(echo $VERSION | tr '-' '.')"
Vision2="$(echo $VERSION | sed 's|-||g')"

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
cp -rf $Likk/bin/sqlite3_$ach $Likk/Module/common/sqlite3

unzip -qo "$Likk/lib/YouTube.apk" "lib/$DEVICE/*" -d $Likk/Tav
[ "$DEVICE" == 'x86' ] || mv -f $Likk/Tav/lib/$DEVICE $Likk/Tav/lib/$ach

[ "$OPTIMIZATION" == 'true' ] && xoa2='assets/fonts/*'
[ "$ROUND" == 'true' ] || rm -fr $Likk/Module/system

if [ "$TYPE" != 'true' ];then
Taiyt 'YouTube.apks'
unzip -qo $Likk/lib/YouTube.apks 'base.apk' -d $Likk/Tav
zip -q -9 "$Likk/lib/YouTube.apk" -d 'lib/*' $xoa2
else
zip -q -9 "$Likk/lib/YouTube.apk" -d $lib $xoa2
fi

[ "$ICONS" == 'true' ] && echo -n "-e custom-branding " >> $Likk/logk

if [ "$AMOLED" == 'true' ];then
echo -n "-e amoled " >> $Likk/logk
else
amoled2=".Amoled"
fi

for vakl in $FEATURE; do
echo -n "-e $vakl " >> $Likk/logk
done

echo '
version='$Vision'
versionCode='$Vision2'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-'$LANGUAGE-$ach$amoled2'.json' >> $Likk/Module/module.prop

# Xử lý revanced patches
unzip -qo "$Likk/lib/revanced-patches.jar" -d $Likk/Pak
mkdir -p $Likk/Pak/smali
baksmali d $Likk/Pak/classes.dex -o $Likk/Pak/smali
rm -fr $Likk/Pak/classes.dex

if [ "$SVision" != "$Vision" ];then
for vak in $(grep -Rl "$SVision" $Likk/Pak/smali); do
[ -e "$vak" ] && sed -i "s|$SVision|$Vision|g" $vak
done
fi

if [ "$LANGUAGE" != 'en-US' ];then
for wngn in $(grep '=' $Likk/Language/strings.xml | cut -d = -f1); do
Stvi="$(grep -m1 '"'$wngn'"' $Likk/Language/$LANGUAGE/strings.xml | cut -d '>' -f2 | cut -d '<' -f1)"
Sten="$(grep -m1 "$wngn=" $Likk/Language/strings.xml | cut -d = -f2)"
Pathkffhg="$(grep -Rl '"'$wngn'"' $Likk/Pak/smali)"
echo "$Stvi - $Sten - $Pathkffhg"
[ -e ”$Pathkffhg” ] && sed -i 's|"'$Sten'"|"'$Stvi'"|g' "$Pathkffhg"
done
VHstring $Likk/Language/$LANGUAGE/strings.xml $Likk/Pak/downloads/host/values/strings.xml $Likk/downloads.xml
VHstring $Likk/Language/$LANGUAGE/strings.xml $Likk/Pak/returnyoutubedislike/host/values/strings.xml $Likk/returnyoutubedislike.xml
VHstring $Likk/Language/$LANGUAGE/strings.xml $Likk/Pak/sponsorblock/host/values/strings.xml $Likk/sponsorblock.xml
fi

smali ass $Likk/Pak/smali -o $Likk/Pak/classes.dex
Dx $Likk/Pak/classes.dex $Likk/Pak/Test.jar
unzip -qo $Likk/Pak/Test.jar -d $Likk/Pak
rm -fr $Likk/Pak/Test.jar $Likk/Pak/smali

cd $Likk/Pak
zip -qr "$Likk/revanced-patches.zip" *
mv -f "$Likk/revanced-patches.zip" "$Likk/lib/revanced-patches.jar"
fi

# Xây dựng 
if [ "$TYPE" != 'true' ];then
java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/Tav/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) -e microg-support --mount
cd $Likk/Tav
tar -cf - * | xz -9kz > $Likk/Module/common/lib.tar.xz
cd $Likk/Module
zip -q -r "$Likk/Up/YouTube-Magisk-$Vision-$LANGUAGE-$ach$amoled2.Zip" *
echo '{
"version": "'$Vision'",
"versionCode": "'$Vision2'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Download/YouTube-Magisk-'$Vision'-'$LANGUAGE-$ach$amoled2'.Zip",
"changelog": "https://raw.githubusercontent.com/'$GITHUB_REPOSITORY'/Vip/Zhaglog.md"
}' > $Likk/Up-$LANGUAGE-$ach$amoled2.json
else
java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/apk/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) --mount
apksign "$Likk/apk/YouTube.apk" "$Likk/Up/YouTube-NoRoot-$Vision-$LANGUAGE-$ach$amoled2.apk"
fi
