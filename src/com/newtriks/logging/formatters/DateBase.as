package com.newtriks.logging.formatters {
public class DateBase {
    private static var _monthNamesLong:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    private static var _monthNamesShort:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    private static var _dayNamesShort:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    private static var _dayNamesLong:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    private static var _timeOfDay:Array = ["AM", "PM"];

    public static function get defaultStringKey():Array /* of String */ {
        return monthNamesLong.concat(timeOfDay);
    }

    public static function get monthNamesLong():Array /* of String */ {
        return _monthNamesLong;
    }

    public static function get monthNamesShort():Array /* of String */ {
        return _monthNamesShort;
    }

    public static function get dayNamesShort():Array /* of String */ {
        return _dayNamesShort;
    }

    public static function get dayNamesLong():Array /* of String */ {
        return _dayNamesLong;
    }

    public static function get timeOfDay():Array /* of String */ {
        return _timeOfDay;
    }

    private static function setValue(value:Object, key:int):String {
        var result:String = "";

        var vLen:int = value.toString().length;
        if (vLen < key) {
            var n:int = key - vLen;
            for (var i:int = 0; i < n; i++) {
                result += "0"
            }
        }

        result += value.toString();

        return result;
    }

    public static function extractTokenDate(date:Date, tokenInfo:Object):String {
        var result:String = "";

        var key:int = int(tokenInfo.end) - int(tokenInfo.begin);

        var day:int;
        var hours:int;

        switch (tokenInfo.token) {
            case "Y":
            {
                // year
                var year:String = date.getFullYear().toString();
                if (key < 3)
                    return year.substr(2);
                else if (key > 4)
                    return setValue(Number(year), key);
                else
                    return year;
            }

            case "M":
            {
                // month in year
                var month:int = int(date.getMonth());
                if (key < 3) {
                    month++; // zero based
                    result += setValue(month, key);
                    return result;
                }
                else if (key == 3) {
                    return monthNamesShort[month];
                }
                else {
                    return monthNamesLong[month];
                }
            }

            case "D":
            {
                // day in month
                day = int(date.getDate());
                result += setValue(day, key);
                return result;
            }

            case "E":
            {
                // day in the week
                day = int(date.getDay());
                if (key < 3) {
                    result += setValue(day, key);
                    return result;
                }
                else if (key == 3) {
                    return dayNamesShort[day];
                }
                else {
                    return dayNamesLong[day];
                }
            }

            case "A":
            {
                // am/pm marker
                hours = int(date.getHours());
                if (hours < 12)
                    return timeOfDay[0];
                else
                    return timeOfDay[1];
            }

            case "H":
            {
                // hour in day (1-24)
                hours = int(date.getHours());
                if (hours == 0)
                    hours = 24;
                result += setValue(hours, key);
                return result;
            }

            case "J":
            {
                // hour in day (0-23)
                hours = int(date.getHours());
                result += setValue(hours, key);
                return result;
            }

            case "K":
            {
                // hour in am/pm (0-11)
                hours = int(date.getHours());
                if (hours >= 12)
                    hours = hours - 12;
                result += setValue(hours, key);
                return result;
            }

            case "L":
            {
                // hour in am/pm (1-12)
                hours = int(date.getHours());
                if (hours == 0)
                    hours = 12;
                else if (hours > 12)
                    hours = hours - 12;
                result += setValue(hours, key);
                return result;
            }

            case "N":
            {
                // minutes in hour
                var mins:int = int(date.getMinutes());
                result += setValue(mins, key);
                return result;
            }

            case "S":
            {
                // seconds in minute
                var sec:int = int(date.getSeconds());
                result += setValue(sec, key);
                return result;
            }

            case "Q":
            {
                // milliseconds in second
                var ms:int = int(date.getMilliseconds());
                result += setValue(ms, key);
                return result;
            }
        }

        return result;
    }
}
}