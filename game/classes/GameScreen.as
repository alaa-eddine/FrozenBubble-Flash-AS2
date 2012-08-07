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
 
class GameScreen
{
	private var CHECK_NEXT_TURN:Number;
	private var PART_OF_SET:Number;
	private var LINKED_TO_TOP:Number;

	private var STATE_RUNNING:Number;
	private var STATE_WON:Number;
	private var STATE_LOST:Number;

	private var launchIndex:Number;
	private var launcher:Sprite;

	private var dirX:Number;
	private var dirY:Number;
	private var realX:Number;
	private var realY:Number;
	
	private var bubbles:Array;
	private var bubSprites:Array;
	private var bubCount:Array;
	private var checkBalls:Array;
	private var bubFalling:Array;

	private var nbBalls:Number;
	private var removeCheck:Number;
	private var removeCount:Number;

	private var fireBubble:Sprite;
	private var fireColor:Number;
	private var nextBubble:Sprite;
	private var nextColor:Number;
	private var runningBubble:Sprite;
	private var runningColor:Number;

	private var penguin:Sprite;
	private var penguinIndex:Number;
	private var waitCount:Number;
	private var waitDir:Number;

	private var fired:Boolean;
	
	private var compressor:Number;
	private var compressorFall:Number;
	private var compressorMain:Sprite;
	private var compressorAlt:Sprite;

	private var flashSprite:Array;
	private var flashIndex:Number;

	private var gameState:Number;
	private var endSequence:Number;

	private var hurry:Sprite;
	private var hurryTimer:Number;

	private var stick:Sprite;
	private var stickIndex:Number;

	private var levelIndex:Number;

	public var life:Number;
	private var lifeSprite:Array;
	private var lifeIndex:Array;

	private var timer:Number;
	
	

	// Colorblind
	private var cb:String;

	// Details
	private var details:Number;

	// Level data
	private var currentLevel:String;
	private var nextLevel:String;
	private var readyToLoad:Boolean;
	
	
	////////// new variables /////
	private var currentGame:Game;
	private var currentKey:Number;

	/*
	* GameScreen
	* - �ran de jeu
	* @mcTarget : MovieClip sur lequel l'�ran de jeu sera affich�
	* 
	* init :
	* - construit une nouvelle partie
	* 
	* run :
	* - boucle principale du jeu
	*/
	public function GameScreen(currentGame:Game, currentLevel:String, nextLevel:String, levelIndex:Number, life:Number)
	{
		CHECK_NEXT_TURN = 1;
		PART_OF_SET = 2;
		LINKED_TO_TOP = 3;

		STATE_RUNNING = 1;
		STATE_WON = 2;
		STATE_LOST = 3;
		
		this.levelIndex = levelIndex;
		this.life = life;
		timer = 0;
		
		this.currentLevel = currentLevel;
		this.nextLevel = nextLevel;
		
		this.currentGame = currentGame;
	}
	
