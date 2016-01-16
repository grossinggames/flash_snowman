package common.p2p.stream.messages 
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	public class AngleMessage extends Message 
	{
		public static const	ANGLE_MESSAGE:String = "angleMessage";
		
		public var angle:int;
		
		public function AngleMessage ()
		{
			super.type = ANGLE_MESSAGE;
		}
	}
}