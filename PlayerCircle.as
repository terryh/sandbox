package 
{
	import flash.geom.Point;
	import org.flixel.*;

	public class PlayerCircle extends FlxSprite
	{
		[Embed(source="../data/playercircle.png")] private var ImgCircle:Class;
		public var rotating:Boolean;
		
		public function PlayerCircle():void
		{
			super();
			loadRotatedGraphic(ImgCircle,12,0);
			width = 70;
			height = 70;
			solid = false;
			visible = false;
			rotating = false;
		}
		override public function update():void
		{			
			if(FlxG.mouse.justPressed())
			{
				var dx:Number = FlxG.mouse.x-(x+width/2);
				var dy:Number = FlxG.mouse.y-(y+width/2);
				var dl:Number = Math.sqrt( dx*dx  + dy*dy );
				FlxG.log(dl);

				if ( dl > width/2 )
				{
					x = FlxG.mouse.x-width/2;
					y = FlxG.mouse.y-height/2;
					visible = true;
					rotating = true;
					//angularAcceleration = -100;
					FlxG.log('click');
					FlxG.log(rotating);
				}
			}
			if (rotating == false)
			{
				//angularAcceleration = 0;
				angularVelocity = 0;
			} else {
				angularVelocity = -150;
			}
			super.update();
		}
	}
}
