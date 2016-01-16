package common.p2p
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import common.Common;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Explosion extends Sprite 
	{
		private var timer:Timer;
		
		public function Explosion() 
		{
			var explosionShape:Shape = new Shape();
			explosionShape.graphics.beginFill(0x009999, 1);
			explosionShape.graphics.drawCircle(0, 0, 30);
			addChild(explosionShape);
			
			this.x = -100;
			this.y = -100;
		}
		
		//На окончание таймера
		private function onTimerComplete(event:TimerEvent):void 
		{
			trace("onTimerComplete");
			this.x = -100;
			this.y = -100;
		}
		
		private function enterFrameHandler(event:Event):void
		{
			/* Добавить проверку если последний кадр
			if ( frame < 1 )
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this.x = -100;
				this.y = -100;
			}
			*/
		}

		public function get position():Object
		{
			return { x: this.x, y: this.y};
		}
		
		public function setPosXY(posX:Number, posY:Number):void
		{
			this.x = posX;
			this.y = posY;
			
			timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
			timer.start();
			
			//this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
	}
}