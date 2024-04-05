
ORICUTRON_PATH="/mnt/c/Users/plifp/OneDrive/oric/oricutron_wsl/oricutron"
# mkdir build/bin/ -p
# cl65 -o build/bin/file -ttelestrat src/file.c
# cl65 -o 1000 -ttelestrat src/file.c --start-addr \$800
# cl65 -o 1256 -ttelestrat src/file.c --start-addr \$900
# deps/orix-sdk/bin/relocbin.py3 -o build/bin/file -2 1000 1256
cl65 -ttelestrat -I src/include -I libs/usr/include test/gethttp.c socket.lib libs/lib8/ch395-8.lib libs/lib8/inet.lib -o gethttp
cp gethttp $ORICUTRON_PATH/SDCARD/BIN/gethttp
cd $ORICUTRON_PATH
./oricutron
cd -

