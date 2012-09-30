/*******************************************************************************
 * Copyright (c) 2010 by Thomas Jahn
 * This content is released under the MIT License. (Just like Flixel)
 * For questions mail me at lithander@gmx.de!
 ******************************************************************************/
package net.pixelpracht.tmx;

import haxe.xml.Fast;

import flash.display.BitmapData;
import flash.geom.Point;

using net.pixelpracht.tmx.ArrayTools;

class TmxLayer
{
	public var map:TmxMap;
	public var name:String;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var opacity:Int;
	public var visible:Bool;
	public var tileGIDs:Array<Array<Int>>;
	public var baseGIDs:Array<Array<Int>>;
	public var properties:TmxPropertySet;

	public function new(source:Fast, parent:TmxMap)
	{
		properties = null;
		map = parent;
		name = source.att.name;
		x = source.has.x ? Std.parseInt(source.att.x) : 0;
		y = source.has.y ? Std.parseInt(source.att.y) : 0;
		width = Std.parseInt(source.att.width);
		height = Std.parseInt(source.att.height);
		visible = !source.has.visible || (source.att.visible != "0");
		opacity = source.has.opacity ? Std.parseInt(source.att.opacity) : 1;

		//load properties
		for (node in source.nodes.properties)
			properties = properties != null ? properties.extend(node) : new TmxPropertySet(node);

		//load tile GIDs
		tileGIDs = [];
		var data:Fast = source.node.data;
		if (data != null)
		{
			var chunk:String = "";
			if (!data.has.encoding || data.att.encoding.length == 0)
			{
				//create a 2dimensional array
				var lineWidth:Int = width;
				var rowIdx:Int = -1;
				for (node in data.nodes.tile)
				{
					//new line?
					if(++lineWidth >= width)
					{
						tileGIDs[++rowIdx] = [];
						lineWidth = 0;
					}
					var gid:Int = Std.parseInt(node.att.gid);
					tileGIDs[rowIdx].push(gid);
				}

				baseGIDs = tileGIDs.deepcopy();
			}
		}
	}

	public function reset()
	{
		tileGIDs = baseGIDs.deepcopy();
	}

	public function drawLayer(bmp:BitmapData):Void
	{
		for (i in 0...height)
		{
			for (j in 0...width)
			{
				var gid = tileGIDs[i][j];
				if (gid != 0)
				{
					var tileset = map.getGidOwner(gid);

					var r = tileset.getRect(tileset.fromGid(gid));
					var dest = new Point(j * map.tileWidth - (tileset.tileWidth - map.tileWidth), i * map.tileHeight - (tileset.tileHeight - map.tileHeight));

					try
					{
						bmp.copyPixels(tileset.getImage(), r, dest, null, null, true);
					}
					catch(e:Dynamic)
					{
						trace("[WARNING] "+tileset.name+" has no image !");
						return;
					}
				}
			}
		}
	}

	public function drawLine(line:Int, bmp:BitmapData, lineHeight:Int):Bool
	{
		var drawn = false;

		for (j in 0...width)
		{
			var gid = tileGIDs[line][j];
			if (gid != 0)
			{
				var tileset = map.getGidOwner(gid);

				var r = tileset.getRect(tileset.fromGid(gid));
				var dest = new Point(j * map.tileWidth - (tileset.tileWidth - map.tileWidth), lineHeight * map.tileHeight - tileset.tileHeight);

				bmp.copyPixels(tileset.getImage(), r, dest, null, null, true);

				drawn = true;
			}
		}

		return drawn;
	}
}
