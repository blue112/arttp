package eu.blue112.arttp.sound;

import flash.events.SampleDataEvent;
import flash.events.Event;
import flash.media.Sound;

class Sound
{
	public static inline var AMP_MULTIPLIER:Float = 0.08;
	public static var SAMPLING_RATE:Int = 44100 * 3;
	public static var TWO_PI:Float = 2 * Math.PI;
	public static var TWO_PI_OVER_SR:Float = TWO_PI/SAMPLING_RATE;

	public var freq:Int;

	public var tickOn:Int;
	public var current:Int;

	static public inline var LN2 = 0.6931471805599453;

	public function new(level:Int)
	{
		var sound = new flash.media.Sound();
	  	this.freq = 400;
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, getSamples);
	  	var ch = sound.play();

	  	tickOn = 6;

	  	if (flash.system.Capabilities.version.split(",")[1] == "4")
	  	{
	  		tickOn = 4;
	  	}
	}

	private function getSamples(event:SampleDataEvent):Void
	{
		var sample:Float;

		var pos = Math.floor(event.position / 8192);

		var silence = pos % 2 == 1;
		var begin = pos % 8 == 0;

		var amp = AMP_MULTIPLIER;

		if (begin)
		{
			freq = 440;
		}
		else
		{
			freq = 329;
			amp /= 1.5;
		}

		if (pos % 8 == tickOn) //Works fine for all os tested so far
		{
			Game.tick();
		}

		if (pos % 8 == 0)
		{
			current++;
		}

		for (i in 0...8192)
		{
			sample = Math.sin((i + event.position) * TWO_PI_OVER_SR * freq) > 0  ? 1 : -1;

			if (!silence)
			{
				if (current % 2 == 0)
				{
					event.data.writeFloat(0);
					event.data.writeFloat(sample * amp);
				}
				else
				{
					event.data.writeFloat(sample * amp);
					event.data.writeFloat(0);
				}
			}
			else
			{
				event.data.writeFloat(0);
				event.data.writeFloat(0);
			}
		}
	}
}

@:sound("lib/sfx/bgm.mp3")
class Bgm extends flash.media.Sound {}

@:sound("lib/sfx/endtitle.mp3")
class EndTitle extends flash.media.Sound {}

@:sound("lib/sfx/death.wav")
class DeathSnd extends flash.media.Sound {}
