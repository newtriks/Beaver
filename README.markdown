# Beaver

* Store logs to an LSO.
* Send logs to a Beaver AIR app (holla at me for this).
* Generates a log report.
* Can opt in or out of sending to flash console i.e. trace.
* Uses a unique key for all handshakes.
* Offers a channel to handle Error/Fatal events within your app.

#### How to create and send logs:

* Create a unique key starting with an underscore i.e. *_123456*. Using this key will help prevent
anonymous users reading your application logs. 

* Send a reference to your app instance to assign a handler for dispatched ERROR/FATAL events. I 
  simply set root to a `static var` in the main app (or if using Flex simply use `FlexGlobals.topLevelApplication`).

* Create a class to send logs e.g.

		import com.newtriks.logging.core.BeaverTrunk;

		public class BeaverLog {

			/**
	         * Constructor expects a unique key for the application
	         * and a flag to send all output to the flash console.
	         *
	         * @param key:String
	         * @param app:Object
	         * @param outputToConsole:Boolean (default = true)
	         */
		    private static var trunk:BeaverTrunk = new BeaverTrunk("_123456", Example.root);

		    public static function send(message:String, sender:Object, level:int = 4):void {
		        trunk.saveNewLog(message, sender, level);
		    }
		}

* BeaverLog.send( message, dispatching class, LogEventLevel );

	* `BeaverLog.send("Gnaw a log or two", this);`
	* `BeaverLog.send("The whole tree fell!", this, LogEventLevel.FATAL);`

#### How to make further use of ERROR/FATAL logs:

* Within your app you can add an event listener to your top level application and then manage all 
these events from there. For example, if a service is down you could send a LogEventLevel.Error log 
and your application could transition to an error state.
	
		override public function onRegister():void {
			// Robotlegs example in ApplicationMediator
			eventMap.mapListener(view, BeaverEvent.ERROR, onBeaverEvent);
		}

		private function onBeaverEvent(event:BeaverEvent):void {
			// Dispatch and let application handle
	        globalErrorSignal.dispatch(event.errorMessage, event.sender, event.level);
	    }

#### How to generate log reports:

* Create an app that makes use of the unique application key i.e. validate key in a handshake
method.

* Connect to Beaver `var beaver:BeaverTrunk = new BeaverTrunk("_123456", Example.root);`

* Grab the logs `var logs:Vector.<com.newtriks.logging.values.Log> = beaver.logs;`

* Generate the log report `var report:String = GenerateLog.report(logs);`

Heads up to [Stray][0] cos I skanked some tasty code bits from her [solMailBox][1] repos!

[0]: https://github.com/Stray "Stray"
[1]: https://github.com/Stray/solMailBox "solMailBox"
