package common.p2p.stream
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.events.Event;
	import common.p2p.stream.messages.Message;
	
	public class P2PEvent extends Event 
	{
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		public static const RECEIVE_MESSAGE:String = "receiveMessage";
		public static const ADD_NEIGHBOR:String = "addNeighbor";
		public static const REMOVE_NEIGHBOR:String = "removeNeighbor";
		
		public var message:Message;
		public var id:String;
		public var name:String;
		
		public function P2PEvent(type:String) 
		{
			super(type);
		}
	}
}