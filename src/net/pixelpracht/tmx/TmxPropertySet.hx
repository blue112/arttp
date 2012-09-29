/*******************************************************************************
 * Copyright (c) 2010 by Thomas Jahn
 * This content is released under the MIT License. (Just like Flixel)
 * For questions mail me at lithander@gmx.de!
 ******************************************************************************/
package net.pixelpracht.tmx;

import haxe.xml.Fast;

class TmxPropertySet implements Dynamic<String>
{
	public function new(source:Fast)
	{
		extend(source);
	}

	public function has(value:String):Bool
	{
		return Reflect.hasField(this, value);
	}

	public function extend(source:Fast):TmxPropertySet
	{
		for (prop in source.nodes.property)
		{
			Reflect.setField(this, prop.att.name, prop.att.value);
		}
		return this;
	}

	public function toString():String
	{
		var out = "[Properties ";
		for (i in Reflect.fields(this))
		{
			out += i+"='"+Reflect.field(this, i)+"' ";
		}

		out += "]";
		return out;
	}
}
