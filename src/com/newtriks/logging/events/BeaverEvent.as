/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.events {
import flash.events.Event;

public class BeaverEvent extends Event {
    public static const ERROR:String = 'ERROR';

    public var level:int;
    public var errorMessage:String;
    public var sender:Object;

    public function BeaverEvent(errorMessage:String, sender:Object, type:String, level:int, bubbles:Boolean = true, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.level = level;
        this.sender = sender;
        this.errorMessage = errorMessage;
    }

    override public function clone():Event {
        return new BeaverEvent(errorMessage, sender, type, level, bubbles, cancelable);
    }
}
}
