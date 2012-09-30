package eu.blue112.arttp.display;

import flash.text.TextField;
import flash.text.TextFormat;

using StringTools;

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

		autoSize = flash.text.TextFieldAutoSize.LEFT;

		selectable = false;
		mouseEnabled = false;

		this.defaultTextFormat = format;

		embedFonts = true;
		text = text.replace("é","e").replace("è","e").replace("ê","e").replace("û","u").replace("ù","u").replace("à","a").replace("â","a").replace("ç","c");
		this.text = text;
	}
}
