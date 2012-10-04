package eu.blue112.arttp.display;

import flash.events.Event;
import flash.display.Sprite;

import caurina.transitions.Tweener;

class SaiyanParticulesGenerator extends Sprite
{
	public function new()
	{
		super();
		addEventListener(Event.ENTER_FRAME, generateParticle);
	}

	private function generateParticle(_)
	{
		for (i in 0...5)
		{
			var p = new Particule();
			addChild(p);
		}
	}

	public function stop()
	{
		removeEventListener(Event.ENTER_FRAME, generateParticle);
	}
}

private class Particule extends Sprite
{
	public function new()
	{
		super();

		graphics.beginFill(0xFBFF00, 0.7);
		graphics.drawRect(0, 0, 3, 3);

		Tweener.addTween(this, {time:2, alpha:0, x:Std.random(200) - 100, y:Std.random(200) - 100, onComplete:destroy});
	}

	private function destroy()
	{
		parent.removeChild(this);
	}
}
