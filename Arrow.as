package 
{
	//AAAAAAAAAAAAAAAAAAAAAAAAAAA
	import org.flixel.*;
	public class Arrow extends FlxSprite
	{
		[Embed(source="../data/arrow.png")] private var ImgArrow:Class;
		[Embed(source="../data/shoot.mp3")] private var SndShoot:Class;
		[Embed(source="../data/jump.mp3")] private var SndHit:Class;
		
		public function Arrow()
		{
			super();
			//loadRotatedGraphic(ImgArrow,36);
			loadGraphic(ImgArrow,true,true,50,4);
			addAnimation("arrow", [0]);
			//width = 70;
			//height = 70;
			exists = false;
			
		}
		
		override public function update():void
		{
			if(dead && finished) 
			{
				//exists = false;
			}
			else
			{
				play('arrow');
				super.update();
			}
		}
		
		override public function render():void
		{
			super.render();
		}

		override public function hitSide(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitTop(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function kill():void
		{
			if(dead) return;
			velocity.x = 0;
			velocity.y = 0;
			if(onScreen()) FlxG.play(SndHit);
			dead = true;
			solid = false;
			//play("poof");
		}
		
		public function shoot(VelocityX:int, VelocityY:int):void
		{
			FlxG.play(SndShoot);
			solid = true;
			velocity.x = VelocityX;
			velocity.y = VelocityY;
		}

	}
}
