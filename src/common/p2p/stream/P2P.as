package common.p2p.stream
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import common.p2p.stream.messages.Message;
	import common.p2p.stream.messages.PositionMessage;
	import common.p2p.stream.messages.AngleMessage;
	import common.p2p.stream.messages.TransitionWalkMessage;
	import common.p2p.stream.messages.CorePositonMessage;
	import common.p2p.stream.messages.CoreHitPointMessage;
	import common.p2p.Log;
	
	public class P2P implements IEventDispatcher
	{
		private const SERVER:String = "rtmfp://p2p.rtmfp.net/";
		private const DEVKEY:String = "2026b12bf7fef4306d340b95-1a3d3da72aee";
		
		private var netConnection:NetConnection;
		private var netGroup:NetGroup;
		private var id:String;
		private var groupName:String;
		private var connected:Boolean = false;
		private var sequence:int = 0;
		private var eventDispatcher:EventDispatcher;
		
		public function P2P() 
		{
			eventDispatcher = new EventDispatcher(this);
			netConnection = new NetConnection();
		}
		
		public function connect(groupNameVal:String):void
		{
			groupName = groupNameVal;
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			netConnection.connect(SERVER, DEVKEY);
		}
		
		private function netStatus(event:NetStatusEvent):void
		{
			//Log.print(event.info.code);
			
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					Log.print(event.info.code);
					setupGroup();
					break;
				
				case "NetGroup.Connect.Success":
					Log.print(event.info.code);
					connectSuccess(netConnection.nearID);
					break;
				
				case "NetGroup.Neighbor.Connect":
					Log.print(event.info.code);
					addNeighbor(event.info.peerID);
					break;
				
				case "NetGroup.Neighbor.Disconnect":
					Log.print(event.info.code);
					removeNeighbor(event.info.peerID);
					break;
				
				case "NetGroup.Posting.Notify":
					notify(event.info.message);
					break;
			}
		}
		
		private function setupGroup():void
		{
			var groupSpecifier:GroupSpecifier = new GroupSpecifier(groupName);
			groupSpecifier.postingEnabled = true;
			groupSpecifier.serverChannelEnabled = true;
			
			netGroup = new NetGroup(netConnection, groupSpecifier.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		}
		
		public function sendMessage(message:Message):void
		{
			sequence++;
			message.sender = netGroup.convertPeerIDToGroupAddress(id);
			message.id = id;
			message.name = 'neighbor';
			message.number = sequence;

			netGroup.post(message);

			//Обработка передачи сообщения о переходе хода. Инвертируем значение для отправки себе.
			if ("allow" in message)
			{
				message['allow'] = !message['allow'];
			}
			message.name = 'me';
			receiveMessage(message);
		}
		
		public function connectSuccess(nearId:String):void
		{
			connected = true;
			id = nearId;
			
			var event:P2PEvent = new P2PEvent(P2PEvent.CONNECT_SUCCESS);
			event.id = id;
			event.name = 'me';
			
			this.dispatchEvent(event);
		}
		
		public function notify(messageObject:Object):void
		{
			var message:Message;
			
			switch(messageObject[Message.TYPE_VARIABLE_NAME])
			{
				case PositionMessage.POSITION_MESSAGE:
					message = new PositionMessage();
					objectToMessage(messageObject, message);
					break;
					
				case AngleMessage.ANGLE_MESSAGE:
					message = new AngleMessage();
					objectToMessage(messageObject, message);
					break;
					
				case TransitionWalkMessage.TRANSITION_WALK_MESSAGE:
					message = new TransitionWalkMessage();
					objectToMessage(messageObject, message);
					break;
					
				case CorePositonMessage.CORE_POSITION_MESSAGE:
					message = new CorePositonMessage();
					objectToMessage(messageObject, message);
					break;
					
				case CoreHitPointMessage.CORE_HIT_POINT_MESSAGE:
					message = new CoreHitPointMessage();
					objectToMessage(messageObject, message);
					break;
			}

			receiveMessage(message);
		}
		
		public function receiveMessage(message:Message):void
		{
			var event:P2PEvent = new P2PEvent(P2PEvent.RECEIVE_MESSAGE);
			event.message = message;
			this.dispatchEvent(event);
		}
		
		private function objectToMessage(object:Object, message:Message):void
		{
			for(var prop:* in object)
			{
				message[prop] = object[prop];
			}
		}
		
		public function addNeighbor(neighborId:String):void
		{
			var event:P2PEvent = new P2PEvent(P2PEvent.ADD_NEIGHBOR);
			event.id = neighborId;
			event.name = 'neighbor';
			
			this.dispatchEvent(event);
		}
		
		public function removeNeighbor(neighborId:String):void
		{
			var event:P2PEvent = new P2PEvent(P2PEvent.REMOVE_NEIGHBOR);
			event.id = neighborId;
			this.dispatchEvent(event);
		}

		public function disconnect():void
		{
			netConnection.close();
		}
		
		// dispatcher interface
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
	}
}