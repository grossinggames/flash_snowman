package common.room
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class Room extends Sprite
	{	
		public function Room()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event:Event):void
		{
			trace('Class Room init');
			addedToStageHandler();
		}

		private function addedToStageHandler(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		private function removeFromStageHandler(event:Event = null):void
		{
			trace('Class Room removeFromStageHandler');
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		public function keyDownHandler(event:KeyboardEvent):void
		{
			trace('Class Room keyCode = ' + event.keyCode);
		}
		
		public function keyUpHandler(event:KeyboardEvent):void
		{
			trace('Class Room keyCode = ' + event.keyCode);
		}
	}
}