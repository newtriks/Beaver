/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.helpers {

import com.newtriks.logging.events.*;

public class BeaverUtil {
    /**
     * Return log level as a string.
     *
     * @param level
     * @return
     */
    public static function levelToString(level:int):String {
        return LogEvent.getLevelString(level).toLowerCase();
    }

    /**
     * Output trace to console.
     *
     * @param message
     * @param level
     * @param sender
     */
    public static function dumpTrace(message:String, level:String, sender:String):void {
        trace("*START LOG* ".concat("> level: ", level, " > message: ", message, " > connection: ", sender, " *END LOG*"));
    }

    /**
     * Dispatch error event to host application.
     *
     * @param errorMessage
     * @param sender
     * @param level
     */
    public static function handleErrorLogs(errorMessage:String, sender:Object, level:int, application:Object):void {
        if(application==null) return;
        application.dispatchEvent(new BeaverEvent(errorMessage, sender, BeaverEvent.ERROR, level));
    }

    /**
     * Just the class name excluding package name.
     *
     * @param qualifiedClassName
     * @return
     */
    public static function className(qualifiedClassName:String):String {
        return qualifiedClassName.substring(qualifiedClassName.lastIndexOf('::') + 2);
    }
}
}