	public function init() {
		// Init vars
		if (currentGame.reset) {
			life = 4;
			levelIndex = 0;

			currentGame.reset = false;
		}

		details = currentGame.details;

		launchIndex = 30;
		fired = false;

		waitCount = 0;
		waitDir = 1;

		compressor = 0;
		compressorFall = 0;

		// Set background
		currentGame.setBackground('back_one_player');

		// Init penguin
		penguin = new Sprite(404, 420, 'anim20', 1, currentGame.mcPlayer);
		penguinIndex = 20;

		// Init bubbles
		if (currentGame.colorBlind) {
			cb = 'colourblind-';
		}
		else {
			cb = '';
		}

		bubbles = new Array();
		bubSprites = new Array();

		checkBalls = new Array();
		bubCount = new Array();

		bubFalling = new Array();

		nbBalls = 0;

		for (var i = 1; i <= 8; i++) {
			bubCount[i] = 0;
		}

		if (!currentLevel) {
			currentLevel = currentGame.first_level();
		}
		
		if (!nextLevel) {
			nextLevel = currentGame.getLevel(levelIndex + 1);
		}

		
		var chaine:String = "";
		for (var i = 0; i < 8; i++) {
			bubbles[i] = new Array();
			bubSprites[i] = new Array();

			checkBalls[i] = new Array();
			for (var j = 0; j < 13; j++) {
				var sColor:String = currentLevel.charAt(i + j * 8);
				var nColor:Number = Number(sColor);
				if (isNaN(nColor))
				{
					nColor = 0;
				}
				bubbles[i][j] = nColor;
				checkBalls[i][j] = 0;
				
				if (nColor != 0)
				{
					// Draw bubble
					bubSprites[i][j] = 
						new Sprite(
							190 + i * 32 - (j % 2) * 16, 
							44 + j * 28, 
							'bubble-' + cb + sColor, 
							-3,
							currentGame.mcStaticsBubbles
						);
					bubCount[bubbles[i][j]]++;

					nbBalls++;
				}
			}
		}
		
		// Init nextBall
		nextColor = nextBall();
		nextBubble = new Sprite(302, 440, 'bubble-' + cb + nextColor, -1, currentGame.mcActiveBubble);	

		fireColor = nextBall();
		fireBubble = new Sprite(302, 390, 'bubble-' + cb + fireColor, -1, currentGame.mcActiveBubble);

		// Init launcher
		var bubbleLaunch:Sprite = launcher = new Sprite(268, 356, 'launcher30', -2, currentGame.mcStaticsBubbles);

		// Init compressor
		compressorMain = new Sprite(192, -7, 'compressor_main', -2, currentGame.mcStaticsBubbles);

		// Init lives
		lifeSprite = new Array();
		lifeIndex = new Array();

		for (var i = 0; i < life; i++) {
			if (details > 2) {
				lifeIndex[i] = ((i * 8) % 30) + 1;
				lifeSprite[i] = new Sprite(6 + i * 40, 436, 'life' + lifeIndex[i], -2, currentGame.mcForeground);
			}
			else {
				lifeSprite[i] = new Sprite(6 + i * 40, 436, 'life20', -2, currentGame.mcForeground);
			}
		}

		gameState = STATE_RUNNING;
		endSequence = 0;
		
		var ts1 = new TextSprite(36, 101, 'Level ' + (levelIndex + 1), 'Arial', 20, 0x000000, -1, currentGame.mcForeground);
		var ts2 = new TextSprite(35, 100, 'Level ' + (levelIndex + 1), 'Arial', 20, 0xFFFFFF, -2, currentGame.mcForeground);

		hurryTimer = 0;
		if (hurry) {
			hurry.remove();
			hurry = null;
		}

		timer = 0;
		readyToLoad = false;
	}
	
	function nextBall():Number
	{
		var color:Number = 0;
		
		do {
			color = Math.floor(Math.random() * 8) + 1;
		}		
		while (bubCount[color] == 0);
		
		return color;
	}
	
	private function onKeyUp():Void
	{
		currentKey = -1;
	}

	private function onKeyDown():Void
	{
		currentKey = Key.getCode();
	}	
		
