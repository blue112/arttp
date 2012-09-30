package eu.blue112.arttp.engine;

enum TileType
{
	COLLISION; //Can't pass
	DEATH; //Die if on it
	PASS; //Can pass
	END; //End of the level
	HURT; //Hurt if on it
	EMPTY; //Empty, should look on another layer
}

class CollisionManager
{
	static private var tileType:IntHash<TileType>;

	static public function init():Void
	{
		tileType = new IntHash();

		tileType.set(11, PASS); //Floor

		//Green laser, ON
		tileType.set(57, DEATH);
		tileType.set(67, DEATH);
		tileType.set(77, DEATH);

		//Green laser, OFF
		tileType.set(56, PASS);
		tileType.set(66, PASS);
		tileType.set(76, PASS);

		//Red laser, ON
		tileType.set(59, DEATH);
		tileType.set(69, DEATH);
		tileType.set(79, DEATH);

		//Red laser, OFF
		tileType.set(58, PASS);
		tileType.set(68, PASS);
		tileType.set(78, PASS);

		tileType.set(20, EMPTY);

		tileType.set(95, PASS);
		tileType.set(96, PASS);
		tileType.set(97, PASS);
		tileType.set(98, PASS);
		tileType.set(99, PASS);
		tileType.set(100, PASS);

		tileType.set(12, END);

		tileType.set(4, DEATH); //Spikes
		tileType.set(10, DEATH); //Hole
	}

	static public function getTileType(gid:Int)
	{
		if (tileType == null)
			init();

		if (tileType.exists(gid))
		{
			return tileType.get(gid);
		}
		else
		{
			return COLLISION;
		}
	}
}
