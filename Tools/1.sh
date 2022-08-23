

#grep = mod.xml | cut -d '>' -f2 | cut -d '<' -f1 | awk '{print $0}'

for vah in $(grep = mod.xml | cut -d '"' -f2); do
envb="$(grep -m1 '\"'$vah'\"' mod.xml | cut -d '>' -f2 | cut -d '<' -f1)"
pd=$(grep -Rl "$envb" /storage/emulated/0/ramdump/classes_smali)
vivb="$(grep -m1 '\"'$vah'\"' strings.xml | cut -d '>' -f2 | cut -d '<' -f1)"
echo 'sed -i "s|\"'$envb'\"|\"'$vivb'\"|" '$pd'' >> 3.sh
done