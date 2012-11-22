////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.newtriks.logging.events {

import flash.events.Event;

public class LogEvent extends Event {

    public static const LOG:String = "log";

    public static function getLevelString(value:uint):String {
        switch (value) {
            case LogEventLevel.INFO:
            {
                return "INFO";
            }

            case LogEventLevel.DEBUG:
            {
                return "DEBUG";
            }

            case LogEventLevel.ERROR:
            {
                return "ERROR";
            }

            case LogEventLevel.WARN:
            {
                return "WARN";
            }

            case LogEventLevel.FATAL:
            {
                return "FATAL";
            }

            case LogEventLevel.ALL:
            {
                return "ALL";
            }
        }

        return "UNKNOWN";
    }

    public function LogEvent(message:String = "", level:int = 0 /* LogEventLevel.ALL */) {
        super(LogEvent.LOG, false, false);

        this.message = message;
        this.level = level;
    }

    public var level:int;
    public var message:String;

    override public function clone():Event {
        return new LogEvent(message, /*type,*/ level);
    }
}

}