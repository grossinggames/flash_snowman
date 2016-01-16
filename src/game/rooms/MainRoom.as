package game.rooms
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.*;	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.events.KeyboardEvent;
	import common.room.Room;
	import flash.display.Sprite;
	import common.Common;
	
	public class MainRoom extends Room
	{	
		public function MainRoom()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			[Embed(source = "../../../lib/images/back1.jpg")] 
			var back:Class;
			var mainBack:Bitmap = new back();
			addChild(mainBack);
			
			[Embed(source = "../../../lib/images/play.png")] 
			var sprite1:Class;
			var btnMainRoom:Sprite = Common.createSpr( new sprite1() );
			btnMainRoom.x = 550;
			btnMainRoom.y = 100;
			btnMainRoom.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addChild(btnMainRoom);
			
			[Embed(source = "../../../lib/images/tutorial.png")] 
			var sprite2:Class;
			var btnTutorialRoom:Sprite = Common.createSpr( new sprite2() );
			btnTutorialRoom.x = 550;
			btnTutorialRoom.y = 160;
			btnTutorialRoom.addEventListener(MouseEvent.MOUSE_DOWN, switchRoomTutorial);
			addChild(btnTutorialRoom);
		}
		
		public function mouseDown(event:MouseEvent):void {
			Common.p2pConnect();
		}
		
		public function switchRoomTutorial(event:MouseEvent):void {
			Common.switchRoom("TutorialRoom");
		}
		
		private function init(e:Event):void
		{
			trace('Class MainRoom init');
		}

		private function onMouseClick(e:Event):void
		{
			trace('Class MainRoom onMouseClick');
		}
	}
}