package
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.events.Event;
	import flash.display.*;
	import flash.net.*;

	[Frame(factoryClass='Preloader')]
	
	public class Main extends Sprite
	{
		public function Main()
		{
			trace('Class Main');
	
			var app:App = new App();
			addChild(app);
		}
	}
}