/**
 *  Author: Christophe Coenraets, http://coenraets.org
 */
package com.groupcotton.events
{
	import flash.events.Event;
	
	public class SyncEvent extends Event
	{
		public static const SUCCESS:String = "success";
		public static const FAILURE:String = "failure";
	
		public var data:*;
		
		public function SyncEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = true)
   		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}