	function run() {
		if (gameState != STATE_RUNNING) {
			//runWon();
			if (gameState == STATE_WON) {
				runWon();
			}
			else {
				runLost();
			}
			return;
		}
		else {
			// STATE_RUNNING
			timer++;
		}
		
		var checkKey = currentKey;
		if (hurryTimer > 820) {
			checkKey = 38;
		}

		switch(checkKey) {
			case Key.LEFT:
				if (launchIndex > 1) {
					launchIndex--;
					launcher.setSrc('launcher' + launchIndex);
				}

				if (penguinIndex > 20) {
					penguinIndex = 20;
					penguin.setSrc('anim20');
				}
				else if (penguinIndex > 1) {
					penguinIndex--;
					penguin.setSrc('anim' + penguinIndex);
				}
			
				waitCount = 0;
				waitDir = 1;
			break;
			case Key.RIGHT:
				if (launchIndex < 59) {
					launchIndex++;
					launcher.setSrc('launcher' + launchIndex);
				}

				if (penguinIndex < 50) {
					penguinIndex = 50;
					penguin.setSrc('anim50');
				}
				else if (penguinIndex < 71) {
					penguinIndex++;
					penguin.setSrc('anim' + penguinIndex);
				}

				waitCount = 0;
				waitDir = 1;
			break;
			case Key.SHIFT:
			case Key.UP:
				if (!fired) {
					fired = true;

					//currentGame.playSound('content_fb/snd/launch.wav');

					//compressorFall++;
					penguinIndex = 21;
					penguin.setSrc('anim21');

					waitCount = 0;
					waitDir = 1;

					runningColor = fireColor;
					runningBubble = new Sprite(302, 390, 'bubble-' + cb + runningColor, -3, currentGame.mcActiveBubble);
					fireColor = nextColor;
					fireBubble.setSrc('bubble-' + cb + fireColor);
					nextColor = nextBall();
					nextBubble.setSrc('bubble-' + cb + nextColor);

					dirX = Math.cos(launchIndex * Math.PI / 60) * -8;
					dirY = Math.sin(launchIndex * Math.PI / 60) * -8;
					realX = 302;
					realY = 390;
					
					// Hurry
					hurryTimer = 0;
					if (hurry) {
						hurry.remove();
						hurry = null;
					}
				}
			// No break
			default:
				if (penguinIndex < 20) {
					penguinIndex++;
					penguin.setSrc('anim' + penguinIndex);
				}
				else if (penguinIndex > 50) {
					penguinIndex--;
					penguin.setSrc('anim' + penguinIndex);
				}
				else if (penguinIndex == 20 || penguinIndex == 50) {
					// Wait
					waitCount += waitDir;

					if (waitCount == 97) {
						waitDir = -1;
					}
					else if (waitCount == 1 && waitDir == -1) {
						waitDir = 1;
					}
					if (waitCount > 20) {
						penguin.setSrc('wait' + (waitCount - 20));
					}
				}
				else {
					penguinIndex++;
					penguin.setSrc('anim' + penguinIndex);
				}
			break;
		}


		// Running bubble
		if (fired) {
			controlBall();

			if (gameState == STATE_WON) {
				// Store data
				currentGame.level = levelIndex + 1;
				currentGame.timer = currentGame.timer + timer;
			}
		}

		
		// Compressor
		if (compressorFall == 10 && !fired && gameState == STATE_RUNNING) {
		//	currentGame.playSound('content_fb/snd/newroot_solo.wav');

			var c = new Sprite(224, -5 + compressor * 28, 'compressor_ext', -1, currentGame.mcStaticsBubbles);

			compressor++;
			compressorFall = 0;

			compressorMain.moveTo(192, -7 + 28 * compressor);
			for (var i = 0; i < 8; i++) {
				for (var j = 0; j < 12; j++) {

					if (bubSprites[i][j]) {
						bubSprites[i][j].moveTo(
							190 + i * 32 - (j % 2) * 16,
							44 + (j + compressor) * 28);
					}
				}
			}

			// Check game lost
			for (var i = 0; i < 8; i++) {
				if (bubbles[i][12 - compressor] != 0) {
					gameState = STATE_LOST;
				}
			}
		}

		// Flash
		if ((compressorFall == 8 || compressorFall == 9) && gameState == STATE_RUNNING && details > 1) {
			flashIndex++;
			var checkFlash = flashIndex;
			if (compressorFall == 8) {
				checkFlash = (flashIndex >> 1) + 1;
			}

			if (checkFlash > 15) {
				flashIndex = 1;
				checkFlash = 1;
			}
			
			// Remove old flashing
			for (var i in flashSprite) {
				flashSprite[i].remove();
			}
			flashSprite = new Array();
	
			// Add new flashing
			for (var y = 1 - (checkFlash % 2); y < 13; y += 2) {
				var x = (checkFlash >> 1);

				if (bubSprites[x][y]) {
					flashSprite[flashSprite.length] = 
						new Sprite(190 + x * 32 - (y % 2) * 16, 
							44 + y * 28 + compressor * 28, 
							'bubble_prelight', 
							-3,
							currentGame.mcActiveBubble);
				}
			}
		}

		if (compressorFall == 8 && details == 1 && compressorAlt == null) {
			compressorAlt = new Sprite(29, 7, 'compressor_alt', -1, currentGame.mcStaticsBubbles);
		}

		if (compressorFall < 8 && details == 1 && compressorAlt != null) {
			compressorAlt.remove();
			compressorAlt = null;
		}

		// Stick
		if (stick != null) {
			stickIndex++;

			if (stickIndex >= 8) {
				stick.remove();
				stick = null;
			}
			else {
				stick.setSrc('stick_effect_' + stickIndex);
			}
		}

		// Falling balls
		fallingBubbles();

		// Hurry
		if (!fired) {
			hurryTimer++;

			if (hurryTimer >= 600) {
				if ((hurryTimer % 50) == 0 && !hurry) {
					hurry = new Sprite(196, 155, 'hurry_p1', -10, currentGame.mcForeground);
					
					//currentGame.playSound('content_fb/snd/hurry.wav');
				}
				else if ((hurryTimer % 50) == 25 && hurry) {
					hurry.remove();
					hurry = null;
				}
			}
		}

		// Life manager
		if (details > 2) {
			showLife();
		}

		// Reset key
		if (gameState != STATE_RUNNING) {
			currentKey = -1;
		}
	}
	
