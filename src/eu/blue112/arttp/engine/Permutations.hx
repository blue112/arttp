package eu.blue112.arttp.engine;

class Permutations
{
	static private var permuteTable:IntHash<Int>;

	static public function init()
	{
		permuteTable = new IntHash();

		//Lamps
		setPermute(36, 46);
		setPermute(37, 47);

		//Check, cross
		setPermute(38, 48);

		//Green laser
		setPermute(56, 57);
		setPermute(66, 67);
		setPermute(76, 77);

		//Red laser
		setPermute(58, 59);
		setPermute(68, 69);
		setPermute(78, 79);

		//96 to 99 : numbers
		setPermuteOneWay(95, 96);
		setPermuteOneWay(96, 97);
		setPermuteOneWay(97, 98);
		setPermuteOneWay(98, 99);
		setPermuteOneWay(99, 100);
		setPermuteOneWay(100, 4);
	}

	static public function setPermute(a:Int, b:Int)
	{
		permuteTable.set(a, b);
		permuteTable.set(b, a);
	}

	static public function setPermuteOneWay(from:Int, to:Int)
	{
		permuteTable.set(from, to);
	}

	static public function permute(tileGIDs:Array<Array<Int>>)
	{
		if (permuteTable == null)
			init();

		for (i in 0...tileGIDs.length)
		{
			for (j in 0...tileGIDs[i].length)
			{
				var tile = tileGIDs[i][j];

				var permuted = permuteTable.get(tile);

				if (permuted != null)
				{
					tileGIDs[i][j] = permuted;
				}
			}
		}

		return tileGIDs;
	}
}
