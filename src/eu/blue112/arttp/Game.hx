package eu.blue112.arttp;

import flash.display.Sprite;

class Game extends Sprite
{
	public function new()
	{
		super();

		flash.Lib.current.addChild(this);
	}

	static public function main()
	{
		new Game();
	}
}
