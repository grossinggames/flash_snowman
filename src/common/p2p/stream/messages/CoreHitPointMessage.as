package common.p2p.stream.messages 
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	public class CoreHitPointMessage extends Message 
	{
		public static const	CORE_HIT_POINT_MESSAGE:String = "coreHitPointMessage";
		public var x:int;
		public var y:int;
		
		public function CoreHitPointMessage ()
		{
			super.type = CORE_HIT_POINT_MESSAGE;
		}
	}
}