package 
{
	import org.flixel.*;

	public class Spawner extends FlxSprite
	{
		[Embed(source="../data/spawner.png")] private var ImgSpawner:Class;
		[Embed(source="../data/asplode.mp3")] private var SndExplode:Class;
		[Embed(source="../data/menu_hit_2.mp3")] private var SndExplode2:Class;
		[Embed(source="../data/hit.mp3")] private var SndHit:Class;
		
		private var _timer:Number;
		private var _bots:FlxGroup;
		private var _botBullets:Array;
		private var _botGibs:FlxEmitter;
		private var _gibs:FlxEmitter;
		private var _player:Player;
		private var _open:Boolean;
		
		public function Spawner(X:int, Y:int,Gibs:FlxEmitter,Bots:FlxGroup,BotBullets:Array,BotGibs:FlxEmitter,ThePlayer:Player)
		{
			super(X,Y);
			loadGraphic(ImgSpawner,true);
			_gibs = Gibs;
			_bots = Bots;
			_botBullets = BotBullets;
			_botGibs = BotGibs;
			_player = ThePlayer;
			_timer = Math.random()*20;
			_open = false;
			health = 8;

			addAnimation("open", [1, 2, 3, 4, 5], 40, false);
			addAnimation("close", [4, 3, 2, 1, 0], 40, false);
			addAnimation("dead", [6]);
			FlxG.log('Create Spawner');
		}
		
		override public function update():void
		{
			_timer += FlxG.elapsed;
			var limit:uint = 20;
			if(onScreen())
				limit = 4;
			if(_timer > limit)
			{
				_timer = 0;
				makeBot();
				FlxG.log("MakeBot");
			}
			else if(_timer > limit - 0.35)
			{
				if(!_open)
				{
					_open = true;
					play("open");
				}
			}
			else if(_timer > 1)
			{
				if(_open)
				{
					play("close");
					_open = false;
				}
			}
				
			super.update();
		}
		
		override public function hurt(Damage:Number):void
		{
			FlxG.play(SndHit);
			flicker(0.2);
			FlxG.score += 50;
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			FlxG.play(SndExplode);
			FlxG.play(SndExplode2);
			super.kill();
			active = false;
			exists = true;
			solid = false;
			flicker(-1);
			play("dead");
			FlxG.quake.start(0.005,0.35);
			FlxG.flash.start(0xffd8eba2,0.35);
			makeBot();
			_gibs.at(this);
			_gibs.start(true,3,0);
			FlxG.score += 1000;
		}
		
		protected function makeBot():void
		{
			//Try to recycle a dead bot
			if(_bots.resetFirstAvail(x + width/2 - 6, y + height/2 - 6))
				return;
			
			//If there weren't any non-existent ones to respawn, just add a new one instead
			var bot:Bot = new Bot(x + width/2, y + height/2, _botBullets, _botGibs, _player);
			bot.x -= bot.width/2;
			bot.y -= bot.height/2;
			_bots.add(bot);
			FlxG.log("Bot number "+_bots.members.length);
		}
	}
}
