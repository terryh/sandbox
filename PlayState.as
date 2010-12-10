package
{
	import flash.events.*;

	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source="../data/tech_tiles.png")] protected var ImgTech:Class;
		[Embed(source="../data/dirt_top.png")] protected var ImgDirtTop:Class;
		[Embed(source="../data/dirt.png")] protected var ImgDirt:Class;
		//[Embed(source="../data/grass800.jpg")] protected var ImgBack:Class;
		[Embed(source="../data/back.jpg")] protected var ImgBack:Class;
		//[Embed(source="3dback.jpg")] protected var ImgBack:Class;
		[Embed(source="../data/notch.png")] protected var ImgNotch:Class;
		[Embed(source="../data/mode.mp3")] protected var SndMode:Class;
		[Embed(source="../data/rocket.mp3")] protected var SndRocket:Class;
		[Embed(source="../data/countdown.mp3")] protected var SndCount:Class;
		[Embed(source="../data/gibs.png")] private var ImgGibs:Class;
		[Embed(source="../data/spawner_gibs.png")] private var ImgSpawnerGibs:Class;
		[Embed(source="../data/cursor.png")] protected var ImgCursor:Class;
		
		//major game objects
		protected var _back:FlxSprite;
		protected var _blocks:FlxGroup;
		protected var _arrows:FlxGroup;
		protected var _decorations:FlxGroup;
		protected var _bots:FlxGroup;
		protected var _spawners:FlxGroup;
		protected var _botBullets:FlxGroup;
		
		protected var _littleGibs:FlxEmitter;
		protected var _bigGibs:FlxEmitter;

		protected var _bot:Bot;
		protected var _player:Player;
		protected var _circle:PlayerCircle;
		protected var _bow:Bow;
		
		public var reload:Boolean;
		
		//meta groups, to help speed up collisions
		protected var _objects:FlxGroup;
		protected var _enemies:FlxGroup;
		
		// hud
		protected var _score:FlxText;
		protected var _score2:FlxText;
		
		override public function create():void
		{
			//FlxG.mouse.hide();
			reload = false;
			
			//get the gibs set up and out of the way
			_littleGibs = new FlxEmitter();
			_littleGibs.delay = 3;
			_littleGibs.setXSpeed(-80,80);
			_littleGibs.setYSpeed(-80,80);
			//_littleGibs.setRotation(-720,-720);
			_littleGibs.createSprites(ImgGibs,100,10,true,0.5,0.65);
			_littleGibs.gravity = 0;
			_bigGibs = new FlxEmitter();
			_bigGibs.setXSpeed(-150,150);
			_bigGibs.setYSpeed(-150,150);
			//_bigGibs.setRotation(-720,-720);
			_bigGibs.createSprites(ImgSpawnerGibs,50,20,true,0.5,0.35);
			_bigGibs.gravity = 0;

		
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			//level generation needs to know about the spawners (and thusly the bots, players, etc)
			_blocks = new FlxGroup();
			_arrows = new FlxGroup();
			
			_decorations = new FlxGroup();
			_bots = new FlxGroup();
			_botBullets = new FlxGroup();
			_spawners = new FlxGroup();
			
			// background
			_back = new FlxSprite(0,0,ImgBack);
			add(_back);
			
			// build block
			var b:FlxTileblock;
			b = new FlxTileblock(0,0,800,16);
			b.loadGraphic(ImgTech);
			_blocks.add(b);
			add(_blocks)
			
			b = new FlxTileblock(0,16,16,800-16);
			b.loadGraphic(ImgTech);
			_blocks.add(b);
			
			b = new FlxTileblock(800-16,16,16,800-16);
			b.loadGraphic(ImgTech);
			_blocks.add(b);
			
			b = new FlxTileblock(16,800-24,800-32,8);
			b.loadGraphic(ImgDirtTop);
			_blocks.add(b);
			
			b = new FlxTileblock(16,800-16,800-32,16);
			b.loadGraphic(ImgDirt);
			_blocks.add(b);
			
			var r:uint = 160;
			
			add(_spawners);
			add(_littleGibs);
			add(_bigGibs);
			add(_blocks);
			add(_decorations);
			add(_bots);

			for(i = 0; i < 50; i++)
				_botBullets.add(new BotBullet());
			
			for(var i:uint = 0; i < 8; i++)
				_arrows.add(new Arrow());

			
			// create player circle
			_circle = new PlayerCircle();
			add(_circle);
			
			// bow
			_bow = new Bow();
			add(_bow);
			
			_player = new Player(316,300,_arrows.members,_littleGibs,_circle,_bow);
			add(_arrows);
			add(_player);
			
			_spawners.add(new Spawner(100,100,_bigGibs,_bots,_botBullets.members,_littleGibs,_player));
			
			_enemies = new FlxGroup();
			_enemies.add(_botBullets);
			_enemies.add(_spawners);
			_enemies.add(_bots);
			
			_objects = new FlxGroup();
			_objects.add(_player)
			_objects.add(_arrows)
			_objects.add(_botBullets);
			_objects.add(_bots);
		//	_objects.add(_littleGibs);
		//	_objects.add(_bigGibs);


			//HUD - score
			_score = new FlxText(0,0,FlxG.width);
			//_score.color = 0xd8eba2;
			_score.color = 0xffffff;
			_score.size = 16;
			_score.alignment = "center";
			_score.scrollFactor.x = _score.scrollFactor.y = 0;
			_score.shadow = 0x131c1b;
			add(_score);
			
			if(FlxG.scores.length < 2)
			{
				FlxG.scores.push(0);
				FlxG.scores.push(0);
			}

			//HUD - highest and last scores
			//_score2 = new FlxText(FlxG.width/2,0,FlxG.width/2)
			//_score2.color = 0xd8eba2;
			//_score2.alignment = "right";
			//_score2.scrollFactor = ssf;
			//_score2.shadow = _score.shadow;
			//add(_score2);
			
			//if(FlxG.score > FlxG.scores[0])
				//FlxG.scores[0] = FlxG.score;
			//if(FlxG.scores[0] != 0)
				//_score2.text = "HIGHEST: "+FlxG.scores[0]+"\nLAST: "+FlxG.score;
			
			FlxG.score = 0;

			FlxG.follow(_player,2.5);
			FlxG.followAdjust(0.5,0.0);
			FlxG.followBounds(0,0,800,800);
			FlxG.mouse.show(ImgCursor);
			FlxG.playMusic(SndRocket);
		}
		
		/*
		 *protected function onKey(event:KeyboardEvent):void
		 *{
		 *    FlxG.log(event.keyCode)
		 *}
		 */
	
		override public function update():void
		{
			var os:uint = FlxG.score;

			super.update();
			
			// HUD
			if(os != FlxG.score)
			{
				if(_player.dead) FlxG.score = 0;
				_score.text = FlxG.score.toString();
				FlxG.log(FlxG.score);
			}
			
			//collisions with environment
			FlxU.collide(_blocks,_objects);
			FlxU.overlap(_enemies,_player,overlapped);
			FlxU.overlap(_arrows,_enemies,overlapped);
			
			if(FlxG.keys.justPressed("B"))
				FlxG.showBounds = !FlxG.showBounds;
		}
		protected function overlapped(Object1:FlxObject,Object2:FlxObject):void
		{
			if((Object1 is BotBullet) || (Object1 is Arrow))
				Object1.kill();
			
			Object2.hurt(1);
		}
		protected function buildRoom(RX:uint,RY:uint,Spawners:Boolean=false):void
		{
			//first place the spawn point (if necessary)
			var rw:uint = 20;
			var sx:uint;
			var sy:uint;
			if(Spawners)
			{
				sx = 2+FlxU.random()*(rw-7);
				sy = 2+FlxU.random()*(rw-7);
			}

			//then place a bunch of blocks
			var numBlocks:uint = 3+FlxU.random()*4;
			if(!Spawners) numBlocks++;
			var maxW:uint = 10;
			var minW:uint = 2;
			var maxH:uint = 8;
			var minH:uint = 1;
			var bx:uint;
			var by:uint;
			var bw:uint;
			var bh:uint;
			var check:Boolean;
			//for(var i:uint = 0; i < numBlocks; i++)
			//{
				//check = false;
				//do
				//{
					////keep generating different specs if they overlap the spawner
					//bw = minW + FlxU.random()*(maxW-minW);
					//bh = minH + FlxU.random()*(maxH-minH);
					//bx = -1 + FlxU.random()*(rw+1-bw);
					//by = -1 + FlxU.random()*(rw+1-bh);
					//if(Spawners)
						//check = ((sx>bx+bw) || (sx+3<bx) || (sy>by+bh) || (sy+3<by));
					//else
						//check = true;
				//} while(!check);

				//var b:FlxTileblock;

				//b = new FlxTileblock(RX+bx*8,RY+by*8,bw*8,bh*8);
				//b.loadTiles(ImgTech);
				//_blocks.add(b);

				////If the block has room, add some non-colliding "dirt" graphics for variety
				//if((bw >= 4) && (bh >= 5))
				//{
					//b = new FlxTileblock(RX+bx*8+8,RY+by*8,bw*8-16,8);
					//b.loadTiles(ImgDirtTop);
					//_decorations.add(b);

					//b = new FlxTileblock(RX+bx*8+8,RY+by*8+8,bw*8-16,bh*8-24);
					//b.loadTiles(ImgDirt);
					//_decorations.add(b);
				//}
			//}

			//Finally actually add the spawner
			if(Spawners)
				_spawners.add(new Spawner(RX+sx*8,RY+sy*8,_bigGibs,_bots,_botBullets.members,_littleGibs,_player));
		}

	}
}

