#!/bin/bash
# export SDL_VIDEODRIVER=offscreen
# export SDL_AUDIODRIVER=dummy

timeout 16 dosbox-x --fastlaunch --nomenu --time-limit 10 --exit -c "mount c ." -c "c:" -c "cls" -c "dx-capture /a /o adplay -q loudness.lds"
cp -v capture/adplay_000.dro capture/0.dro
mv -v capture/adplay_000.dro capture/0.dro

for i in {1..10}
do
    echo "Capture $i"
    #capcommand="dx-capture /a /o adplay -q capture\\$(($i-1)).dro"
    capcommand="dx-capture /a /o adplay -q loudness.lds"
    echo $capcommand
    timeout 16 dosbox-x --fastlaunch --nomenu --time-limit 10 --exit -c "mount c ." -c "c:" -c "cls" -c "$capcommand"
    cp -v capture/adplay_000.dro capture/$i.dro
    mv -v capture/adplay_000.dro capture/$i.dro
done

# cp -v capture/adplay_000.wav capture/0.wav
# mv -v capture/adplay_000.wav capture/0.wav

# for i in {1..3}
# do
#     echo "Capture $i wav"
#     capcommand="dx-capture /a mpxplay capture\\$(($i-1)).wav"
#     echo $capcommand
#     timeout 16 dosbox-x --fastlaunch --nomenu --time-limit 10 --exit -c "mount c ." -c "c:" -c "cls" -c "$capcommand"
#     cp -v capture/mpxplay_000.wav capture/$i.wav
#     mv -v capture/mpxplay_000.wav capture/$i.wav
# done
