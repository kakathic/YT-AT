# kakathic

sudo rm -rf /usr/share/dotnet
sudo rm -rf /opt/ghc
sudo rm -rf /usr/local/share/boost

HOME="$GITHUB_WORKSPACE"
sudo apt install zipalign bash >/dev/null
cd $HOME

phienban="dev"

# Tạo thư mục
mkdir -p apk lib tmp jar

User="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"

# khu vực fusion 
Taive () { curl -s -L -N -H "$User" --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L -N -H "$User" --connect-timeout 20 "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }
checkfile(){ [ -e "$1" ] && echo "  Ok ${1##*/}" || ( echo "- Lỗi không không thấy file ${1##*/}"; exit 1 ); }
checkzip(){ [ "$(file $1 | grep -cm1 'Zip')" == 1 ] && echo "  Zip ok ${1##*/}" || ( echo "- Lỗi zip ${1##*/}"; exit 1; ); }
Loading(){
while true; do
if [ -e "$1" ] && [ -e "$2" ];then
break
else
sleep 1
gfdgv=$(($gfdgv + 1))
[ "$gfdgv" == 100 ] && ( echo "- Quá thời gian cho phép..."; exit 1; )
fi
done; }
