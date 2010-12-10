package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{
		public function Main()
		{
			
			//super(320,240,MenuState);
			super(320,240,MenuState,1);
			//super(640,480,MenuState,1);
			FlxState.bgColor = 0xff131c1b;
			FlxG.debug = true;
			useDefaultHotKeys = true;
		}
	}
}
