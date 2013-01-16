package 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Icon extends Sprite {
		private var id:uint;
		private var txt:TextField;
		private static var fontType:String = "Arial";
		
		public function Icon(n:uint) {
			id = n;
			init();
		}
		
		private function init():void {
			txt = new TextField();
			addChild(txt);
			txt.x = -40;
			txt.y = -40;
			txt.width = 80;
			txt.height = 80;
			txt.type = TextFieldType.DYNAMIC;
			txt.selectable = false;
			//txt.embedFonts = true;
			//txt.antiAliasType = AntiAliasType.ADVANCED;
			var tf:TextFormat = new TextFormat();
			tf.font = fontType;
			tf.size = 72;
			tf.align = TextFormatAlign.CENTER;
			txt.defaultTextFormat = tf;
			txt.text = String(id);
		}
		
	}
}
