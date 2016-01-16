package common.p2p
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.LineScaleMode;
	import common.Common;
	
	public class User extends Sprite 
	{
		private var destinationX:int;
		private var destinationY:int;
		private var destinationAngle:Number = 50;
		private var beam:Sprite;
		private var beamHub:Sprite;
		private var core:Sprite;
		
		public function User() 
		{
			[Embed(source = "../../../lib/images/catapult.png")] 
			var sprite1:Class;
			var spr:Bitmap = new sprite1();
			var catapult:Sprite = Common.createSpr(spr);
			addChild(catapult);

			beamHub = new Sprite();
			beamHub.x = 130;
			beamHub.y = 40;
			addChild(beamHub);
			
			[Embed(source = "../../../lib/images/beam.png")] 
			var beamClass:Class;
			var beamBitmap:Bitmap = new beamClass();
			beam = Common.createSpr(beamBitmap);
			beam.y = -7;
			beam.scaleX = -1;
			beamHub.addChild(beam);
			
			[Embed(source = "../../../lib/images/core.png")] 
			var coreClass:Class;
			var coreBitmap:Bitmap = new coreClass();
			core = Common.createSpr(coreBitmap);
			core.x = 85;
			beam.addChild(core);

			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function moveTo(xVal:int, yVal:int):void
		{
			if (xVal < 0)
			{
				xVal = 0;
			}
			else if (xVal > 800)
			{
				xVal = 800;
			}
			destinationX = Math.floor(xVal);
			destinationY = Math.floor(yVal);
		}

		public function setTo(xVal:int, yVal:int):void
		{
			destinationX = xVal;
			destinationY = yVal;
			this.x = xVal;
			this.y = yVal;
		}
		
		public function setAngle(ang:int):void
		{
			destinationAngle = Math.floor(ang);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			beamHub.rotation -= Math.floor( (beamHub.rotation - destinationAngle) * 0.2);
			this.x 		  -= Math.floor( (this.x - destinationX)     * 0.2);
			this.y 		  -= Math.floor( (this.y - destinationY)     * 0.2);
		}
		
		public function get position():Object
		{
			return { x: destinationX, y: destinationY};
		}
		
		public function get angle():Number
		{
			return destinationAngle;
		}
	}
}