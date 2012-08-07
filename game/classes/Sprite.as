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
 
class Sprite
{
	private var _mcParent:MovieClip;
	private var _mcSprite:MovieClip;
	
	private var _idImg:String;
	
	public function Sprite(_x:Number, _y:Number, _imgSrc:String, _index:Number, mcTarget:MovieClip)
	{
		if (_index < 0)
		{
			_index = mcTarget.getNextHighestDepth();
		}
		
		_mcParent = mcTarget;
		_idImg = _imgSrc;
		
		_mcSprite = mcTarget.attachMovie(_imgSrc, _imgSrc + _index.toString(), _index);
		_mcSprite._x = _x;
		_mcSprite._y = _y;
	}
	
	function setSrc(newSrc):Void
	{
		var index:Number = _mcSprite.getDepth()
		var nX:Number = _mcSprite._x;
		var nY:Number = _mcSprite._y;
		_mcSprite = _mcParent.attachMovie(newSrc, newSrc + index.toString(), index);
		_mcSprite._x = nX;
		_mcSprite._y = nY;
	}

	function getSrc():String
	{
		return _idImg;
	}

	function setIndex(newIndex:Number):Number
	{
		_mcSprite.swapDepths(newIndex);
		return _mcSprite.getDepth();
	}

	function moveTo(_x:Number, _y:Number):Void
	{
		_mcSprite._x = _x;
		_mcSprite._y = _y;
	}

	function getX():Number {
		return _mcSprite._x;
	}

	function getY():Number {
		return _mcSprite._y;
	}

	function setSize(_width:Number, _height:Number):Void {
		_mcSprite._width = _width;
		_mcSprite._height = _height;
	}

	function remove():Void {
		_mcSprite.removeMovieClip();
	}
}
