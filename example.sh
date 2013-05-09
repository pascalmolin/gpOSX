#!/bin/sh

# 1. compile

cd pari-2.5.3/

export READLINE=--with-readline=/usr/local/Cellar/readline/6.2.4
export PREFIX=--prefix=/Applications/PariGP.app/Contents/Resources
export CC=/usr/local/bin/gcc-4.7
make clean
./Configure $READLINE $PREFIX
make -j4 gp
make all
make install

cd ..

exit 0

# 2. fix links

sh fixinstall


#3. keep and distribute under .dmg

sh makedmg PariGP-2.5.3 /Applications/PariGP.app /Applications/

mv PariGP-2.5.3.dmg dmg-drag/


# 4. add data packages

sh makedmg elldata data/elldata /Applications/PariGP.app/Contents/Resources/share/pari
