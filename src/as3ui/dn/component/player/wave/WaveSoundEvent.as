package as3ui.dn.component.player.wave
{
	import flash.events.Event;
	
	public class WaveSoundEvent extends Event {
		/*
		* *********************************************************
		* CLASS PROPERTIES
		* *********************************************************
		*
		*/
		public static const DECODE_ERROR:String = 'decodeError';
		
		/*
		* *********************************************************
		* CONSTRUCTOR
		* *********************************************************
		*
		*/
		public function WaveSoundEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type,bubbles,cancelable);
		}
	}
}