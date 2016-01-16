package common.spr
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.*;
	
	public class Spr extends Sprite
	{	
		public function Spr(img:Bitmap)
		{
			addChild(img);
		}

		private function init():void
		{
			trace('Class Button init');
		}
	}
}