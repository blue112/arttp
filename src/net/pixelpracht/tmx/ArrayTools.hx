package net.pixelpracht.tmx;

class ArrayTools
{
	static public function deepcopy<T>(a:Array<T>):Array<T>
	{
		var out:Array<T> = [];
		for (i in a)
		{
			if (Std.is(i, Array))
			{
				out.push(cast(deepcopy(cast(i, Array<Dynamic>))));
			}
			else
			{
				out.push(i);
			}
		}

		return out;
	}
}
