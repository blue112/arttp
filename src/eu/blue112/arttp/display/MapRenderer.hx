package eu.blue112.arttp.display;

import eu.blue112.arttp.engine.Permutations;
import eu.blue112.arttp.engine.CollisionManager;
import eu.blue112.arttp.engine.KeyManager;

import haxe.xml.Fast;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.ui.Keyboard;
import flash.events.Event;
import flash.geom.Point;

import net.pixelpracht.tmx.TmxMap;
import net.pixelpracht.tmx.IntPoint;

class MapRenderer extends Sprite
{
	var background:BitmapData;
	var tmxmap:TmxMap;
	public var char(default, null):Char;

	var has_tick:Bool;
	var ticked:Bool; //True : red, false : green

	var lasers:Array<LaserLauncher>;

	var inverted_map:Bool;

	var last_tile:IntPoint;
	var last_tile_type:TileType;

	static private var STARTING_COORD = new IntPoint(1, 10);
	static public inline var DEAD = "event_char_dead";
	static public inline var WIN = "event_level_win";

	public function new(mapNum:Int)
	{
		super();

		var map = haxe.Resource.getString("map"+mapNum);

		if (map == null)
		{
			trace("Map "+mapNum+" doesn't exists !");
		}
		else
		{
			var xml = new Fast(Xml.parse(map).firstElement());

			tmxmap = new TmxMap(xml);

			background = new BitmapData(tmxmap.width * tmxmap.tileWidth, tmxmap.height * tmxmap.tileHeight);

			for (layer in tmxmap.orderedLayers)
			{
				layer.drawLayer(background);
			}

			addChild(new Bitmap(background));

			char = new Char();
			char.scaleX = char.scaleY = 0.8;
			addChild(char);

			last_tile = new IntPoint(0, 0);

			has_tick = true;
			ticked = false;

			var pt = tmxmap.pointFromTile(STARTING_COORD.x, STARTING_COORD.y);
			char.setPointFromCenter(pt);

			addEventListener(Event.ENTER_FRAME, moveChar);

			char.say(tmxmap.properties.text);

			inverted_map = tmxmap.properties.has("inverted");

			initLasers();
		}
	}

	private function initLasers()
	{
		if (lasers != null)
		{
			for (i in lasers)
			{
				removeChild(i);
			}
		}

		Laser.clean();

		var interactive = tmxmap.getLayer("interactive");

		lasers = [];

		for (y in 0...interactive.tileGIDs.length)
		{
			for (x in 0...interactive.tileGIDs[y].length)
			{
				var tile = interactive.tileGIDs[y][x];

				if (tile == 40 || tile == 50)
				{
					var laser = new LaserLauncher(tile, char);
					laser.x = 32 * x;
					laser.y = 32 * y;
					addChild(laser);

					lasers.push(laser);
				}
			}
		}
	}

	public function stop()
	{
		removeEventListener(Event.ENTER_FRAME, moveChar);
		background.dispose();
	}

	private function moveChar(_)
	{
		var add_x = 0;
		var add_y = 0;

		if (KeyManager.isDown(Keyboard.UP))
		{
			char.playAnimation(Char.UP);
			add_y -= char.speed;
		}
		else if (KeyManager.isDown(Keyboard.DOWN))
		{
			char.playAnimation(Char.DOWN);
			add_y += char.speed;
		}
		else if (KeyManager.isDown(Keyboard.LEFT))
		{
			char.playAnimation(Char.LEFT);
			add_x -= char.speed;
		}
		else if (KeyManager.isDown(Keyboard.RIGHT))
		{
			char.playAnimation(Char.RIGHT);
			add_x += char.speed;
		}
		else
		{
			char.playAnimation(Char.STATIC);

			if (!has_tick)
				return;
		}

		if (ticked && inverted_map)
		{
			add_x = -add_x;
			add_y = -add_y;
		}

		has_tick = false;

		for (i in char.getCollisionPoints(add_x, add_y))
		{
			if (!checkTile(Std.int(i.x), Std.int(i.y))) //If a collision (or death) if found, quit.
			{
				return;
			}
		}

		char.x += add_x;
		char.y += add_y;
	}

	//Return true if collision
	private function checkTile(x:Int, y:Int):Bool
	{
		var current_tile = tmxmap.tileFromPoint(new Point(x, y));

		var interactive = tmxmap.getLayer("interactive");
		var gid = interactive.tileGIDs[current_tile.y][current_tile.x];
		var type = CollisionManager.getTileType(gid);

		if (type == EMPTY)
		{
			var background = tmxmap.getLayer("background");
			gid = background.tileGIDs[current_tile.y][current_tile.x];
			type = CollisionManager.getTileType(gid);
		}

		switch (type)
		{
			case COLLISION: return false;
			case DEATH:
				onDead();
				return false;
			case PASS: return true;
			case END:
				onWin();
				return true;
			case EMPTY: return true; //WTF
			case HURT: return true; //TODO
		}
	}

	public function onDead()
	{
		var pt = tmxmap.pointFromTile(STARTING_COORD.x, STARTING_COORD.y);
		char.setPointFromCenter(pt);

		tmxmap.reset();
		initLasers();
		ticked = false;

		background.lock();
		for (layer in tmxmap.orderedLayers)
		{
			layer.drawLayer(background);
		}
		background.unlock();

		dispatchEvent(new Event(DEAD));
	}

	private function onWin()
	{
		dispatchEvent(new Event(WIN));
	}

	public function tick()
	{
		var interactive = tmxmap.getLayer("interactive");

		if (interactive == null)
		{
			trace("Map doesn't have interactive layer O_o");
			return;
		}

		interactive.tileGIDs = Permutations.permute(interactive.tileGIDs);

		background.lock();
		for (layer in tmxmap.orderedLayers)
		{
			layer.drawLayer(background);
		}
		background.unlock();

		has_tick = true;
		ticked = !ticked;

		for (i in lasers)
		{
			i.tick(ticked);
		}
	}
}
