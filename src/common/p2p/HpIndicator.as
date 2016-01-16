package common.p2p 
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import common.Common;
	import flash.display.Sprite;
	
	public class HpIndicator extends Sprite
	{
		public var percent:Number = 100;
		private var hitPointsIndicatorSprite:Sprite;
		
		public function HpIndicator() 
		{
			[Embed(source = "../../../lib/images/progressbar.png")]
			var hipPointsClassMe:Class;
			var hitPointsSpriteMe:Sprite = Common.createSpr( new hipPointsClassMe() );
			addChild(hitPointsSpriteMe);
			
			[Embed(source = "../../../lib/images/indicator.png")]
			var hipPointsIndicatorClass:Class;
			hitPointsIndicatorSprite = Common.createSpr( new hipPointsIndicatorClass() );
			hitPointsIndicatorSprite.x = 1;
			hitPointsIndicatorSprite.y = 1;
			hitPointsIndicatorSprite.scaleX = percent * 3;
			hitPointsSpriteMe.addChild(hitPointsIndicatorSprite);
		}

		private function setPercent(value:Number):void
		{
			percent = value;
			hitPointsIndicatorSprite.scaleX = percent * 3;
		}
		
		public function receiveDamage():void
		{
			var newPercent:Number = percent - 20;
			if (newPercent > 100)
			{
				newPercent = 100;
			}
			else if (newPercent < 0)
			{
				newPercent = 0;
			}
			
			setPercent(newPercent);
		}
		
		public function isDie():Number
		{
			return (percent > 0 ? 0 : 1);
		}
	}
	
}