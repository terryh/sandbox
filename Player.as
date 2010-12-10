package
{
	import org.flixel.*;


	public class Player extends FlxSprite
	{
		//[Embed(source="../../../data/spaceman.png")] private var ImgSpaceman:Class;
		[Embed(source="../data/player.png")] private var ImgPlayer:Class;
		[Embed(source="../data/bot.png")] protected var ImgBot:Class;
		[Embed(source="../data/robot.png")] private var ImgSpaceman:Class;
		[Embed(source="../data/jet.png")] protected var ImgJet:Class;
		[Embed(source="../data/jump.mp3")] private var SndJump:Class;
		[Embed(source="../data/land.mp3")] private var SndLand:Class;
		[Embed(source="../data/asplode.mp3")] private var SndExplode:Class;
		[Embed(source="../data/menu_hit_2.mp3")] private var SndExplode2:Class;
		[Embed(source="../data/hurt.mp3")] private var SndHurt:Class;
		[Embed(source="../data/jet.mp3")] protected var SndJet:Class;
		
		
		private var _jumpPower:int;
		private var _arrows:Array;
		private var _curArrow:uint;
		private var _arrowVel:int;
		private var _up:Boolean;
		private var _down:Boolean;
		private var _restart:Number;
		private var _cx:Number;
		private var _cy:Number;
		private var _shot:Boolean = false;
		private var _gibs:FlxEmitter;
		private var _targetpoint:FlxPoint;
		private var _circle:PlayerCircle;
		private var _bow:Bow;
		
		protected var _jets:FlxEmitter;

		
		protected var _timer:Number = 0;
		
		public function Player(X:int,Y:int,Arrows:Array,Gibs:FlxEmitter, Circle:PlayerCircle, B:Bow)
		{
			super(X,Y);
			//loadGraphic(ImgSpaceman,true,true,23,28);
			loadGraphic(ImgPlayer,true,true,40,40);
			_restart = 0;
			_circle = Circle;
			_bow = B;
			
			//bounding box tweaks
			width = 40;
			height = 40;
			antialiasing = true;
			//offset.x = 1;
			//offset.y = 1;
			_targetpoint = new FlxPoint(x+2/width, y+2/height);
			
			//basic player physics
			var runSpeed:uint = 80;
			drag.x = 1;
			drag.y = 1;
		
			//acceleration.y = 420; // gravity
			maxVelocity.x = runSpeed;
			maxVelocity.y = runSpeed;
			
			//animations
			addAnimation("idle_n", [0],30, false);
			addAnimation("idle_ne", [1],30, false);
			addAnimation("idle_e", [2],30, false);
			addAnimation("idle_se", [3],30, false);
			addAnimation("idle_s", [4],30, false);
			addAnimation("idle_sw", [5],30, false);
			addAnimation("idle_w", [6],30, false);
			addAnimation("idle_nw", [7],30, false);
			addAnimation("run_n", [8,9], 2);
			addAnimation("run_ne", [10,11], 4);
			addAnimation("run_nw", [12,13], 4);
			addAnimation("run_e", [14,15], 4);
			addAnimation("bow", [16], 30, false);
			
			//bullet stuff
			_arrows = Arrows;
			_curArrow = 0;
			_arrowVel = 360;
			
			//Gibs emitted upon death
			_gibs = Gibs;

			//Jet effect that shoots out from behind the bot
			//_jets = new FlxEmitter();
			//_jets.setRotation();
			//_jets.gravity = 0;
			//_jets.createSprites(ImgJet,15,0,false);

		}
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				_restart += FlxG.elapsed;
				if(_restart > 2)
					(FlxG.state as PlayState).reload = true;
				return;
			}
			// for rotate center
			_cx = x+width/2;
			_cy = y+height/2;
			
			// SET TARGET POINT
			var dx:Number = _targetpoint.x-_cx;
			var dy:Number = _targetpoint.y-_cy;
			var ds:Number = Math.sqrt(dx*dx + dy*dy);
			
			// only caculate da at bigger distance
			var da:Number = FlxU.getAngle(dx,dy);
			if(da < 0)
				da += 360;
			
			// MOVEMENT
			if (Math.abs(dx) >= 3 ||  Math.abs(dy) >= 3) 
			{
				_circle.rotating = true;
				if (Math.abs(dx) > Math.abs(dy)) 
				{
					if (dx  > 0) {
						play("run_e");
						x += drag.x;
					} else {
						play("run_e");
						x -= drag.x;
					}
				} 
				else if (Math.abs(dy) > Math.abs(dx)) 
				{
					if (dy  > 0) {
						play("run_n");
						y += drag.y
					} else {
						play("run_n");
						y -= drag.y
					}
				}
				else if (da > 247.5 && da < 292.5 ) {
					play("run_n");
					y -= drag.y;

				} else if (da > 292.5 && da < 337.5 ) {
					play("run_ne");
					x += drag.x;
					y -= drag.y;
				} else if ((da > 337.5 && da < 360) || (da >= 0 && da < 22.5) ) {
					play("run_e");
					x += drag.x;
				} else if (da > 22.5  && da < 67.5 ) {
					play("run_nw");
					x += drag.x;
					y += drag.y;
				} else if (da > 67.5 && da < 112.5 ) {
					play("run_n");
					y += drag.y;
				} else if (da > 112.5 && da < 157.5 ) {
					play("run_ne");
					x -= drag.x;
					y += drag.y;
				} else if (da > 157.5 && da < 202.5 ) {
					play("run_e");
					x -= drag.x;
				} else if (da > 202.5 && da < 247.5 ) {
					play("run_nw");
					x -= drag.x;
					y -= drag.y;
				}
			} else if (Math.abs(dx) < 3 &&  Math.abs(dy) < 3) 
			{
				// stop 
				acceleration.x = 0;
				acceleration.y = 0;
				_circle.rotating = false;
				
				if (da >= 247.5 && da < 292.5 ) {
					play("idle_n");
				} else if (da >= 292.5 && da < 337.5 ) {
					play("idle_ne");
				} else if ((da >= 337.5 && da < 360) || (da >= 0 && da < 22.5) ) {
					play("idle_e");
				} else if (da >= 22.5  && da < 67.5 ) {
					play("idle_se");
				} else if (da >= 67.5 && da < 112.5 ) {
					play("idle_s");
				} else if (da >= 112.5 && da < 157.5 ) {
					play("idle_sw");
				} else if (da >= 157.5 && da < 202.5 ) {
					play("idle_w");
				} else if (da >= 202.5 && da < 247.5 ) {
					play("idle_nw");
				}
			} 
			// END MOVEMENT
			
			if(FlxG.mouse.justPressed())
			{
				_targetpoint.x = _circle.x + _circle.width/2;
				_targetpoint.y = _circle.y + _circle.height/2;
			}

			// AIMING
			if(FlxG.mouse.pressed())
			{
				// aiming player
				// offset for bow
				//var shotpoint:FlxPoint = FlxPoint(x+width/2+5, y);  
				//dx = _cx - FlxG.mouse.x;
				//dy = _cy -FlxG.mouse.y;
				dx = FlxG.mouse.x - _cx;
				dy = FlxG.mouse.y - _cy;
				
				// mouse in circle
				if (Math.sqrt(dx*dx + dy*dy) < _circle.width/2) 
				{
					da = FlxU.getAngle(dx,dy);
					if(da < 0)
						da += 360;
					
					da= Math.round(da/10)*10; // step 10
					// aiming player
					angle = da;
					play('bow');
					// aiming bow
					// origin bow position
					var bow_cx:Number = _cx+width/2-_bow.width/2;
					var bow_cy:Number = _cy+3; // FIXME need shift
					var bowc:FlxPoint = FlxU.rotatePoint(bow_cx,bow_cy,_cx,_cy, da);
					_bow.reset(bowc.x-_bow.width/2, bowc.y-_bow.height/2);
					_bow.angle = da;
					_bow.visible = true;
					_bow.play('pull');
					_arrows[_curArrow].reset(bowc.x-_arrows[0].width/2, bowc.y-_arrows[0].height/2);
					_arrows[_curArrow].angle = da;
					_arrows[_curArrow].visible = true; 
				}
				else
				{
				// pressed mouse not in circle, clean up
					angle = 0;
					_bow.visible = false;
					_bow.angle = 0;
					_arrows[_curArrow].visible = false;
				}

			}
			// reset angle after release mouse
			if (FlxG.mouse.justReleased())
			{
				dx = _cx - FlxG.mouse.x;
				dy = _cy -FlxG.mouse.y;

				// mouse in circle
				if (Math.sqrt(dx*dx + dy*dy) < _circle.width/2) 
				{
					FlxG.log('just shot----');
					FlxG.log(_arrows[_curArrow].angle);
					var vx:Number = Math.cos(_arrows[_curArrow].angle*(Math.PI/180)) * 600; // arrow speed
					var vy:Number = Math.sin(_arrows[_curArrow].angle*(Math.PI/180)) * 600; 
					FlxG.log(vx + ','+vy);
					_arrows[_curArrow].shoot(vx, vy);
					_shot = true;
					_bow.play('release');
					_curArrow += 1;
				}
			}
			// finish release bow
			if ( _shot ) {
				//FlxG.log("Shot-->"+_shot);
				//FlxG.log(_bow.finished);
				if ( _bow.finished ) {
					_shot = false;
					angle = 0;
					_bow.visible = false;
					_bow.angle = 0;
				} else {
					_bow.play('release');
				}
				// check arrows
				if(_curArrow+1 >= _arrows.length)
					_curArrow = 0;
			}

			
			// logging 
			if (FlxG.debug ) 
			{
				if (_timer <= 0) _timer = 0;
				_timer += FlxG.elapsed;
				if (_timer > 1)
				{
					//FlxG.log(dx + ',' + dy + ','+_circle.rotating);
					//FlxG.log(FlxG.mouse.pressed());
					//FlxG.log("velocity=>"+velocity.x+","+velocity.y);
					//FlxG.log("acceleration=>"+acceleration.x+","+acceleration.y);
					_timer = 0;
				}
			}
				
			super.update();

			//Jammed, can't fire!
			/*
			 *if(flickering())
			 *{
			 *    if(FlxG.keys.justPressed("C"))
			 *        FlxG.play(SndJam);
			 *}
			 */
		}
		
		
		override public function hurt(Damage:Number):void
		{
			Damage = 0;
			if(flickering())
				return;
			FlxG.play(SndHurt);
			flicker(1.3);
			if(FlxG.score > 1000) FlxG.score -= 1000;
			//if(velocity.x > 0)
				//velocity.x = -maxVelocity.x;
			//else
				//velocity.x = maxVelocity.x;
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			solid = false;
			FlxG.play(SndExplode);
			FlxG.play(SndExplode2);
			super.kill();
			flicker(-1);
			exists = true;
			visible = false;
			FlxG.quake.start(0.005,0.35);
			FlxG.flash.start(0xffd8eba2,0.35);
			if(_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true,0,50);
			}
		}
	}
}
