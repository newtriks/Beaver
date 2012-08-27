/** @author: Simon Bailey simon@newtriks.com */
package com.newtriks.logging.parsers {

import com.newtriks.logging.values.Log;

import mx.formatters.DateFormatter;
import mx.logging.LogEvent;
import mx.utils.StringUtil;

public class GenerateLogReport {
    public static function getUserID(logs:Vector.<Log>):String {
        var i:int;
        var length:int = logs.length;
        var currentRecord:Log;
        var log_id:String = "";
        var message:String = "";
        for (i = 0; i < length; i++) {
            currentRecord = logs[i] as Log;
            message = currentRecord.body;
            if (message.indexOf("log_id") >= 0) {
                log_id = message.slice(message.lastIndexOf(":") + 1, message.length);
            }
        }
        return log_id;
    }

    public static function generateReport(logs:Vector.<Log>):String {
        var i:int;
        var length:int = logs.length - 1;
        var currentLog:Log;
        var currentRecordText:String = "";
        var logText:String = linePartition.concat("Start of Beaver log report", linePartition);
        for (i = length; i >= 0; i--) {
            currentLog = logs[i] as Log;
            currentRecordText = formatCurrentRecord(currentLog);
            logText = logText.concat(currentRecordText, linePartition);
        }
        logText = logText.concat("\n\nEnd of Beaver log report [generated at ".concat(format(new Date(), "H:NN:SS MM/DD/YY"), "]", linePartition));
        return logText;
    }

    protected static function formatCurrentRecord(record:Log):String {
        var recordText:String = StringUtil.substitute("Date: {0} >> \nLevel: {1} >> \nMessage: {2}", format(record.dateTimeStamp, "H:NN:SS MM/DD/YY"), LogEvent.getLevelString(record.level), record.body);
        return recordText;
    }

    public static function format(obj_Date:Object, str_dateFormat:String):String {
        var f:DateFormatter = new DateFormatter();
        f.formatString = str_dateFormat;
        return f.format(obj_Date);
    }

    public static function get linePartition():String
    {
        return "\n\n===========================\n\n";
    }
}
}