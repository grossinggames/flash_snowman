package game.assets 
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import common.Common;
	
	public class Way
	{
		public function Way() 
		{
		}
		
		public function createWay():Array
		{
			var way:Array    = [];
			var diffX:Number = 0;
			var diffY:Number = 0;

			for (var i:int = 20; i > 0; i--) 
			{
				way.push( { x: i * 10 * ( -1) , y:(i * i) / 2 } );
				if (i == 20)
				{
					diffX = i * 10 * ( -1);
					diffY = (i * i) / 2;
				}
			}

			for (var j:int = 0; j < 24; j++) 
			{
				way.push( { x: j * 10, y:(j * j)/2 } );
			}			
			
			for (var k:int = 0, len:int = way.length; k < len; k++) 
			{
				way[k].x -= diffX;
				way[k].y -= diffY;
			}
			
			return way;
		}
		
		public function getCloneWay(way:Array):Array
		{
			//Создаем клон массива пути
			var tmpWay:Array = [];
			var diffX:Number = 35;
			
			if (!Common.p2pServer)
			{
				diffX = -40;
			}
			
			for (var i:int = 0, len:Number = way.length; i < len; i++)
			{
				var result:Object = { x: way[i].x + Common.p2pUsers['me'].x + diffX, y: way[i].y + Common.p2pUsers['me'].y };
				tmpWay.push(result);
			}
			
			if (!Common.p2pServer)
			{
				for (var j:int = 1, len2:Number = tmpWay.length; j < len2; j++)
				{
					tmpWay[j].x = tmpWay[0].x - (tmpWay[j].x - tmpWay[0].x);
				}
			}
			return tmpWay;
		}
	}

}