package com.groupcotton.events
{
	import flash.events.Event;
	
	public class DataChangeEvent extends Event
	{
		public static const TRUE:String = "true";
		public static const FALSE:String = "false";
		
		public function DataChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}