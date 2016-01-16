package common.p2p
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Log extends Sprite 
	{
		private static var logField:TextField = new TextField();
		private static var count:Number = 0;
		
		public function Log(stageWidth:int, stageHeigth:int) 
		{
			logField.width = stageWidth;
			logField.height = stageHeigth;
			logField.border = true;
			this.addChild(logField);
		}
		
		public static function print (message:String):void
		{
			count++;
			if (count > 10)
			{
				count = 0;
				logField.text = "";
			}
			
			logField.appendText("\n" + message);
		}
	}
}