package eu.blue112.arttp.sound;

import flash.events.SampleDataEvent;
import flash.events.Event;
import flash.media.Sound;

class Sound
{
	public static inline var AMP_MULTIPLIER:Float = 0.10;
	public static var SAMPLING_RATE:Int = 44100 * 3;
	public static var TWO_PI:Float = 2 * Math.PI;
	public static var TWO_PI_OVER_SR:Float = TWO_PI/SAMPLING_RATE;

	public var freq:Int;

	public function new()
	{
		var sound = new flash.media.Sound();
	  	this.freq = 400;
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, getSamples);
	  	var ch = sound.play();

	  	//haxe.Timer.delay(ch.stop, time);
	}

	static public function generate(freq:Int, time:Int)
	{
		//new Sound(freq, time);
	}

	private function getSamples(event:SampleDataEvent):Void
	{
		var sample:Float;

		var pos = Math.floor(event.position / 8192);

		var silence = pos % 2 == 1;
		var begin = pos % 8 == 0;

		if (begin) freq = 659;
		else freq = 440;

		//if (pos % 8 == 7) //Weirdly, making ticking it one event before makes it sync.
		if (pos % 8 == 6) //Weirdly, making ticking it one event before makes it sync.
			Game.tick();

		for (i in 0...8192)
		{
			sample = Math.sin((i + event.position) * TWO_PI_OVER_SR * freq) > 0  ? 1 : -1;

			if (!silence)
			{
				event.data.writeFloat(sample * AMP_MULTIPLIER);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
			}
			else
			{
				event.data.writeFloat(0);
				event.data.writeFloat(0);
			}
		}
	}
}

//@:sound("lib/sfx/bgm.mp3")
class Bgm extends flash.media.Sound {}
