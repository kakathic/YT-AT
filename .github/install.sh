# kakathic

sudo rm -rf /usr/share/dotnet
sudo rm -rf /opt/ghc
sudo rm -rf /usr/local/share/boost

HOME="$GITHUB_WORKSPACE"
sudo apt install zipalign bash 2>/dev/null >/dev/null
cd $HOME

# Tạo thư mục
mkdir -p apk lib tmp jar Tav Up
User="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"

# khu vực fusion 
Taive () { curl -s -L -N -H "$User" --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L -N -H "$User" --connect-timeout 20 "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }
Upenv(){ echo "$1=$2" >> $GITHUB_ENV; }
checkfile(){ [ -e "$1" ] && echo "  Ok ${1##*/}" || ( echo "- Lỗi không không thấy file ${1##*/}"; exit 1 ); }
checkzip(){ [ "$(file $1 | grep -cm1 'Zip')" == 1 ] && echo "  Zip ok ${1##*/}" || ( echo "- Lỗi zip ${1##*/}"; exit 1; ); }
Loading(){
while true; do
if [ -e "$1" ] && [ -e "$2" ];then
echo "  Xác nhận file ok"
break
else
sleep 1
gfdgv=$(($gfdgv + 1))
[ "$gfdgv" == 100 ] && ( echo "- Quá thời gian cho phép..."; exit 1; )
fi
done; }
echo

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
if [ "$DEV" == "Develop" ];then
echo "- Tải Dev"
pbdev revanced-cli jar -all
pbdev revanced-patches jar
pbdev revanced-integrations apk
else
echo "- Tải Sta"
pbsta revanced-cli jar -all
pbsta revanced-patches jar
pbsta revanced-integrations apk
fi

# kiểm tra tải tool
checkzip "lib/revanced-cli.jar"
checkzip "lib/revanced-patches.jar"
checkzip "lib/revanced-integrations.apk"
echo

