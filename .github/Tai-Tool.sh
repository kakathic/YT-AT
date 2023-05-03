# load dữ liệu 
lib1="lib/revanced-cli.jar"
lib2="lib/revanced-patches.jar"
lib3="lib/revanced-integrations.apk"

# Tải tool sta
pbsta(){
Vsion1="$(Xem https://github.com/revanced/$1 | grep -om1 'revanced/'$1'/releases/tag/.*\"' | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/revanced/$1/releases/download/v${Vsion1##*/}/$1-${Vsion1##*/}$3.$2" "lib/$1.$2"; }

# tải tool dev
pbdev(){
Vsion2="$(Xem https://github.com/revanced/$1/releases | grep -om1 'revanced/'$1'/releases/tag/.*dev*..\"' | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/revanced/$1/releases/download/v${Vsion2##*/}/$1-${Vsion2##*/}$3.$2" "lib/$1.$2"; }

# tải apk
TaiYT(){
urrl="https://www.apkmirror.com"
uak1="$urrl$(Xem "$urrl/apk/$2" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
uak2="$urrl$(Xem "$uak1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
Taive "$uak2" "apk/$1"
echo > "apk/$1.txt"; }

# Tải tool cli
echo "- Tải tool cli, patches, integrations..."
if [ "$phienban" == "dev" ];then
pbdev revanced-cli jar -all
pbdev revanced-patches jar
pbdev revanced-integrations apk
else
pbsta revanced-cli jar -all
pbsta revanced-patches jar
pbsta revanced-integrations apk
fi


# kiểm tra tải tool
checkfile "lib/revanced-cli.jar" "- Lỗi tải file revanced-cli"
checkfile "lib/revanced-patches.jar" "- Lỗi tải file revanced-patches"
checkfile "lib/revanced-integrations.apk" "- Lỗi tải file revanced-integrations"
