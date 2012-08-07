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
 
class Loader
{
	var mcRoot:MovieClip;
	var myTextField:TextField;
	var i:Number;
	var myLoader:MovieClipLoader;
	
	var red_bubble:MovieClip;
	var orange_bubble:MovieClip;
	var green_bubble:MovieClip;
	
	public function Loader(name:String)
	{
		mcRoot = _root.createEmptyMovieClip("loading", 10);
		mcRoot.createTextField("myTextField", 10, 0, 0, 640, 60);
		myTextField = mcRoot["myTextField"];
		myTextField.text = "loading...";
		myTextField.selectable = false;
		draw(mcRoot.createEmptyMovieClip("gfx", 20));
		
		var myClip:MovieClip = mcRoot.createEmptyMovieClip("frozenBubble", 30);
		
		myLoader = new MovieClipLoader();

		myLoader.addListener(this);
		myLoader.loadClip(name, myClip);
		
		i = setInterval(this, "loadProgess", 100, myLoader, myClip);
	}
	
	public function draw(target:MovieClip):Void
	{
		var mcBack:MovieClip = target.createEmptyMovieClip("mcBack", 0);
		
		var rectangle:MovieClip = mcBack.createEmptyMovieClip("rectangle", 10);
		rectangle.beginFill(0x000000);
		rectangle.moveTo(0, Stage.height / 6);
		rectangle.lineTo(Stage.width, Stage.height / 6);
		rectangle.lineTo(Stage.width, (Stage.height / 6) * 5);
		rectangle.lineTo(0, (Stage.height / 6) * 5);
		rectangle.lineTo(0, Stage.height / 6);
		rectangle.endFill();
		
		var mcGfx:MovieClip = target.createEmptyMovieClip("gfx", 10);
		
		var tux:MovieClip = mcGfx.attachMovie("tux", "tux", 20);
		
		var mcBubbles:MovieClip = mcGfx.createEmptyMovieClip("gfx", 30);
		red_bubble = mcBubbles.attachMovie("red_bubble", "red_bubble", 20);
		orange_bubble = mcBubbles.attachMovie("orange_bubble", "orange_bubble", 30);
		green_bubble = mcBubbles.attachMovie("green_bubble", "green_bubble", 40);
		
		mcBubbles._y = tux._y + tux._width;
		orange_bubble._x = red_bubble._width + 10;
		green_bubble._x = orange_bubble._x + orange_bubble._width + 10;
		
		tux._x = (Stage.width - tux._width) / 2;
		mcBubbles._x = (Stage.width - mcBubbles._width) / 2;
		mcGfx._y = (Stage.height - mcGfx._height) / 2;
		
		red_bubble._alpha = 10;
		orange_bubble._alpha = 10;
		green_bubble._alpha = 10;
	}
	
	public function refresh(percent:Number):Void
	{
		if (percent - 0 > 0)
		{
			red_bubble._alpha = 10 + percent * 3;
		}
		if (percent - 30 > 0)
		{
			orange_bubble._alpha = 10 + percent * 2 - 30;
		}
		if (percent - 60 > 0)
		{
			green_bubble._alpha = 10 + percent - 60;
		}
	}
	
	public function loadProgess(mcLoader:MovieClipLoader, image:MovieClip):Void
	{
		var progress:Object = mcLoader.getProgress(image);
		var percent:Number = Math.round(progress.bytesLoaded / progress.bytesTotal * 100);
		myTextField.text = "loading...\n" + "\tbytes loaded: " + progress.bytesLoaded + " of " + progress.bytesTotal + "\n" + percent + " %";
		refresh(percent);
	}
	
	public function onLoadInit ():Void
	{
		clearInterval(i);
		myLoader.removeListener(this);
		myTextField.text = "finish";
	}
	
	static function main():Void
	{
		if (_root.target == undefined)
		{
			_root.target = "frozenBubble.swf"
		}
		var application = new Loader(_root.target);
	}
}