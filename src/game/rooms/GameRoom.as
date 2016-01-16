package game.rooms
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
    import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.display.Shape;
	import common.spr.Spr;
	import common.room.Room;
	import common.Common;
	import game.assets.Way;

	public class GameRoom extends Room
	{
		private var timerRevert:Timer = new Timer(1000, 1);
		private var canMove:Boolean = true;
		private var wayCore:Object = new Way();
		private var way:Array = wayCore.createWay();
		private var startPointPlayer1:Object = {x: 200, y: 480};
		private var startPointPlayer2:Object = {x: 600, y: 480};
		private var circle:Shape = new Shape(); //Круг который ходит за катапультой для проверки пересечения

		public function GameRoom()
		{
			[Embed(source = "../../../lib/images/back2.jpg")]
			var back:Class;
			var mainBack:Bitmap = new back();
			addChild(mainBack);
			
			addButtons();
			addEventListener(Event.ADDED_TO_STAGE, init);

			circle.graphics.beginFill(0x0000FF, 0.0);
			circle.graphics.drawCircle(0, 0, 50);
			addChild(circle);

            timerRevert.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

        public function enterFrameHandler(event:Event):void {
			var diffCoreX:Number = 70;
			var diffCoreY:Number = 35;
			
			if (Common.p2pServer)
			{
				diffCoreX = diffCoreX * ( -1);
			}
			
			circle.x = Common.p2pUsers['neighbor'].x + diffCoreX;
			circle.y = Common.p2pUsers['neighbor'].y + diffCoreY;
			
			if ( circle.hitTestObject( Common.p2pCores['me'] ) )
			{
				trace('Пересечение!');
				hitEnemy(Common.p2pCores['me'].x, Common.p2pCores['me'].y);
				Common.p2pSendCoreMessage([ { x: -100, y: -100 } ]);
			}
        }
		
        public function timerCompleteHandler(event:TimerEvent):void {
			canMove = true;
        }
		
		public function mouseDown(event:MouseEvent):void {
			Common.switchRoom("MainRoom");
		}

		private function init(e:Event):void
		{
			trace('Class GameRoom init');

			p2pInit();
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		override public function keyDownHandler(event:KeyboardEvent):void
		{
			if (Common.p2pCanMove && canMove)
			{
				//trace('Class GameRoom keyDownHandler');
				
				var step:int 	  = 4;
				var stepAngle:int = 2;
				var diffCoreX:Number = 60;
				var newX:Number;
				var newY:Number = Common.p2pUsers['me'].position.y;;
				
				if (!Common.p2pServer) 
				{
					diffCoreX = diffCoreX * ( -1);
				}
				
				switch (event.keyCode)
				{
					case 37:
						newX = Common.p2pUsers['me'].position.x - step;
						Common.p2pSendPositionMessage(newX, newY);
						break;
						
					case 32:
						var currentAngle:Number = Common.p2pUsers['me'].angle - stepAngle;
						if (currentAngle < -20)
						{
							currentAngle = 50;
							canMove = false;
							timerRevert.start();

							//Создаем клон массива пути
							var tmpWay:Array = wayCore.getCloneWay(way);
							Common.p2pSendCoreMessage(tmpWay);
						}
						Common.p2pSendAngleMessage(currentAngle);
						break;
					
					case 39:
						newX = Common.p2pUsers['me'].position.x + step;
						Common.p2pSendPositionMessage(newX, newY);
						break;
				}
			}
		}
		
		override public function keyUpHandler(event:KeyboardEvent):void
		{
			if (Common.p2pCanMove && canMove)
			{
				trace('Class GameRoom keyUpHandler');

				switch (event.keyCode)
				{
					case 32:
						var currentAngle:Number = Common.p2pUsers['me'].angle;
						if (currentAngle < 30)
						{
							currentAngle = 50;
							canMove = false;
							timerRevert.start();
							
							//Создаем клон массива пути
							var tmpWay:Array = wayCore.getCloneWay(way);
							Common.p2pSendCoreMessage(tmpWay);
						}
						Common.p2pSendAngleMessage(currentAngle);
						break;
				}
			}
		}
		
		private function onMouseClick(e:Event):void
		{
			trace('Class GameRoom onMouseClick');
		}

		private function addButtons():void
		{
			/*
			[Embed(source = "../../../lib/images/exit.png")] 
			var sprite1:Class;
			var btnMainRoom:Sprite = Common.createSpr( new sprite1() );
			btnMainRoom.x = 500;
			btnMainRoom.y = 150;
			btnMainRoom.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addChild(btnMainRoom);
			*/
			
			//Кнопка Передачи хода
			[Embed(source = "../../../lib/images/allow_walk.png")] 
			var sprite2:Class;
			var btnSendAllowWalk:Sprite = Common.createSpr( new sprite2() );
			btnSendAllowWalk.x = 500;
			btnSendAllowWalk.y = 200;
			btnSendAllowWalk.addEventListener(MouseEvent.CLICK, Common.p2pSendAllowWalkMessage);
			addChild(btnSendAllowWalk);
			
			//Кнопка Выйти из p2p комнаты
			[Embed(source = "../../../lib/images/disconnect.png")] 
			var sprite3:Class;
			var btnDisconnect:Sprite = Common.createSpr( new sprite3() );
			btnDisconnect.x = 500;
			btnDisconnect.y = 250;
			btnDisconnect.addEventListener(MouseEvent.CLICK, Common.p2pDisconnect);
			addChild(btnDisconnect);
			
			/*
			//Кнопка Отменить поиск
			[Embed(source = "../../../lib/images/cancel.png")] 
			var sprite4:Class;
			var btnCancel:Sprite = Common.createSpr( new sprite4() );
			btnCancel.x = 500;
			btnCancel.y = 300;
			btnCancel.addEventListener(MouseEvent.CLICK, Common.p2pCancel);
			addChild(btnCancel);
			*/
		}

		private function hitEnemy(posX:Number, posY:Number):void
		{
			Common.p2pSendHitPositionMessage(posX, posY);
		}

		private function p2pInit():void
		{
			if (Common.p2pServer)
			{
				Common.p2pUsers['me'].scaleX = 1;
				Common.p2pUsers['me'].setTo(startPointPlayer1.x, startPointPlayer1.y);
				Common.p2pUsers['me'].moveTo(startPointPlayer1.x, startPointPlayer1.y);
				Common.p2pSendAngleMessage(50);
				
				Common.p2pUsers['neighbor'].scaleX = -1;
				Common.p2pUsers['neighbor'].setTo(startPointPlayer2.x, startPointPlayer2.y);
				Common.p2pUsers['neighbor'].moveTo(startPointPlayer2.x, startPointPlayer2.y);
			}
			else
			{
				Common.p2pUsers['me'].scaleX = -1;
				Common.p2pUsers['me'].setTo(startPointPlayer2.x, startPointPlayer2.y);
				Common.p2pUsers['me'].moveTo(startPointPlayer2.x, startPointPlayer2.y);
				Common.p2pSendAngleMessage(50);
				
				Common.p2pUsers['neighbor'].setTo(startPointPlayer1.x, startPointPlayer1.y);
				Common.p2pUsers['neighbor'].scaleX = 1;
				Common.p2pUsers['neighbor'].moveTo(startPointPlayer1.x, startPointPlayer1.y);
			}
			
			if (Common.p2pUsers['me'])
			{
				addChild(Common.p2pUsers['me']);
				addChild(Common.p2pCores['me']);
			}
			
			if (Common.p2pUsers['neighbor'])
			{
				addChild(Common.p2pUsers['neighbor']);
				addChild(Common.p2pCores['neighbor']);
			}

			if (Common.p2pHpIndicator['me'])
			{
				addChild(Common.p2pHpIndicator['me']);
				Common.p2pHpIndicator['me'].y = 50;
					
				if (Common.p2pServer)
				{
					Common.p2pHpIndicator['me'].x = 50;
				}
				else
				{
					Common.p2pHpIndicator['me'].x = 450;
				}
			}

			if (Common.p2pHpIndicator['neighbor'])
			{
				addChild(Common.p2pHpIndicator['neighbor']);
				Common.p2pHpIndicator['neighbor'].y = 50;
				
				if (Common.p2pServer)
				{
					Common.p2pHpIndicator['neighbor'].x = 450;
				}
				else
				{
					Common.p2pHpIndicator['neighbor'].x = 50;
				}
			}
			
			if (Common.p2pExplosion['me'])
			{
				addChild(Common.p2pExplosion['me']);
			}

			if (Common.p2pExplosion['neighbor'])
			{
				addChild(Common.p2pExplosion['neighbor']);
			}
		}
	}
}