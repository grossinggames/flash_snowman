package common.room
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import common.room.Room;
	
	public class ControllerRoom extends Sprite
	{
		private static var rooms:Object = new Object;
		private static var curRoom:String;
		private static var prevRoom:String;
		private static var roomHub:RoomHub = new RoomHub;
		private static var roomStorage:RoomStorage = new RoomStorage;
		
		public function ControllerRoom()
		{
			trace('ControllerRoom');
		}

		public function createRoom(room:Room, name:String):void
		{
			rooms[name] = room;
		}

		public function switchRoom(room:String):void
		{
			if (curRoom != room)
			{
				if (curRoom)
				{
					prevRoom = curRoom;
					roomStorage.addChild(rooms[curRoom]);
				}
				curRoom = room;
				roomHub.addChild(rooms[room]);
			}
		}

		public function get currentRoom():String
		{
			return curRoom;
		}
		
		public function get previousRoom():String
		{
			return prevRoom;
		}

		public function get roomField():RoomHub
		{
			return roomHub;
		}
		
	}
}