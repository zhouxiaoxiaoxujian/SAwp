package 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import playtiLib.utils.lists.ArrayShuffler;
	
	public class SlotMachine extends Sprite {
		private var lines:uint;
		private var slotWidth:uint;
		private var slotHeight:uint;
		private var icons:Array;
		private var slots:Array;
		private static var baseColor:uint = 0x333333;
		private var speed:Number;
		private var radius:Number;
		private var completed:uint = 0;
		private var overlay:Shape;
		
		public function SlotMachine() {
			init();
		}
		
		private function init():void {
			slots = new Array();
		}
		public function initialize(list:Array, s:Number, r:Number):void {
			icons = list;
			speed = s;
			radius = r;
		}
		public function setup(w:uint, h:uint, n:uint):void {
			slotWidth = w;
			slotHeight = h;
			lines = n;
			draw();
			for (var n:uint = 0; n < lines; n++) {
				var slot:Slot = new Slot(n, slotWidth, slotHeight, speed, radius);
				addChild(slot);
				slot.x = (slotWidth + 2)*(n - 1);
				slot.y = 0;
				slot.setup(ArrayShuffler.shuffle(icons));
				slot.addEventListener(SlotEvent.SELECT, selected, false, 0, true);
				slots.push(slot);
			}
			addChild(overlay);
		}
		public function start():void {
			for (var n:uint = 0; n < lines; n++) {
				var slot:Slot = slots[n];
				slot.addEventListener(Event.COMPLETE, complete, false, 0, true);
				slot.start();
			}
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			completed = 0;
		}
		private function update(evt:Event):void {
			for (var n:uint = 0; n < lines; n++) {
				var slot:Slot = slots[n];
				slot.update();
			}
		}
		public function stop(id:uint):void {
			if (id > lines - 1) return;
			var slot:Slot = slots[id];
			slot.stop();
		}
		private function selected(evt:SlotEvent):void {
			dispatchEvent(new SlotEvent(SlotEvent.SELECT, evt.value));
		}
		private function complete(evt:Event):void {
			evt.target.removeEventListener(Event.COMPLETE, complete);
			completed ++;
			if (completed > lines - 1) {
				removeEventListener(Event.ENTER_FRAME, update);
				dispatchEvent(new SlotEvent(SlotEvent.COMPLETE));
			}
		}
		private function draw():void {
			var back:Shape = new Shape();
			addChild(back);
			var w:uint = slotWidth*lines + 2*(lines + 1);
			var h:uint = slotHeight + 4;
			back.graphics.beginFill(baseColor);
			back.graphics.drawRect(-w/2, -h/2, w, h);
			back.graphics.endFill();
			//
			overlay = new Shape();
			addChild(overlay);
			overlay.graphics.beginFill(baseColor);
			overlay.graphics.drawRect(-w/2, -h/2, w, h);
			overlay.graphics.endFill();
			overlay.filters = [new DropShadowFilter(1, 90, 0x000000, 0.4, 8, 8, 2, 3, true, true, false)];
		}
		
	}

}
