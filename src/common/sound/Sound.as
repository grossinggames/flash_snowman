package common.sound
{
	/**
	 * ...
	 * @author grossinggames@gmail.com
	 */
	public class Sound extends Object
	{	
		private static const SFX:String = 'sfx';
		private static const ENV:String = 'env';
		private static const MUS:String = 'mus';
		private static const VOC:String = 'voc';
		
		private static var sounds:Object = new Object;
		sounds[SFX] = new Object;
		sounds[ENV] = new Object;
		sounds[MUS] = new Object;
		sounds[VOC] = new Object;		
		
		private static var chanel:Object = new Object;
		chanel[SFX] = new Object;
		chanel[ENV] = new Object;
		chanel[MUS] = new Object;
		chanel[VOC] = new Object;
	
		public function Sound()
		{
			loadSounds();
		}

		//load
		private function loadSounds():void
		{
			loadSfx();
			loadEnv();
			loadMus();
			loadVoc();
		}

		private function loadSfx():void
		{
			[Embed(source = '../../../lib/sound/sfx_example.mp3')]
			var soundClass1:Class;
			sounds[SFX]['sfx_example'] = new soundClass1();
			
			[Embed(source = '../../../lib/sound/sfx_example2.mp3')]
			var soundClass2:Class;
			sounds[SFX]['sfx_example2'] = new soundClass2();
		}
		
		private function loadEnv():void
		{
			[Embed(source = '../../../lib/sound/env_example.mp3')]
			var soundClass1:Class;
			sounds[ENV]['env_example'] = new soundClass1();
			
			[Embed(source = '../../../lib/sound/env_example2.mp3')]
			var soundClass2:Class;
			sounds[ENV]['env_example2'] = new soundClass2();
		}
		
		private function loadMus():void
		{
			[Embed(source = '../../../lib/sound/mus_example.mp3')]
			var soundClass1:Class;
			sounds[MUS]['mus_example'] = new soundClass1();
			
			[Embed(source = '../../../lib/sound/mus_example2.mp3')]
			var soundClass2:Class;
			sounds[MUS]['mus_example2'] = new soundClass2();
		}
		
		private function loadVoc():void
		{
			[Embed(source = '../../../lib/sound/voc_example.mp3')]
			var soundClass1:Class;
			sounds[VOC]['voc_example'] = new soundClass1();
			
			[Embed(source = '../../../lib/sound/voc_example2.mp3')]
			var soundClass2:Class;
			sounds[VOC]['voc_example2'] = new soundClass2();
		}
		
		//play
		public function play(sound:String):void
		{
			trace('Sound play');
			
			if ( sound.search(SFX + "_") + 1 ) 
			{
				playSfx(sound);
			} 
			else if ( sound.search(ENV + "_") + 1 ) 
			{
				playEnv(sound);
			} 
			else if ( sound.search(MUS + "_") + 1 ) 
			{
				playMus(sound);
			} 
			else if ( sound.search(VOC + "_") + 1 ) 
			{
				playVoc(sound);
			}
		}
		
		private function playSfx(sound:String):void
		{
			trace('playSfx');
			chanel[SFX][sound] = sounds[SFX][sound].play();
		}
		
		private function playEnv(sound:String):void
		{
			trace('playEnv');
			chanel[ENV][sound] = sounds[ENV][sound].play();
		}
		
		private function playMus(sound:String):void
		{
			trace('playMus');
			chanel[MUS][sound] = sounds[MUS][sound].play();
		}
		
		private function playVoc(sound:String):void
		{
			trace('playVoc');
			chanel[VOC][sound] = sounds[VOC][sound].play();
		}
		
		//stop
		public function stop(sound:String):void
		{
			trace('Sound stop');
			
			if ( sound.search(SFX + "_") + 1 ) 
			{
				stopSfx(sound);
			} 
			else if ( sound.search(ENV + "_") + 1 ) 
			{
				stopEnv(sound);
			} 
			else if ( sound.search(MUS + "_") + 1 ) 
			{
				stopMus(sound);
			} 
			else if ( sound.search(VOC + "_") + 1 ) 
			{
				stopVoc(sound);
			}
		}
		
		public function stopAll():void
		{
			trace('Sound stopAll');
			
			for (var sfx:String in chanel[SFX])
			{
				stopSfx(sfx);
			}

			for (var env:String in chanel[ENV])
			{
				stopEnv(env);
			}
			
			for (var mus:String in chanel[MUS])
			{
				stopMus(mus);
			}
			
			for (var voc:String in chanel[VOC])
			{
				stopVoc(voc);
			}
		}
		
		private function stopSfx(sound:String):void
		{
			if (chanel[SFX][sound])
			{
				trace('stopSfx');
				chanel[SFX][sound].stop();
			}
		}
		
		private function stopEnv(sound:String):void
		{
			if (chanel[ENV][sound])
			{
				trace('stopEnv');
				chanel[ENV][sound].stop();
			}
		}
		
		private function stopMus(sound:String):void
		{
			if (chanel[MUS][sound])
			{
				trace('stopMus');
				chanel[MUS][sound].stop();
			}
		}
		
		private function stopVoc(sound:String):void
		{
			if (chanel[VOC][sound])
			{
				trace('stopVoc');
				chanel[VOC][sound].stop();
			}
		}
	}
}