 #
 #                 [[ Frozen-Bubble ]]
 #
 # Copyright (c) 2000-2007 Guillaume Cottenceau.
 # Flash sourcecode - Copyright (c) 2007 Mickael Foucaux.
 #
 # This code is distributed under the GNU General Public License 
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License
 # version 2, as published by the Free Software Foundation.
 # 
 # This program is distributed in the hope that it will be useful, but
 # WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License along
 # with this program; if not, write to the Free Software Foundation, Inc.,
 # 675 Mass Ave, Cambridge, MA 02139, USA.
 #
 #
 # Artwork:
 #    Alexis Younes <73lab at free.fr>
 #      (everything but the bubbles)
 #    Amaury Amblard-Ladurantie <amaury at linuxfr.org>
 #      (the bubbles)
 #
 # Soundtrack:
 #    Matthias Le Bidan <matthias.le_bidan at caramail.com>
 #      (the three musics and all the sound effects)
 #
 # Design & Programming:
 #    Guillaume Cottenceau <guillaume.cottenceau at free.fr>
 #      (design and manage the project, whole Perl sourcecode)
 #
 # JavaScript version:
 #    Glenn Sanson <glenn.sanson at free.fr>
 #      (whole JavaScript sourcecode, including JIGA classes 
 #             http://glenn.sanson.free.fr/v2/?select=jiga )
 #
 # Flash version :
 #	  Mickael Foucaux <mickael.foucaux at gmail.com>
 # 	  http://code.google.com/p/frozenbubbleflash/
 # 
 
set -e
echo "build game.xml"
cd game
./make.rb


echo "compilation..."
echo "..swfmill"
echo "... prepare lib_game.swf"
swfmill -v simple game.xml ../lib_game.swf
cd ..

cd loader
echo "... prepare lib_loader.swf"
swfmill -v simple loader.xml ../lib_loader.swf
cd ..

echo "..mtasc"
echo "... prepare loader.swf"
mtasc \
-v \
-swf lib_loader.swf \
-out loader.swf \
-version 8 \
-main Loader.as \
-cp /usr/share/mtasc/std8/ \
-cp /usr/share/mtasc/std/ \
-cp ./ \
-cp ./loader/classes/

echo "... prepare frozenBubble.swf"
mtasc \
-v \
-swf lib_game.swf \
-out frozenBubble.swf \
-version 8 \
-main Main.as \
-cp /usr/share/mtasc/std8/ \
-cp /usr/share/mtasc/std/ \
-cp ./ \
-cp ./game/classes/ 

flashplayer loader.swf
