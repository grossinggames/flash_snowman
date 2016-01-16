package common.p2p
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import common.p2p.stream.messages.TransitionWalkMessage;
	import common.p2p.stream.messages.Message;
	import common.p2p.stream.messages.PositionMessage;
	import common.p2p.stream.messages.AngleMessage;
	import common.p2p.stream.messages.CorePositonMessage;
	import common.p2p.stream.messages.CoreHitPointMessage;
	import common.p2p.stream.P2P;
	import common.p2p.stream.P2PEvent;
	import common.Common;
	/**
	 * ...
	 * @author baton
	 */
	
	public class P2PCommon extends Sprite 
	{
		private var loader:URLLoader = new URLLoader;
		private var p2p:P2P          = new P2P;
		private var timer:Timer;
		private var p2pConnect:Boolean  = false;
		public  var server:Number    = new Number;
		public  var canMove:Boolean  = false;
		public  var users:Object     = { };
		public  var cores:Object     = { };
		public  var explosions:Object = { "me": new Explosion, "neighbor": new Explosion };
		public  var hpIndicator:Object = { };
		
		
		public function P2PCommon():void
		{
			//Добавляем логгирование
			var log:Log = new Log(800, 600);
			this.addChild(log);
		}
		
		//***************************** Таймер *****************************
		//На каждый тик таймера
		private function onTimer(event:TimerEvent):void 
		{
			Log.print("onTimer = " + event.target.currentCount);
		}
		
		//На окончание таймера
		private function onTimerComplete(event:TimerEvent):void 
		{
			Log.print("onTimerComplete");
			cancelGame();
		}
		
		//***************************** Имя команты *****************************
		//Получить имя новой комнаты от сервера
		public function connect():void 
		{
			Log.print("request connect");
			
			timer = new Timer(20000, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
			timer.start();
			
			var randomNumber:Number = Math.random();
			var request:URLRequest=new URLRequest('https://p2p-server-grossinggames-1.c9users.io/get_room?param1=' + randomNumber);
			loader.addEventListener(Event.COMPLETE, onGetRoom);
			loader.load(request);
			
			hpIndicator = { "me": new HpIndicator, "neighbor": new HpIndicator };
		}
		
		//После получения имени комнаты от сервера
		private function onGetRoom(event:Event):void 
		{
			Log.print("GetRoom");
			trace('loader.data = ' + loader.data);
			
			server = Number( (JSON.parse(loader.data)).first );
			trace('Common.p2pServer = ' + Common.p2pServer);
			
			var abc:Object = JSON.parse(loader.data);
			var groupName:String = String( abc.room );
			
			cancelGame();
			
			p2p.connect(groupName);
			p2p.addEventListener(P2PEvent.CONNECT_SUCCESS, p2pConnectSuccessHandler);
			p2p.addEventListener(P2PEvent.RECEIVE_MESSAGE, p2pReceiveMessageHandler);
			p2p.addEventListener(P2PEvent.ADD_NEIGHBOR, p2pAddNeighborHandler);
			p2p.addEventListener(P2PEvent.REMOVE_NEIGHBOR, p2pRemoveNeighborHandler);
		}
		
		//Отменить поиск игры
		public function cancelGame():void 
		{
			Log.print("LOADER CLOSE");

			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.stop();
			
			loader.removeEventListener(Event.COMPLETE, onGetRoom);
			loader.close();
		}
		
		//***************************** P2P Комнта *****************************
		//На корректный вход в p2p комнату
		private function p2pConnectSuccessHandler(event:P2PEvent):void
		{
			p2p.removeEventListener(P2PEvent.CONNECT_SUCCESS, p2pConnectSuccessHandler);

			//Добавить игрока
			var user:User = users[event.name];
			if (!user)
			{
				addUser(event.name);
			}
			user = users[event.name];
			
			
			//Добавить ядро игрока
			var core:Core = cores[event.name];
			if (!core)
			{
				addCore(event.name);
			}
			core = cores[event.name];
			
			p2pConnect = true;
		}
		
		//Выйти из p2p комнаты
		public function disconnect():void
		{
			if (p2pConnect)
			{
				canMove = false;
				p2pConnect = false;
				server = undefined;
				p2p.disconnect();
				removeUsers();
				p2p.removeEventListener(P2PEvent.RECEIVE_MESSAGE, p2pReceiveMessageHandler);
				Common.switchRoom("MainRoom");
			}
		}

		//На выход соперника
		private function p2pRemoveNeighborHandler(event:P2PEvent):void
		{
			trace('Соперник вышел******************');
			p2p.removeEventListener(P2PEvent.REMOVE_NEIGHBOR, p2pRemoveNeighborHandler);
			disconnect();
		}
		
		//***************************** P2P Обработка Сообщений *****************************
		//Обработка всех входящих сообщений
		private function p2pReceiveMessageHandler(event:P2PEvent):void
		{
			var message:Message = event.message;
			
			switch (message.type)
			{
				//Обработка новых позиций
				case PositionMessage.POSITION_MESSAGE:
					onPositionMessage( PositionMessage(message) );
					break;
					
				//Обработка нового угла
				case AngleMessage.ANGLE_MESSAGE:
					onAngleMessage( AngleMessage(message) );
					break;
					
				//Обработка перехода хода
				case TransitionWalkMessage.TRANSITION_WALK_MESSAGE:
					onTransitionWalkMessage( TransitionWalkMessage(message) );
					break;
					
				//Обработка позиций ядра
				case CorePositonMessage.CORE_POSITION_MESSAGE:
					onCorePositionMessage( CorePositonMessage(message) );
					break;
					
				//Обработка позиций удара
				case CoreHitPointMessage.CORE_HIT_POINT_MESSAGE:
					onCoreHitPointMessage( CoreHitPointMessage(message) );
					break;
			}
		}
		
		//Добавить соперника в список
		private function p2pAddNeighborHandler(event:P2PEvent):void
		{
			p2p.removeEventListener(P2PEvent.ADD_NEIGHBOR, p2pAddNeighborHandler);
			
			//Добавиь соперника
			var user:User = users[event.name];
			if (!user)
			{
				addUser(event.name);
			}
			user = users[event.name];
			user.x = 400;
			user.x = 480;
			
			//Добавиь ядро соперника
			var core:Core = cores[event.name];
			if (!core)
			{
				addCore(event.name);
			}
			core = cores[event.name];
			
			if (Common.p2pServer)
			{
				user.scaleX = -1;
				user.moveTo(600, 0);
			}
			else
			{
				user.scaleX = 1;
				user.moveTo(200, 0);
			}
			
			canMove = true;
			Common.switchRoom("GameRoom");
		}
		
		//Обработка новых позиций
		private function onPositionMessage(message:PositionMessage):void
		{
			Log.print('onPositionMessage message.name = ' + message.name);
			
			var user:User = users[message.name];
			if (user)
			{
				user.moveTo(message.x, message.y);
			}
		}
		
		//Обработка нового угла
		private function onAngleMessage(message:AngleMessage):void
		{
			Log.print('onPositionMessage message.name = ' + message.name);
			
			var user:User = users[message.name];
			if (user)
			{
				user.setAngle(message.angle);
			}
		}		
		
		
		//Обработка перехода хода
		private function onTransitionWalkMessage(message:TransitionWalkMessage):void
		{
			Log.print('TransitionWalkMessage  message.name = ' + message.name);
			canMove = message.allow;
			Log.print( String(message.allow) );
		}
		
		//Обработка новых позиций
		private function onCorePositionMessage(message:CorePositonMessage):void
		{
			Log.print('onCorePositionMessage message.name = ' + message.name);
			
			var core:Core = cores[message.name];
			if (core)
			{
				core.moveTo(message.way);
			}
		}

		//Обработка попадания ядра
		private function onCoreHitPointMessage(message:CoreHitPointMessage):void
		{
			Log.print('onCoreHitPointMessage message.name = ' + message.name);

			var explosion:Explosion = explosions[message.name];
			if (explosion)
			{
				explosion.setPosXY(message.x, message.y);
			}

			if (message.name == 'neighbor')
			{
				var hp:HpIndicator = hpIndicator['me'];
				if (hp)
				{
					hp.receiveDamage();
					if ( Common.p2pHpIndicator['me'].isDie() )
					{
						p2p.removeEventListener(P2PEvent.REMOVE_NEIGHBOR, p2pRemoveNeighborHandler);
						disconnect();
					}
				}
			}
			else
			{
				var hp2:HpIndicator = hpIndicator['neighbor'];
				if (hp2)
				{
					hp2.receiveDamage();
					if ( Common.p2pHpIndicator['neighbor'].isDie() )
					{
						canMove = false;
					}
					
				}
			}
		}
		
		//***************************** P2P Отправка сообщений *****************************
		//Отправить сообщение с новыми позициями
		public function sendPositionMessage(currentX:int, currentY:int):void
		{
			var message:PositionMessage = new PositionMessage();
			message.x = currentX;
			message.y = currentY;
			p2p.sendMessage(message);
		}
		
		//Отправить сообщение с новым углом
		public function sendAngleMessage(currentAnge:int):void
		{
			var message:AngleMessage = new AngleMessage();
			message.angle = currentAnge;
			p2p.sendMessage(message);
		}
		
		//Передать ход сопернику
		public function sendAllowWalkMessage():void
		{
			var message:TransitionWalkMessage = new TransitionWalkMessage();
			message.allow = true;
			p2p.sendMessage(message);
		}

		//Отправить сообщение с новыми позициями ядра
		public function sendCoreMessage(way:Array):void
		{
			var message:CorePositonMessage = new CorePositonMessage();
			message.way = way;
			p2p.sendMessage(message);
		}

		//Отправить сообщение с позициями удара
		public function sendCoreHitPointMessage(currentX:int, currentY:int):void
		{
			var message:CoreHitPointMessage = new CoreHitPointMessage();
			message.x = currentX;
			message.y = currentY;
			p2p.sendMessage(message);
		}		
		//***************************** P2P Визуальное представление *****************************
		//Создать игрока
		private function addUser(userId:String):void
		{
			var user:User = new User();
			users[userId] = user;
			Log.print('addUser username = ' + userId);
		}
		
		//Создать ядро для user
		private function addCore(coreId:String):void
		{
			var core:Core = new Core();
			cores[coreId] = core;
			Log.print('addCore username = ' + coreId);
		}
		
		//Удалить игроков с поля
		private function removeUsers():void
		{
			//Common.roomField.removeChild(users['me']);
			//Common.roomField.removeChild(users['neighbor']);
		}
		
	}
}