package eu.blue112.arttp.engine;

import flash.events.KeyboardEvent;

class KeyManager
{
    static private var keys:Array<Bool>;

    static public var is_lock:Bool = false;
    static private var block_until:UInt;
    static private var onKey:Void->Void = null;

    public function new()
    {
        keys = [];

        flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
    }

    private function keyDown(e:KeyboardEvent):Void
    {
        if (is_lock && e.keyCode == block_until)
        {
            is_lock = false;
            onKey();
        }

        keys[e.keyCode] = true;
    }

    private function keyUp(e:KeyboardEvent):Void
    {
       keys[e.keyCode] = false;
    }

    static public function blockUntil(keyCode:UInt, onKey:Void->Void):Bool
    {
        if (is_lock)
            return false;

        KeyManager.block_until = keyCode;
        KeyManager.onKey = onKey;
        KeyManager.is_lock = true;

        return true;
    }

    static public function isDown(keyCode:UInt):Bool
    {
        if (KeyManager.is_lock)
            return false;

        return keys[keyCode];
    }

}
