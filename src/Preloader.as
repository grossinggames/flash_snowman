package 
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;

	public class Preloader extends Sprite {
		
		[Embed(source = "../lib/images/progressbar.png")]
		private var prgBar:Class;
		private var progressBar:Bitmap = new prgBar;

		[Embed(source = "../lib/images/indicator.png")]
		private var indr:Class;
		private var indicator:Bitmap = new indr;

		private var progressTxt:TextField = new TextField();
		
		public function Preloader() {
			progressBar.x = 250;
			progressBar.y = 250;
			addChild(progressBar);
			
			indicator.x = 251;
			indicator.y = 251;
			
			progressBar.stage.addChild(indicator);
			progressBar.stage.addChild(progressTxt);
			
			addEventListener(Event.ENTER_FRAME, listenerEnterFrame);
		}

		private function listenerEnterFrame(e:Event):void
		{
			var percentage:Number = Math.floor( (this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal) * 100 );
			progressTxt.text = percentage + '%';
			progressTxt.x = 390;
			progressTxt.y = 257;
			
			indicator.scaleX = percentage * 3;
			
			if (percentage >= 100)
			{
				removeEventListener(Event.ENTER_FRAME, listenerEnterFrame);
				progressBar.stage.removeChild(progressTxt);
				progressBar.stage.removeChild(indicator);
				removeChild(progressBar);
				
				trace('percentage = ' + percentage);
				trace('load Main');
				
				var mainClass:Class = getDefinitionByName("Main") as Class;
				this.addChild(new mainClass as DisplayObject);
			}
		}
		
	}

}