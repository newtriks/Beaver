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
public class DateFormatter implements IFormatter {

    public var error:String;

    private static var _defaultInvalidValueError:String = "Invalid value";
    private static var _defaultInvalidFormatError:String = "Invalid format";
    private static const VALID_PATTERN_CHARS:String = "Y,M,D,A,E,H,J,K,L,N,S,Q";

    public static function get defaultInvalidValueError():String {
        return _defaultInvalidValueError;
    }

    public static function get defaultInvalidFormatError():String {
        return _defaultInvalidValueError;
    }

    public static function parseDateString(str:String):Date {
        if (!str || str == "")
            return null;

        var year:int = -1;
        var mon:int = -1;
        var day:int = -1;
        var hour:int = -1;
        var min:int = -1;
        var sec:int = -1;

        var letter:String = "";
        var marker:Object = 0;

        var count:int = 0;
        var len:int = str.length;

        // Strip out the Timezone. It is not used by the DateFormatter
        var timezoneRegEx:RegExp = /(GMT|UTC)((\+|-)\d\d\d\d )?/ig;

        str = str.replace(timezoneRegEx, "");

        while (count < len) {
            letter = str.charAt(count);
            count++;

            // If the letter is a blank space or a comma,
            // continue to the next character
            if (letter <= " " || letter == ",")
                continue;

            // If the letter is a key punctuation character,
            // cache it for the next time around.
            if (letter == "/" || letter == ":" ||
                    letter == "+" || letter == "-") {
                marker = letter;
                continue;
            }

            // Scan for groups of numbers and letters
            // and match them to Date parameters
            if ("a" <= letter && letter <= "z" ||
                    "A" <= letter && letter <= "Z") {
                // Scan for groups of letters
                var word:String = letter;
                while (count < len) {
                    letter = str.charAt(count);
                    if (!("a" <= letter && letter <= "z" ||
                            "A" <= letter && letter <= "Z")) {
                        break;
                    }
                    word += letter;
                    count++;
                }

                // Allow for an exact match
                // or a match to the first 3 letters as a prefix.
                var n:int = DateBase.defaultStringKey.length;
                for (var i:int = 0; i < n; i++) {
                    var s:String = String(DateBase.defaultStringKey[i]);
                    if (s.toLowerCase() == word.toLowerCase() ||
                            s.toLowerCase().substr(0, 3) == word.toLowerCase()) {
                        if (i == 13) {
                            // pm
                            if (hour > 12 || hour < 1)
                                break; // error
                            else if (hour < 12)
                                hour += 12;
                        }
                        else if (i == 12) {
                            // am
                            if (hour > 12 || hour < 1)
                                break; // error
                            else if (hour == 12)
                                hour = 0;

                        }
                        else if (i < 12) {
                            // month
                            if (mon < 0)
                                mon = i;
                            else
                                break; // error
                        }
                        break;
                    }
                }
                marker = 0;
            }

            else if ("0" <= letter && letter <= "9") {
                // Scan for groups of numbers
                var numbers:String = letter;
                while ("0" <= (letter = str.charAt(count)) &&
                        letter <= "9" &&
                        count < len) {
                    numbers += letter;
                    count++;
                }
                var num:int = int(numbers);

                // If num is a number greater than 70, assign num to year.
                if (num >= 70) {
                    if (year != -1) {
                        break; // error
                    }
                    else if (letter <= " " || letter == "," || letter == "." ||
                            letter == "/" || letter == "-" || count >= len) {
                        year = num;
                    }
                    else {
                        break; //error
                    }
                }

                // If the current letter is a slash or a dash,
                // assign num to month or day.
                else if (letter == "/" || letter == "-" || letter == ".") {
                    if (mon < 0)
                        mon = (num - 1);
                    else if (day < 0)
                        day = num;
                    else
                        break; //error
                }

                // If the current letter is a colon,
                // assign num to hour or minute.
                else if (letter == ":") {
                    if (hour < 0)
                        hour = num;
                    else if (min < 0)
                        min = num;
                    else
                        break; //error
                }

                // If hours are defined and minutes are not,
                // assign num to minutes.
                else if (hour >= 0 && min < 0) {
                    min = num;
                }

                // If minutes are defined and seconds are not,
                // assign num to seconds.
                else if (min >= 0 && sec < 0) {
                    sec = num;
                }

                // If day is not defined, assign num to day.
                else if (day < 0) {
                    day = num;
                }

                // If month and day are defined and year is not,
                // assign num to year.
                else if (year < 0 && mon >= 0 && day >= 0) {
                    year = 2000 + num;
                }

                // Otherwise, break the loop
                else {
                    break;  //error
                }

                marker = 0
            }
        }

        if (year < 0 || mon < 0 || mon > 11 || day < 1 || day > 31)
            return null; // error - needs to be a date

        // Time is set to 0 if null.
        if (sec < 0)
            sec = 0;
        if (min < 0)
            min = 0;
        if (hour < 0)
            hour = 0;

        // create a date object and check the validity of the input date
        // by comparing the result with input values.
        var newDate:Date = new Date(year, mon, day, hour, min, sec);
        if (day != newDate.getDate() || mon != newDate.getMonth())
            return null;

        return newDate;
    }

    public function DateFormatter() {
        super();
    }

    private var _formatString:String;

    private var formatStringOverride:String;

    public function get formatString():String {
        return _formatString;
    }

    public function set formatString(value:String):void {
        formatStringOverride = value;
        _formatString = value;
    }

    public function format(value:Object):String {
        // Reset any previous errors.
        if (error)
            error = null;

        // If value is null, or empty String just return "" 
        // but treat it as an error for consistency.
        // Users will ignore it anyway.
        if (!value || (value is String && value == "")) {
            error = defaultInvalidValueError;
            return "";
        }

        // -- value --

        if (value is String) {
            value = DateFormatter.parseDateString(String(value));
            if (!value) {
                error = defaultInvalidValueError;
                return "";
            }
        }
        else if (!(value is Date)) {
            error = defaultInvalidValueError;
            return "";
        }

        // -- format --

        var letter:String;
        var nTokens:int = 0;
        var tokens:String = "";

        var n:int = formatString.length;
        for (var i:int = 0; i < n; i++) {
            letter = formatString.charAt(i);
            if (VALID_PATTERN_CHARS.indexOf(letter) != -1 && letter != ",") {
                nTokens++;
                if (tokens.indexOf(letter) == -1) {
                    tokens += letter;
                }
                else {
                    if (letter != formatString.charAt(Math.max(i - 1, 0))) {
                        error = defaultInvalidFormatError;
                        return "";
                    }
                }
            }
        }

        if (nTokens < 1) {
            error = defaultInvalidFormatError;
            return "";
        }

        var dataFormatter:StringFormatter = new StringFormatter(
                formatString, VALID_PATTERN_CHARS,
                DateBase.extractTokenDate);

        return dataFormatter.formatValue(value);
    }
}

}
