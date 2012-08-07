/*
 *                 [[ Frozen-Bubble ]]
 *
 * Copyright (c) 2000-2007 Guillaume Cottenceau.
 * Flash sourcecode - Copyright (c) 2007 Mickael Foucaux.
 *
 * This code is distributed under the GNU General Public License 
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2, as published by the Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *
 * Artwork:
 *    Alexis Younes <73lab at free.fr>
 *      (everything but the bubbles)
 *    Amaury Amblard-Ladurantie <amaury at linuxfr.org>
 *      (the bubbles)
 *
 * Soundtrack:
 *    Matthias Le Bidan <matthias.le_bidan at caramail.com>
 *      (the three musics and all the sound effects)
 *
 * Design & Programming:
 *    Guillaume Cottenceau <guillaume.cottenceau at free.fr>
 *      (design and manage the project, whole Perl sourcecode)
 *
 * JavaScript version:
 *    Glenn Sanson <glenn.sanson at free.fr>
 *      (whole JavaScript sourcecode, including JIGA classes 
 *             http://glenn.sanson.free.fr/v2/?select=jiga )
 *
 * Flash version :
 *	  Mickael Foucaux <mickael.foucaux at gmail.com>
 * 	  http://code.google.com/p/frozenbubbleflash/
 * 
 */
 
class Main
{
	private var gameDepth:Number = 100;
	private var level:Number = 1;
	private var game:Game;
	
	public var MAX_LEVEL:Number = 7;

	public function Main(root:MovieClip)
	{
		var mcGame:MovieClip = root.createEmptyMovieClip("gameLevel", gameDepth);
		game = new Game(this, mcGame, level);
		game.startGame();
	}
	
	public function setState(id:String, options:Array):Void
	{
		var win:Boolean = Boolean(options[1]);
		level = Number(options[1]);
		game.startGame();
	}
	
	static function main(root:MovieClip):Void
	{
		var application = new Main(root);
	}
}

