package 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	internal class Slot extends Sprite {
		public var id:uint;
		private var _width:uint;
		private var _height:uint;
		private var board:Sprite;
		private var box:Sprite;
		private var overlay:Shape;
		private var slots:Array;
		private var icons:Array;
		private var unit:uint;
		private static var baseColor:uint = 0xFFFFFF;
		public var scrolling:Boolean = false;
		public var stopped:Boolean = false;
		public var completed:uint = 0;
		private static var blur:BlurFilter = new BlurFilter(0, 16, 2);
		private var velocity:Number;
		public static var speed:uint;
		private var deceleration:Number = 0.32;
		private var guide:SlotIcon;
		private var offset:Number;
		private var radius:Number;
		
		public function Slot(n:uint, w:uint, h:uint, s:Number, r:Number) {
			id = n;
			_width = w;
			_height = h;
			speed = s;
			radius = r;
			init();
		}
		
		private function init():void {
			draw();
		}
		public function setup(list:Array):void {
			icons = list;
			unit = 360/icons.length;
			slots = new Array();
			for (var n:uint = 0; n < icons.length; n++) {
				var icon:SlotIcon = new SlotIcon(n, radius);
				box.addChild(icon);
				icon.x = 0;
				var pid:uint = icons[n].id;
				var Icon:Class = icons[n].icon;
				icon.setup(id, pid, new Icon(pid));
				icon.angle = 360 - unit*n;
				icon.update();
				icon.move();
				slots.push(icon);
			}
		}
		public function start():void {
			scrolling = true;
			stopped = false;
			completed = 0;
			box.filters = [blur];
			velocity = speed;
		}
		public function stop():void {
			//スローダウン開始
			scrolling = false;
			catchup();
		}
		public function update():void {
			if (stopped) return;
			if (scrolling) {
				scroll();
			} else {
				slide();
			}
		}
		private function scroll():void {
			for (var n:uint = 0; n < slots.length; n++) {
				var icon:SlotIcon = slots[n];
				icon.angle += velocity;
				icon.update();
				icon.move();
			}
		}
		private function slide():void {
			for (var n:uint = 0; n < slots.length; n++) {
				var icon:SlotIcon = slots[n];
				icon.angle += (icon.tangle - icon.angle)*deceleration;
				if (Math.abs(icon.tangle - icon.angle) < 0.5) {
					completed ++;
					if (completed > slots.length - 1) complete();
				}
				icon.update();
				icon.move();
			}
			box.filters = [new BlurFilter(0, Math.abs(icon.tangle - icon.angle) >> 2, 2)]
		}
		private function complete():void {
			box.filters = [];
			velocity = 0;
			dispatchEvent(new Event(Event.COMPLETE));
			stopped = true;
			for (var n:uint = 0; n < slots.length; n++) {
				var icon:SlotIcon = slots[n];
				icon.angle = uint(icon.angle);
				icon.update();
				icon.move();
			}
			checkout();
		}
		private function catchup():void {
			var list:Array = new Array();
			for (var n:uint = 0; n < slots.length; n++) {
				var icon:SlotIcon = slots[n];
				if (icon.visible) {
					list.push(icon);
				}
			}
			var id:uint = list[list.length - 1].id;
			var gid:uint = (id + slots.length)%slots.length;
			guide = slots[gid];
			offset = 360 - (guide.angle + 360)%360;
			setTarget();
		}
		private function setTarget():void {
			for (var n:uint = 0; n < slots.length; n++) {
				var icon:SlotIcon = slots[n];
				icon.tangle = icon.angle + offset;
			}
		}
		private function checkout():void {
			dispatchEvent(new SlotEvent(SlotEvent.SELECT, guide.pid));
		}
		private function draw():void {
			var back:Shape = new Shape();
			addChild(back);
			back.graphics.beginFill(baseColor);
			back.graphics.drawRect(-_width/2, -_height/2, _width, _height);
			back.graphics.endFill();
			//
			board = new Sprite();
			addChild(board);
			box = new Sprite();
			board.addChild(box);
			//
			overlay = new Shape();
			overlay.graphics.beginFill(baseColor);
			overlay.graphics.drawRect(-_width/2, -_height/2, _width, _height);
			overlay.graphics.endFill();
			//
			board.addChild(overlay);
			board.mask = overlay;
			cacheAsBitmap = true;
			board.cacheAsBitmap = true;
			overlay.cacheAsBitmap = true;
		}
		
	}
}
