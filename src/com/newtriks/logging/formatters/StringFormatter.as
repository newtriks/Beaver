////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2003-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.newtriks.logging.formatters {
public class StringFormatter {
    public function StringFormatter(format:String, tokens:String, extractTokenFunc:Function) {
        super();

        formatPattern(format, tokens);
        extractToken = extractTokenFunc;
    }

    private var extractToken:Function;
    private var reqFormat:String;
    private var patternInfo:Array;

    public function formatValue(value:Object):String {
        var curTokenInfo:Object = patternInfo[0];

        var result:String = reqFormat.substring(0, curTokenInfo.begin) +
                extractToken(value, curTokenInfo);

        var lastTokenInfo:Object = curTokenInfo;

        var n:int = patternInfo.length;
        for (var i:int = 1; i < n; i++) {
            curTokenInfo = patternInfo[i];

            result += reqFormat.substring(lastTokenInfo.end,
                    curTokenInfo.begin) +
                    extractToken(value, curTokenInfo);

            lastTokenInfo = curTokenInfo;
        }
        if (lastTokenInfo.end > 0 && lastTokenInfo.end != reqFormat.length)
            result += reqFormat.substring(lastTokenInfo.end);

        return result;
    }

    private function formatPattern(format:String, tokens:String):void {
        var start:int = 0;
        var finish:int = 0;
        var index:int = 0;

        var tokenArray:Array = tokens.split(",");

        reqFormat = format;

        patternInfo = [];

        var n:int = tokenArray.length;
        for (var i:int = 0; i < n; i++) {
            start = reqFormat.indexOf(tokenArray[i]);
            if (start >= 0 && start < reqFormat.length) {
                finish = reqFormat.lastIndexOf(tokenArray[i]);
                finish = finish >= 0 ? finish + 1 : start + 1;
                patternInfo.splice(index, 0,
                        { token:tokenArray[i], begin:start, end:finish });
                index++;
            }
        }

        patternInfo.sort(compareValues);
    }

    private function compareValues(a:Object, b:Object):int {
        if (a.begin > b.begin)
            return 1;
        else if (a.begin < b.begin)
            return -1;
        else
            return 0;
    }
}

}