	function fallingBubbles() {
		for (var i=0 ; i < bubFalling.length ; i++) {
			bubFalling[i].fY += 0.5;

			bubFalling[i].moveTo(
					bubFalling[i].getX() + bubFalling[i].fX,
					bubFalling[i].getY() + bubFalling[i].fY
				);

			if (bubFalling[i].getY() > 500) {
				bubFalling[i].remove();
				bubFalling.splice(i, 1);
				i--;
			}
		}
	}
	
	function showLife() {
		for (var i = 0; i < life; i++) {
			lifeIndex[i]++;
			if (lifeIndex[i] > 30) {
				lifeIndex[i] = 1;
			}

			if (lifeSprite[i]) {
				lifeSprite[i].setSrc('life' + lifeIndex[i]);
			}
		}
	}
	
	function runWon() {
		if (currentKey == Key.ENTER || currentKey == Key.SPACE || readyToLoad) {
			if (nextLevel) {
				currentKey = -1;
				levelIndex++;

				/*if (nextLevel == 'COMPLETE') {
					currentGame.setScreen('scores');
					//fin du jeu
				}
				else {
					currentLevel = nextLevel;
					nextLevel = null;
					currentGame.setScreen('fb');
				}*/
				currentGame.gameOver(true);
				return;
			}
			else {
				if (!readyToLoad) {
					var sp2 = new Sprite(201, 30, 'loading', -10, currentGame.mcForeground);
					readyToLoad = true;
				}
			}
		}

		if (endSequence == 0) {
			//currentGame.playSound('content_fb/snd/applause.wav');

			var sp = new Sprite(153, 184, 'win_panel_1player', -10, currentGame.mcForeground);
		}

		endSequence++;
		if (endSequence > 68) {
			endSequence = 1;
		}

		penguin.setSrc('win' + endSequence);

		// Falling balls
		fallingBubbles();

		// Life
		if (details > 2) {
			showLife();
		}
	}
	
	function runLost() {
		if (currentKey == Key.ENTER || currentKey == Key.SPACE || readyToLoad) {
			if (nextLevel || life <= 0) {
				currentKey = -1;
				/*if (life > 0) {
					currentGame.setScreen('fb');
				}
				else {
					currentLevel = null;
					nextLevel = null;
					currentGame.setScreen('scores');
				}*/
				currentGame.gameOver(false);
				return;
			}
			else {
				if (!readyToLoad) {
					var loading = new Sprite(201, 30, 'loading', -10, currentGame.mcForeground);
					readyToLoad = true;
				}				
			}
		}


		if (endSequence == 0) {
			//currentGame.playSound('lose');
			var lose = new Sprite(145, 163, 'lose_panel', -10, currentGame.mcForeground);

			life--;
			lifeSprite[life].fY = 0;
		}

		// Iced effect
		if (endSequence < 104) {
			var iceX = endSequence % 8;
			var iceY = Math.floor(endSequence / 8);

			if (bubbles[iceX][iceY] != 0) {
				var b = new Sprite(189 + iceX * 32 - (iceY % 2) * 16, 
					43 + (iceY + compressor) * 28, 
					'bubble_lose', 
					-4,
					currentGame.mcActiveBubble);
			}
		}

		if (endSequence < 158) {
			endSequence++;
			penguin.setSrc('loose' + endSequence);

		}

		// Falling balls
		fallingBubbles();

		// Life
		if (details > 2) {
			showLife();
		}
		if (lifeSprite[life]) {
			// falling lost life

			lifeSprite[life].fY += 0.5;
			lifeSprite[life].moveTo(lifeSprite[life].getX(),
					lifeSprite[life].getY() + lifeSprite[life].fY);

			if (lifeSprite[life].getY() > 500) {
				lifeSprite[life].remove();
				lifeSprite.splice(life, 1);
			}
		}
	}

