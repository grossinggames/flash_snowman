package common.p2p
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import common.Common;

	public class Core extends Sprite 
	{
		private var way:Array = [];
		
		public function Core() 
		{
			[Embed(source = "../../../lib/images/core.png")] 
			var coreClass:Class;
			var coreBitmap:Bitmap = new coreClass();
			var core:Sprite = Common.createSpr(coreBitmap);
			addChild(core);
			
			this.x = -100;
			this.y = -100;
		}
		
		public function moveTo(newWay:Array):void
		{
			this.x = newWay[0].x;
			this.y = newWay[0].y;
			way = newWay;
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			if (way && way.length > 0)
			{
				var pos:Object = way.shift();
				if (pos && pos.x && pos.y)
				{
					var destinationX:Number = pos.x;
					var destinationY:Number = pos.y;
					this.x = destinationX;
					this.y = destinationY;
				}
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this.x = -100;
				this.y = -100;
			}
		}

		public function get position():Object
		{
			return { x: this.x, y: this.y};
		}
	}
}