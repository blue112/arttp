package eu.blue112.arttp.engine;

enum RhythmResult
{
	GOOD;
	TOO_LATE(diff:Int);
	TOO_SOON(diff:Int);
}

class RhythmManager
{
	var last_time:Float;

	var tolerance:Int;
	var tick:Int;

	public function new(tick:Int, ?tolerance:Int = 50)
	{
		last_time = 0;

		this.tick = tick;
		this.tolerance = tolerance;
	}

	public function is_inited()
	{
		return last_time != 0;
	}

	public function init()
	{
		last_time = haxe.Timer.stamp();
	}

	public function check()
	{
		var diff = Std.int((haxe.Timer.stamp() - last_time) * 1000);
		last_time = haxe.Timer.stamp();

		if (diff + tolerance >= tick)
		{
			if (diff - tolerance <= tick)
			{
				return GOOD;
			}
			else
			{
				return TOO_LATE(diff - tick);
			}
		}
		else
		{
			return TOO_SOON(tick - diff);
		}

	}
}