	function controlBall() {
		realX += dirX;
		realY += dirY;

		if (realX < 190 || realX > 414) {
			dirX = -dirX;
			realX += dirX;

	//		currentGame.playSound('content_fb/snd/rebound.wav');
		}

		// Check if collision occured
		var collision:Boolean = false;
		
		var topY:Number = Math.floor(((realY - 44) / 28) - compressor);
		var topX:Number = Math.floor((realX - 190 + (topY % 2) * 16) / 32);
		var firstPart:Boolean = false;
		
		if (topY <= (12 - compressor)) {
			
			// Check < 0
			if (realY < (44 + 28 * compressor)) {
				topY = -1;
				collision = true;
			}
			
			// Check neighbors
			if (!collision) {
				collision = collide(topX, topY);
			}
			if (!collision) {
				collision = collide(topX + 1, topY);
			}
			
			if (!collision) {
				collision = collide(topX + 1 - (topY % 2), topY + 1);
			}
			
			if (!collision) {
				firstPart = (realX - (topX * 32 - (topY % 2) * 16 + 190)) < 16;
				if (firstPart) {
					collision = collide(topX - (topY % 2), topY + 1);
				}
				else {
					collision = collide(topX + 2 - (topY % 2), topY + 1);
				}
			}
		}

		var posY:Number;

		if (collision) {

			fired = false;
			nbBalls++;

			if (topY < 0) {
				topY = 0;
			}
			
			var posX = 0;
			posY = 0;
			
			// Find min distance
			var min:Number = 0;
			var minVal:Number = getDistance(topX, topY);
			var cmpMinVal:Number = getDistance(topX + 1, topY);
			if (cmpMinVal < minVal) {
				min = 1;
				minVal = cmpMinVal;
			}
			cmpMinVal = getDistance(topX + 1 - (topY % 2), topY + 1);
			if (cmpMinVal < minVal) {
				min = 2;
				minVal = cmpMinVal;
			}
			if (firstPart) {
				cmpMinVal = getDistance(topX - (topY % 2), topY + 1);
			}
			else {
				cmpMinVal = getDistance(topX + 2 - (topY % 2), topY + 1);
			}
			if (cmpMinVal < minVal) {
				min = 3;
				minVal = cmpMinVal;
			}
			
			// Position ball on it
			switch(min) {
			case 0:
				posX = topX;
				posY = topY;
				break;
			case 1:
				posX = topX + 1;
				posY = topY;
				break;
			case 2:
				posX = topX + 1 - (topY % 2);
				posY = topY + 1;
				break;
			case 3:
				if (firstPart) {
					posX = topX - (topY % 2);
				}
				else {
					posX = topX + 2 - (topY % 2);
				}
				posY = topY + 1;
				break;
			}

			// Reposition
			realX = 190 + posX * 32 - (posY % 2) * 16;
			realY = 44 + (posY + compressor) * 28;

			bubbles[posX][posY] = runningColor;
			bubSprites[posX][posY] = runningBubble;
			bubCount[runningColor]++;
			checkBalls[posX][posY] = CHECK_NEXT_TURN;
			removeCheck = 1;
			removeCount = 0;
		}


		runningBubble.moveTo(Math.floor(realX), Math.floor(realY));

		if (collision) {

			// Check remove

			while (removeCheck != 0) {
				for (var j=0 ; j<13 ; j++) {
					for (var i=0 ; i<8 ; i++) {
						if (checkBalls[i][j] == CHECK_NEXT_TURN) {
							if (bubbles[i][j] == runningColor) {
								checkBalls[i][j] = PART_OF_SET;
								removeCount++;
								
								// Check neighbors
								checkNeighbors(i, j, checkBalls);
							}
							else {
								checkBalls[i][j] = 0; // No action
							}
							
							removeCheck--;
						}
					}
				}
			}
			
			if (removeCount >= 3) {

				//currentGame.playSound('content_fb/snd/destroy_group.wav');

				// Ball set is removed
				for (var i=0 ; i<8 ; i++) {
					if (bubbles[i][0] != 0 && checkBalls[i][0] != PART_OF_SET) {
						checkBalls[i][0] = CHECK_NEXT_TURN;
						removeCheck++;
					}
				}
				
				while (removeCheck != 0) {
					for (var j=0 ; j<13 ; j++) {
						for (var i=0 ; i<8 ; i++) {
							if (checkBalls[i][j] == CHECK_NEXT_TURN) {
								checkBalls[i][j] = LINKED_TO_TOP;
								removeCheck--;	
								
								// Check neighbors
								checkNeighbors(i, j, checkBalls);
							}
						}
					}
				}
				
				// Physically remove balls
				for (var j=0 ; j<13 ; j++) {
					for (var i=0 ; i<8 ; i++) {
						if (bubbles[i][j] != 0 
							&& (checkBalls[i][j] == 0 || checkBalls[i][j] == PART_OF_SET)) {
							
							//addFallingBall(i, j, bubbles[i][j]);
							
							bubCount[bubbles[i][j]]--;
							bubbles[i][j] = 0;
							
							// Set falling values
							bubSprites[i][j].fX = (Math.random() * 8 - 4);
							bubSprites[i][j].fY = -5;
							bubSprites[i][j].setIndex(5);
							bubFalling[bubFalling.length] = bubSprites[i][j];
							
							bubSprites[i][j] = null;

							//removing++;
							nbBalls--;
						}		

						checkBalls[i][j] = 0;
					}
				}

				if (nbBalls == 0) {
					gameState = STATE_WON;
				}
			}
			else {
				//currentGame.playSound('content_fb/snd/stick.wav');

				for (var j=0 ; j<13 ; j++) {
					for (var i=0 ; i<8 ; i++) {
						checkBalls[i][j] = 0;
					}
				}

				if ((posY + compressor) >= 12) {
					gameState = STATE_LOST;
				}

				if (gameState == STATE_RUNNING) {
					if (compressorFall == 9) {
						stick = new Sprite(Math.floor(realX), Math.floor(realY) + 28, 'stick_effect_0', -3, currentGame.mcStaticsBubbles);
					}
					else {
						stick = new Sprite(Math.floor(realX), Math.floor(realY), 'stick_effect_0', -3, currentGame.mcStaticsBubbles);
					}

					stickIndex = -1;
				}
			}

			compressorFall++;
			// Flash
			if (compressorFall >= 8) {
				if (flashSprite) {
					for (var i:String in flashSprite) {
						flashSprite[i].remove();
					}
				}
				flashSprite = new Array();
				flashIndex = 0;
			}
		}
	}
	
