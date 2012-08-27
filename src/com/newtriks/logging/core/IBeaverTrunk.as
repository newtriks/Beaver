/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.core {
public interface IBeaverTrunk {
    function saveNewLog(message:String, sender:String, level:int):void;
    function get logs():Vector.<Log>;
}
}
