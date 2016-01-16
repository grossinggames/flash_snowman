package common.p2p.stream.messages 
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	public class PositionMessage extends Message 
	{
		public static const	POSITION_MESSAGE:String = "positionMessage";
		
		public var x:int;
		public var y:int;
		
		public function PositionMessage ()
		{
			super.type = POSITION_MESSAGE;
		}
	}
}