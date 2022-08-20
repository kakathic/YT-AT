# Kakathic

Likk="$GITHUB_WORKSPACE"

Taive () { curl -s -L --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L --connect-timeout 20 "$1"; }

mkdir -p $Likk/lib

# Tải tool Revanced
Tv1="$(Xem https://github.com/revanced/revanced-cli/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv1" "$Likk/lib/revanced-cli.jar"
Tv2="$(Xem https://github.com/revanced/revanced-patches/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv2" "$Likk/lib/revanced-patches.jar"
Tv3="$(Xem https://github.com/revanced/revanced-integrations/releases | grep '/releases/download' | grep -m1 '.apk' | cut -d \" -f2)"
Taive "https://github.com$Tv3" "$Likk/lib/revanced-integrations.apk"

java -jar $Likk/lib/revanced-cli.jar

ls -1 $Likk/lib
