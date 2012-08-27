/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.core {
import com.newtriks.logging.values.Log;

public interface IBeaverTrunk {
    function saveNewLog(message:String, sender:Object, level:int):void;
    function get logs():Vector.<Log>;
}
}
