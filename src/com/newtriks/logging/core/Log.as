/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.core {
public class Log {

    public var id:uint;
    public var body:String;
    public var sender:String;
    public var level:uint;
    public var dateTimeStamp:Date;

    public function Log(id:uint, body:String, sender:String, level:uint, dateTimeStamp:Date) {
        this.id = id;
        this.body = body;
        this.sender = sender;
        this.level = level;
        this.dateTimeStamp = dateTimeStamp;
    }
}
}
