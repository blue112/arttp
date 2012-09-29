package eu.blue112.arttp.tools;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

class EventTools
{
	public static function addOnceListener(dispatcher:IEventDispatcher, type:String, listener:Event->Void):Void
	{
		var f:Event->Void = null;
		f = function (e:Event)
		{
			cast (e.target, IEventDispatcher).removeEventListener(e.type, f);
			listener(e);
		}
		dispatcher.addEventListener(type, f);
	}
}
