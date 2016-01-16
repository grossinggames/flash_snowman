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
	import flash.events.KeyboardEvent;
	import common.room.Room;
	import flash.display.Sprite;
	import common.Common;
	
	public class TutorialRoom extends Room
	{	
		public function TutorialRoom()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			[Embed(source = "../../../lib/images/back1.jpg")] 
			var back:Class;
			var mainBack:Bitmap = new back();
			addChild(mainBack);
			
			[Embed(source = "../../../lib/images/mainmenu.png")] 
			var sprite1:Class;
			var btnTutorialRoom:Sprite = Common.createSpr( new sprite1() );
			btnTutorialRoom.x = 500;
			btnTutorialRoom.y = 150;
			btnTutorialRoom.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addChild(btnTutorialRoom);
		}
		
		public function mouseDown(event:MouseEvent):void {
			Common.switchRoom("MainRoom");
		}
		
		private function init(e:Event):void
		{
			trace('Class TutorialRoom init');
		}

		private function onMouseClick(e:Event):void
		{
			trace('Class TutorialRoom onMouseClick');
		}
	}
}