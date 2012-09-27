package eu.blue112.arttp.engine;

import flash.events.KeyboardEvent;

class KeyManager
{
    static private var keys:Array<Bool>;

    public function new()
    {
        keys = new Array<Bool>();

        flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
    }

    private function keyDown(pEvt:KeyboardEvent):Void
    {
        keys[pEvt.keyCode] = true;
    }

    private function keyUp(pEvt:KeyboardEvent):Void
    {
       keys[pEvt.keyCode] = false;
    }

    static public function isDown(keyCode:UInt):Bool
    {
        return keys[keyCode];
    }

}
