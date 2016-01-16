package common.p2p.stream.messages 
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	public class CorePositonMessage extends Message 
	{
		public static const	CORE_POSITION_MESSAGE:String = "coreMessage";
		
		public var way:Array;
		
		public function CorePositonMessage ()
		{
			super.type = CORE_POSITION_MESSAGE;
		}
	}
}