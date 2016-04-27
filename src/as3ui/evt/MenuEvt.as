package as3ui.evt
{
	import flash.events.Event;
	
	public class MenuEvt extends Event
	{
		public static const STATE_CHANGE:String="stateChange";
		public static const CHANGE:String = "change";
		public var oriEvent:Event;
		public var data:Object;
		public function MenuEvt(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}