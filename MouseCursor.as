package 
{
	import flash.geom.Point;
	import org.flixel.*;

	public class MouseCursor extends FlxSprite
	{
		//[Embed(source="data/bullet.png")] private var ImgBullet:Class;
		[Embed(source="../data/tiles_all.png")] private var ImgBullet:Class;
		
		
		public function MouseCursor():void
		{
			//Jet effect that shoots out from behind the bot
			super();
			loadGraphic(ImgBullet, true, true, 8, 8);
			width = 8;
			height = 8;
			solid = false;
			
			addAnimation("idle",[0]);
			addAnimation("click",[2, 3, 4, 5, 6, 7, 8, 9], 5, false);
		}
		
		override public function update():void
		{			
			super.update();
			if(FlxG.mouse.justPressed())
			{
				FlxG.log('click');
				visible = true;
				play("click");
			}
			if(finished)
			// finished playing 
			{
				play("idle");
				visible = false;
			}


			//play("click");
			x = FlxG.mouse.x;
			y = FlxG.mouse.y;
		}
	}
}
