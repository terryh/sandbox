package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed(source="../data/spawner_gibs.png")] private var ImgGibs:Class;
		[Embed(source="../data/menu_hit.mp3")] private var SndHit:Class;

		private var _gibs:FlxEmitter;
		private var t:FlxText;
		private var _t1:FlxText;
		private var _t2:FlxText;
		private var _ok:Boolean;

		
		override public function create():void
		{
			_gibs = new FlxEmitter(FlxG.width/2-50,FlxG.height/2-10);
			_gibs.setSize(100,30);
			_gibs.setYSpeed(-200,-20);
			_gibs.setRotation(-720,720);
			_gibs.gravity = 100;
			_gibs.createSprites(ImgGibs,1000,32);

			_ok = false;
			add(_gibs);
			
			_t1 = new FlxText(FlxG.width,FlxG.height/3,100,"Terry");
			_t1.size = 10;
			add(_t1);
			_t2 = new FlxText(-60,FlxG.height/3,100,"Games");
			_t2.size = 10;
			add(_t2);
			
			
			FlxG.mouse.show();
		}

		override public function update():void
		{
			//Slides the text ontot he screen
			var t1m:uint = FlxG.width/2-40;
			if(_t1.x > t1m)
			{
				_t1.x -= FlxG.elapsed*FlxG.width;
				if(_t1.x < t1m) _t1.x = t1m;
			}
			
			var t2m:uint = FlxG.width/2;
			if(_t2.x < t2m)
			{
				_t2.x += FlxG.elapsed*FlxG.width;
				if(_t2.x > t2m) _t2.x = t2m;
			}
			
			if( !_ok && ((_t2.x == t2m) ||( _t1.x == t1m)) )
			{
				_ok = true;
				FlxG.play(SndHit);
				FlxG.flash.start(0xffd8eba2,0.5);
				_gibs.start(true,5);
				_t1.color = 0xd8eba2;
				_t2.color = 0xd8eba2;
				FlxG.log(FlxU.random());
				//_t1.angle = 10;
				//_t2.angle = -30;
				_t1.angle = FlxU.random()*40-20;
				_t2.angle = FlxU.random()*40-20;
			   
				var b:FlxButton;
				var _b:FlxButton;
				var t1:FlxText;
				var t2:FlxText;

				//terry button
				b = new FlxButton(t2m-70,FlxG.height/3+76,onTerry);
				b.loadGraphic((new FlxSprite()).createGraphic(140,15,0xff3a5c39),(new FlxSprite()).createGraphic(140,15,0xff729954));
				t1 = new FlxText(8,1,100," Created by TerryH");
				t1.color = 0x729954;
				t2 = new FlxText(t1.x,t1.y,t1.width,t1.text);
				t2.color = 0xd8eba2;
				b.loadText(t1,t2);
				add(b);
				
				_b = new FlxButton(t2m-70,FlxG.height/3+138,onButton);
				_b.loadGraphic((new FlxSprite()).createGraphic(140,15,0xff3a5c39),(new FlxSprite()).createGraphic(140,15,0xff729954));
				t1 = new FlxText(25,1,100,"CLICK TO PLAY");
				t1.color = 0x729954;
				t2 = new FlxText(t1.x,t1.y,t1.width,t1.text);
				t2.color = 0xd8eba2;
				_b.loadText(t1,t2);
				add(_b);

			}

			super.update();

		}
		private function onTerry():void
		{
			FlxU.openURL('http://blog.lifetaiwan.net/');
		}
		private function onButton():void
		{
			//FlxG.play(SndHit);
			FlxG.mouse.hide();
			FlxG.state = new PlayState();
		}
		
	}
}
