/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.helpers {

import com.newtriks.logging.events.*;
import flash.external.ExternalInterface;
import flash.system.Capabilities;
import flash.system.System;

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
    public static function dumpTrace(message:String, level:String, sender:String, firebug:Boolean):void {
        trace("*START LOG* ".concat("> level: ", level, " > message: ", message, " > connection: ", sender, " *END LOG*"));
        if(!firebug) return;
        ExternalInterface.call("console." + level.toLowerCase(), message);
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
     * @return String
     */
    public static function className(qualifiedClassName:String):String {
        return qualifiedClassName.substring(qualifiedClassName.lastIndexOf('::') + 2);
    }

    /**
     * Check to see if FireBug available, credit due to Jens Krause [websector.de]
     * as its ripped from ThunderBoltAS3 http://goo.gl/1EV1a
     *
     * @return Boolean
     */
     public static function get isFireBugAvailable():Boolean {
        var isBrowser:Boolean = (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn");
        if (isBrowser && ExternalInterface.available) {
            // check if firebug installed and enabled
            var requiredMethodsCheck:String = "";
            var methods:Array = ["info", "warn", "error", "log"];
            for each (var method:String in methods) {
                // Most browsers report typeof function as 'function'
                // Internet Explorer reports typeof function as 'object'
                requiredMethodsCheck += " && (typeof console." + method + " == 'function' || typeof console." + method + " == 'object') ";
            }
            try {
                if (ExternalInterface.call("function(){ return typeof window.console == 'object' " + requiredMethodsCheck + "}"))
                    return true;
            }
            catch (error:SecurityError) {
                return false;
            }
        }
        return false;
    }
}
}