	function collide(x:Number, y:Number):Boolean
	{
		if (y < 0 || y > 12 || x < 0 || x >= 8) {
			return false;
		}
	
		if (bubbles[x][y] == 0) {
			return false;
		}
				
		return getDistance(x, y) < 784;
	}

	function getDistance(x:Number, y:Number):Number
	{
		if (y < 0 || y > 12 || x < 0 || x >= 8) {
			return 1000;
		}
		
		var vX:Number = x * 32 - (y % 2) * 16 + 190;
		var vY:Number = (y + compressor) * 28 + 44;
		
		vX -= realX;
		vY -= realY;
		
		return (vX * vX + vY * vY);
	}
	
	function checkNeighbors(x:Number, y:Number):Void {
		if (x > 0) {
			changeState(x-1, y, checkBalls);
		}
		
		if (x < 7) {
			changeState(x+1, y, checkBalls);
		}
		
		if (y > 0) {
			changeState(x, y-1, checkBalls);
			if (y % 2 == 0) {
				if (x < 7) {
					changeState(x+1, y-1, checkBalls);
				}
			}
			else {
				if (x > 0) {
					changeState(x-1, y-1, checkBalls);
				}				
			}
		}
		
		if (y < 11) {
			changeState(x, y+1, checkBalls);
			if (y % 2 == 0) {
				if (x < 7) {
					changeState(x+1, y+1, checkBalls);
				}
			}
			else {
				if (x > 0) {
					changeState(x-1, y+1, checkBalls);
				}				
			}
		}
	}
	
	function changeState(x:Number, y:Number):Void {
		if (checkBalls[x][y] == 0 && bubbles[x][y] != 0) {
			checkBalls[x][y] = CHECK_NEXT_TURN;
			removeCheck++;
		}
	}
}
