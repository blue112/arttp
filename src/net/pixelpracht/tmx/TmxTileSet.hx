/*******************************************************************************
* Copyright (c) 2010 by Thomas Jahn
* This content is released under the MIT License. (Just like Flixel)
* For questions mail me at lithander@gmx.de!
******************************************************************************/
package net.pixelpracht.tmx;

import haxe.xml.Fast;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;

import flash.events.EventDispatcher;
import flash.events.Event;

@:bitmap("lib/gfx/tileset.png")
class TilesetBitmap extends BitmapData {}

class TmxTileSet
{
	public var image(getImage, setImage):BitmapData;
	var _image:BitmapData;

	var _tileProps:Array<TmxPropertySet>;

	public var firstGID:Int;
	public var map:TmxMap;
	public var name:String;
	public var tileWidth:Int;
	public var tileHeight:Int;
	public var spacing:Int;
	public var margin:Int;
	public var imageSource:String;

	//available only after image has been assigned:
	public var numTiles:Int;
	public var numRows:Int;
	public var numCols:Int;

	public function new(source:Fast, parent:TmxMap)
	{
		_tileProps = [];
		numTiles = 0xFFFFFF;
		numRows = 1;
		numCols = 1;
		tileWidth = 32;
		tileHeight = 32;

		firstGID = Std.parseInt(source.att.firstgid);
		map = parent;

		setImage(new TilesetBitmap(0, 0));
	}

	inline public function getImage():BitmapData
	{
		return _image;
	}

	public function setImage(v:BitmapData):BitmapData
	{
		_image = v;
		numCols = Math.floor(v.width / tileWidth);
		numRows = Math.floor(v.height / tileHeight);
		numTiles = numRows * numCols;
		return v;
	}

	inline public function getRect(id:Int):Rectangle
	{
		return new Rectangle((id % numCols) * tileWidth, Math.floor((id / numCols)) * tileHeight, tileWidth, tileHeight);
	}

	inline public function hasGid(gid:Int):Bool
	{
		return (gid >= firstGID) && (gid < firstGID + numTiles);
	}

	inline public function fromGid(gid:Int):Int
	{
		return gid - firstGID;
	}

	inline public function toGid(id:Int):Int
	{
		return firstGID + id;
	}

	inline public function getPropertiesByGid(gid:Int):TmxPropertySet
	{
		return _tileProps[gid - firstGID];
	}

	inline public function getProperties(id:Int):TmxPropertySet
	{
		return _tileProps[id];
	}
}
