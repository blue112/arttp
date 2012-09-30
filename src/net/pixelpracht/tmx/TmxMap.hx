/*******************************************************************************
 * Copyright (c) 2010 by Thomas Jahn
 * This content is released under the MIT License. (Just like Flixel)
 * For questions mail me at lithander@gmx.de!
 ******************************************************************************/
package net.pixelpracht.tmx;

import haxe.xml.Fast;

import flash.events.Event;
import flash.geom.Point;

class TmxMap
{
	public var width:Int;
	public var height:Int;
	public var tileWidth:Int;
	public var tileHeight:Int;

	public var properties:TmxPropertySet;
	public var layers:Hash<TmxLayer>;
	public var orderedLayers:Array<TmxLayer>;
	public var tileSets:Hash<TmxTileSet>;

	public function new(source:Fast)
	{
		//map header
		properties = null;
		layers = new Hash();
		tileSets = new Hash();

		orderedLayers = [];

		width = Std.parseInt(source.att.width);
		height = Std.parseInt(source.att.height);
		tileWidth = Std.parseInt(source.att.tilewidth);
		tileHeight= Std.parseInt(source.att.tileheight);

		//read properties
		for (node in source.nodes.properties)
			properties = properties != null ? properties.extend(node) : new TmxPropertySet(node);

		//load tilesets
		for (node in source.nodes.tileset)
		{
			var ts = new TmxTileSet(node, this);
			var name = node.has.name ? node.att.name : node.att.firstgid;

			tileSets.set(name, ts);
		}

		//load layers
		for (node in source.nodes.layer)
		{
			var l = new TmxLayer(node, this);
			layers.set(node.att.name, l);
			orderedLayers.push(l);
		}
	}

	public function reset():Void
	{
		for (i in orderedLayers)
		{
			i.reset();
		}
	}

	public function pointFromTile(x:Int, y:Int, ?center:Bool):Point
	{
		if (center)
			return new Point(x * tileWidth + tileWidth / 2, y * tileHeight + tileHeight / 2);

		return new Point(x * tileWidth, y * tileHeight);
	}

	public function isCenterTile(point:Point, up:Bool):Bool
	{
		if (!up)
			return isMiddle(Math.floor(point.x) % tileWidth, tileWidth);

		return isMiddle(Math.floor(point.y) % tileHeight, tileHeight);
	}

	private function isMiddle(pos:Int, tileSize:Int):Bool
	{
		return (pos > (tileSize / 2) - 10 && pos < (tileSize / 2) + 10);
	}

	public function tileFromPoint(point:Point):IntPoint
	{
		var pt = new IntPoint(Math.floor(point.x / tileWidth), Math.floor(point.y / tileHeight));

		if (pt.x < 0) pt.x = 0;
		else if (pt.x >= width) pt.x = width - 1;
		if (pt.y < 0) pt.y = 0;
		else if (pt.y >= height) pt.y = height - 1;

		return pt;
	}

	public function getTileSet(name:String):TmxTileSet
	{
		return tileSets.get(name);
	}

	public function getLayer(name:String):TmxLayer
	{
		return layers.get(name);
	}

	public function getFirstTileSet():TmxTileSet
	{
		for(tileset in tileSets)
		{
			if (tileset.firstGID == 1)
				return tileset;
		}
		return null;
	}

	//works only after TmxTileSet has been initialized with an image...
	public function getGidOwner(gid:Int):TmxTileSet
	{
		for (tileSet in tileSets)
		{
			if(tileSet.hasGid(gid))
			{
				return tileSet;
			}
		}
		return null;
	}
}
