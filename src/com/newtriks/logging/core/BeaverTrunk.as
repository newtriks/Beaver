/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.core {

import com.newtriks.logging.helpers.BeaverUtil;
import com.newtriks.logging.values.*;
import com.newtriks.logging.events.*;

import flash.events.AsyncErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.net.LocalConnection;
import flash.net.SharedObject;
import flash.net.registerClassAlias;
import flash.system.Security;
import flash.utils.getQualifiedClassName;

public class BeaverTrunk implements IBeaverTrunk {
    // Local connection
    private var connection:LocalConnection = new LocalConnection();
    private var lcHandler:String = "lcHandler";
    // LSO
    private var solName:String;
    private var solPath:String = "/";
    // Class
    private var hasEventListeners:Boolean = false;
    private var outputToConsole:Boolean;
    private var logsVector:Vector.<Log>;
    private var currentIndex:uint;

    public function BeaverTrunk(solName:String, outputToConsole:Boolean=true) {

        Security.allowDomain("*");
        Security.allowInsecureDomain("*");

        this.solName = solName;
        this.outputToConsole = outputToConsole;
        logsVector = new Vector.<Log>();
        currentIndex = 1;
        registerClassAlias("com.newtriks.logging.values.Log", Log);
    }

    /**
     * API methods
     */

    public function saveNewLog(message:String, sender:Object, level:int):void {
        var qualifiedClassName:String = getQualifiedClassName(sender);
        var log:Log = buildLog(message, qualifiedClassName, level);
        logsVector.push(log);
        saveToSol();
        updateIndexing(log);
        sendToBeaver(message, qualifiedClassName, level);
    }

    public function get logs():Vector.<Log> {
        readFromSol();
        return logsVector;
    }

    /**
     * Class methods
     */

    private function saveToSol():void {
        var sol:SharedObject = getSol();
        var solData:Object = sol.data;
        solData.logs = logsVector;
        sol.flush();
        sol.close();
    }

    protected function readFromSol():void
    {
        var mailSol:SharedObject=getSol();
        var solData:Object=mailSol.data;
        if(solData.logs!=null)
        {
            logsVector=solData.logs;
        }
    }

    private function sendToBeaver(message:String, qualifiedClassName:String, level:int = 4):void {
        if (!hasEventListeners) {
            connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            connection.addEventListener(StatusEvent.STATUS, onStatus);
            hasEventListeners = true;
        }
        try {
            connection.allowDomain("*");
            connection.send(solName, lcHandler, {message:message, level:level, sender:BeaverUtil.className(qualifiedClassName)});
        }
        catch (e:*) {
            BeaverUtil.dumpTrace("Error sending log in BeaverLog", BeaverUtil.levelToString(LogEventLevel.ERROR), "BeaverLog");
        }
        // Trace all logs to console
        if (outputToConsole) {
            BeaverUtil.dumpTrace(message, BeaverUtil.levelToString(level).toUpperCase(), qualifiedClassName);
        }
        // If level gt 6 i.e. ERROR/FATAL dispatch event to main application to handle internally
        if (level > 6) {
            BeaverUtil.handleErrorLogs(message, qualifiedClassName, level);
        }
    }

    private function buildLog(message:String, qualifiedClassName:String, level:int):Log {
        var currentLog:Log = new Log();
        currentLog.id = nextID;
        currentLog.body = message;
        currentLog.sender = qualifiedClassName;
        currentLog.level = level;
        currentLog.dateTimeStamp = dateTimeStamp;
        return currentLog;
    }

    private function updateIndexing(log:Log):void {
        currentIndex = Math.max(currentIndex, log.id);
    }

    /**
     * Event Handlers
     */

    private function onAsyncError(event:AsyncErrorEvent):void {
        BeaverUtil.dumpTrace("Async error in BeaverLog", BeaverUtil.levelToString(LogEventLevel.ERROR), "BeaverLog");
    }

    private function onSecurityError(event:SecurityErrorEvent):void {
        BeaverUtil.dumpTrace("Security error in BeaverLog", BeaverUtil.levelToString(LogEventLevel.ERROR), "BeaverLog");
    }

    private function onStatus(event:StatusEvent):void {
        switch (event.level) {
            case "status":
                connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
                connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                connection.removeEventListener(StatusEvent.STATUS, onStatus);
                hasEventListeners = false;
                break;
            case "error":
                break;
        }
    }

    /**
     * Helpers
     */

    private function getSol():SharedObject {
        return SharedObject.getLocal(solName, solPath);
    }

    private function get dateTimeStamp():Date {
        return new Date();
    }

    private function get nextID():uint {
        return currentIndex++;
    }
}
}
