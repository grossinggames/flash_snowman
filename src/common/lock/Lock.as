package common.lock 
{
	import common.Common;
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	public class Lock 
	{
		public function Lock() 
		{
			trace('Create Lock');
		}
		
		public function lockApp(lock:Number):void
		{
			trace('lockApp');
			
			if (lock)
			{
				Common.roomField.mouseChildren = false;
			}
			else
			{
				Common.roomField.mouseChildren = true;
			}
		}
	}

}