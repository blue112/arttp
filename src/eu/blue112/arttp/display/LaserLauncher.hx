package eu.blue112.arttp.display;

import flash.display.Sprite;

class LaserLauncher extends Sprite
{
	var char:Char;
	var is_red:Bool;

	var timer:Int;

	var lasers:Array<Laser>;

	public function new(type:Int, char:Char):Void
	{
		super();

		is_red = type == 40;
		lasers = [];

		this.char = char;

		timer = 1;
	}

	public function tick(state:Bool):Void
	{
		if (timer > 0)
		{
			timer--;
			return;
		}

		if (is_red && state || !is_red && !state)
		{
			var l = new Laser(is_red);
			l.x = this.x + 16;
			l.y = this.y + 16;
			l.directTo(char);
			this.parent.addChild(l);

			lasers.push(l);
		}
	}
}
