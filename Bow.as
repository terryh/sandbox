package 
{
	import org.flixel.*;

	public class Bow extends FlxSprite
	{
		[Embed(source="../data/bow.png")] private var ImgBow:Class;
		[Embed(source="../data/jump.mp3")] private var SndHit:Class;
		[Embed(source="../data/shoot.mp3")] private var SndShoot:Class;
		
		public function Bow()
		{
			super();
			loadGraphic(ImgBow, true, false, 30, 90 );
			solid = false;
			visible = false;
			addAnimation("release",[0,0,0], 30, false);
			addAnimation("pull",[1],30, false);
		}
		
		override public function update():void
		{
			super.update();
		}

		public function shoot():void
		{
			FlxG.play(SndShoot);
			play("release");
		}
	}
}
