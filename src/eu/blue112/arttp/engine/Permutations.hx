package eu.blue112.arttp.engine;

class Permutations
{
	static private var permuteTable:IntHash<Int>;

	static public function init()
	{
		permuteTable = new IntHash();

		setPermute(36, 46);
		setPermute(37, 47);
	}

	static public function setPermute(a:Int, b:Int)
	{
		permuteTable.set(a, b);
		permuteTable.set(b, a);
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
