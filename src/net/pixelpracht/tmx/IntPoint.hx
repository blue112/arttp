package net.pixelpracht.tmx;

class IntPoint
{
	public var x:Int;
	public var y:Int;

	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function equals(pt:IntPoint):Bool
	{
		return this.x == pt.x && this.y == pt.y;
	}

	public function toString():String
	{
		return "[x="+x+" y="+y+"]";
	}
}
