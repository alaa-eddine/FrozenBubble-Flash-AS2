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
 
class TextSprite
{
	private var _tfTarget:TextField;
	private var _mcContener:MovieClip;
	
	private var _sFont:String;
	private var _nSize:Number;
	private var _nColor:Number;
	
	function TextSprite(_x:Number, _y:Number, _text:String, _font:String, _size:Number, _color:Number, _index:Number, mcTarget:MovieClip)
	{
		
		if (_index < 0)
		{
			_index = mcTarget.getNextHighestDepth();
		}
		
		_mcContener = mcTarget.createEmptyMovieClip("mcContener" + _index, _index);
		_tfTarget = mcTarget.createTextField("tf", 10, _x, _y, 10, _size + 4);
		_tfTarget.autoSize = true;
		_tfTarget.wordWrap = false;
		_tfTarget.embedFonts = true;
		_tfTarget.selectable = false;
		_tfTarget.text = convertText(_text);
		
		_sFont = _font;
		_nSize = _size;
		_nColor = _color;
		
		formatText();
	}
	
	private function formatText():Void
	{
		var textFomat:TextFormat = new TextFormat();
		textFomat.font = _sFont;
		textFomat.size = _nSize;
		textFomat.color = _nColor;
		
		_tfTarget.setTextFormat(textFomat);
	}
	
	
	private function convertText(_label:String):String {

		var index = _label.indexOf(' ');
		while(index != -1) {
			_label = _label.substring(0, index) + '\u00A0' + _label.substring(index+1, _label.length);
			index = _label.indexOf(' ');	
		}
		return _label;
	}

	function setText(newText:String):Void
	{
		_tfTarget.text = newText;
		formatText();
	}

	function getText():String
	{
		return _tfTarget.text;
	}


	function setIndex(newIndex:Number):Number
	{
		_mcContener.swapDepths(newIndex);
		return _mcContener.getDepth();
	}

	function moveTo(_x, _y):Void
	{
		_tfTarget._x = _x;
		_tfTarget._y = _y;
	}

	function getX():Number
	{
		return _tfTarget._x;
	}

	function getY():Number
	{
		return _tfTarget._y;
	}

	function setSize(_width:Number, _height:Number):Void
	{
		_tfTarget._width = _width;
		_tfTarget._height = _height;
	}

	function remove():Void
	{
		_mcContener.removeMovieClip();
	}

	function setFont(_font:String):Void
	{
		_sFont = _font;
		formatText();
	}

	function setTextSize(_size:Number):Void
	{
		_nSize = _size;
		formatText();
	}

	function setColor(_color:Number):Void
	{
		_nColor = _color;
		formatText();
	}
}
