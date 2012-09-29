package eu.blue112.arttp.display;

import flash.text.TextField;
import flash.text.TextFormat;

class PixelTextField extends TextField
{
	public function new(text:String, formatObj:Dynamic = null)
	{
		super();

		var format = new flash.text.TextFormat("Visitor TT1 BRK", 40);

		if (formatObj != null)
		{
			for (i in Reflect.fields(formatObj))
			{
				Reflect.setField(format, i, Reflect.field(formatObj, i));
			}
		}

		selectable = false;
		mouseEnabled = false;

		this.defaultTextFormat = format;

		embedFonts = true;
		this.text = text;
	}
}
