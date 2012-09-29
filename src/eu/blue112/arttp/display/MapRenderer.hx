package eu.blue112.arttp.display;

import eu.blue112.arttp.engine.Permutations;

import haxe.xml.Fast;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;

import net.pixelpracht.tmx.TmxMap;

class MapRenderer extends Sprite
{
	var background:BitmapData;
	var tmxmap:TmxMap;
	var char:Char;

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
		}
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
	}
}
