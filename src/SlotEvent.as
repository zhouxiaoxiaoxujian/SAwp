package 
{
	import flash.events.Event;
	
	public class SlotEvent extends Event {
		public static const SELECT:String = "select";
		public static const COMPLETE:String = "complete";
		public var value:*;
		
		public function SlotEvent(type:String, value:* = null) {
			super(type);
			this.value = value;
		}
		
		override public function clone():Event {
			return new SlotEvent(type, value);
		}
		
	}
}
