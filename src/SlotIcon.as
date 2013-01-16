package 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	internal class SlotIcon extends Sprite {
		public var id:uint;
		public var sid:uint;
		public var pid:uint;
		public var position:Number;
		public var angle:Number;
		public var tangle:Number;
		public static var radius:uint;
		private static var radian:Number = Math.PI/180;    
		private static var offset:uint = 45;
		
		public function SlotIcon(n:uint, r:Number) {
			id = n;
			radius = r;
		}
		
		public function setup(i:uint, p:uint, icon:DisplayObject):void {
			sid = i;
			pid = p;
			addChild(icon);
		}
		public function update():void {
			position = radius*Math.sin(angle*radian);
		}
		public function move():void {
			var rad:Number = (angle + 360)%360;
			if (rad > offset && rad < 360 - offset) {
				angle = Math.round(angle);
				visible = false;
			} else {
				visible = true;
				y = position;
			}
		}
		
	}
}
