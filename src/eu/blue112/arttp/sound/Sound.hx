package eu.blue112.arttp.sound;

import flash.events.SampleDataEvent;
import flash.events.Event;
import flash.media.Sound;
import haxe.Timer;

import com.noteflight.standingwave2.filters.CacheFilter;
import com.noteflight.standingwave2.performance.IPerformance;
import com.noteflight.standingwave2.performance.QueuePerformance;
import com.noteflight.standingwave2.filters.BiquadFilter;
import com.noteflight.standingwave2.filters.ResamplingFilter;
import com.noteflight.standingwave2.elements.AudioDescriptor;
import com.noteflight.standingwave2.elements.IAudioSource;
import com.noteflight.standingwave2.filters.EchoFilter;
import com.noteflight.standingwave2.filters.EnvelopeFilter;
import com.noteflight.standingwave2.output.AudioSampleHandler;
import com.noteflight.standingwave2.output.AudioPlayer;
import com.noteflight.standingwave2.performance.ListPerformance;
import com.noteflight.standingwave2.performance.AudioPerformer;
import com.noteflight.standingwave2.performance.PerformanceElement;
import com.noteflight.standingwave2.sources.SoundSource;
import com.noteflight.standingwave2.sources.SineSource;

class Sound
{
	public static inline var AMP_MULTIPLIER:Float = 0.08;
	public static var SAMPLING_RATE:Int = 44100 * 3;
	public static var TWO_PI:Float = 2 * Math.PI;
	public static var TWO_PI_OVER_SR:Float = TWO_PI/SAMPLING_RATE;

	public var freq:Int;

	public var tickOn:Int;
	public var current:Int;
	public var timer:Timer;

	private var sineTones:Array<CacheFilter>;
	private var tickNote:CacheFilter;
	private var player:AudioPlayer;

	static public inline var LN2 = 0.6931471805599453;

	// Initialize an array of cached sine sources that will be used to synthesize sequences
	public function initializeSineTones():Void
	{
		var octave = 4;

		sineTones = [];
		for (i in 0...24)
		{
			var frequency = octave * 55 * Math.exp(i * LN2 / 12.0);
			var tone = new CacheFilter(new SineSource(new AudioDescriptor(), 1, frequency));
			tone.fill();
			sineTones.push(tone);
		}

		tickNote = new CacheFilter(new SineSource(new AudioDescriptor(), 1, 110, 1));
	}

	public function createSineSequence(level:Int):IPerformance
	{
		var p:ListPerformance = new ListPerformance();
		var toneSet = sineTones.slice(0);

		var halfbasses = [233, 196, 184, 174];
		var basses = [233, 233, 196, 196, 184, 184, 174, 174];
		var halfsecond = [293, 370];
		var second = [293, 311, 370, 349];
		var third = [293, 466, 311, 392, 370, 415, 349, 311];

		var notes = [
			[halfbasses],
			[basses],
			[basses, halfsecond],
			[basses, second],
			[basses, third]
		];

		var loopTime = 2;

		var timeBetween = Lambda.fold(notes[level], function(value:Array<Int>, current:Float):Float
		{
			var v = loopTime / value.length;
			if (v < current)
				return v;

			return current;
		}, loopTime) - 0.2;

		for (i in 0...notes[level].length)
		{
			for (j in 0...notes[level][i].length)
			{
				var freq = notes[level][i][j];

				if (freq == 0)
					continue;

				var src = new CacheFilter(new SineSource(new AudioDescriptor(), 1, freq, AMP_MULTIPLIER));
				var noteSource = new EnvelopeFilter(src, 0.02, 0, 0.7, 0.1, 0.1);

				p.addSourceAt((j * (loopTime / notes[level][i].length)) + timeBetween, noteSource);
			}
			// randomly select a sine tone and delete it from the set
			//toneSet.splice(j, 1);

			/*var noteSource:IAudioSource =
				if (i % 4 == 0)
				{
					var src:Dynamic = tickNote.clone();
					new EnvelopeFilter(src, 0, 0.1, 0.5, 0.05, 0.05);
				}
				else
				{
					var src = sineTones[Std.random(sineTones.length)].clone();
					new EnvelopeFilter(src, 0.02, 0, 0.5, 0.1, 0.05);
				}*/

		}

		/*if (level > 0)
		{
			for (i in 0...second.length)
			{
				var src = new CacheFilter(new SineSource(new AudioDescriptor(), 1, second[i]));
				var noteSource = new EnvelopeFilter(src, 0.02, 0, 0.5, 0.1, 0.05);

				p.addSourceAt((i * 0.8) + 0.2, noteSource);
			}
		}*/


		return p;
	}

	// Play a random sequence of sine tones, once through
	public function playSineSequence(level):Void
	{
		var sineSeqQueue = new QueuePerformance();
		sineSeqQueue.addSource(new AudioPerformer(createSineSequence(level)));
		player.play(new AudioPerformer(sineSeqQueue));
		//player.addEventListener("positionChange", checkTick);

		Timer.delay(function()
		{
			timer = new haxe.Timer(1000);
			timer.run = Game.tick;
		}, 600);
	}

	public function stop()
	{
		player.stop();
		timer.stop();
	}

	private function checkTick(e:Event)
	{
		var pos:Float = e.currentTarget.position * 1000;

		if (current % 8 == 0)
		{
		}

		current++;
	}

	public function new(level:Int)
	{
		/*player = new AudioPlayer(8192);
		initializeSineTones();
		playSineSequence(level);*/

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
