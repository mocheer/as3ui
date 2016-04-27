package as3ui.dn.component.skin
{  
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	
	import mx.graphics.BitmapFill;
	import mx.skins.ProgrammaticSkin;

	public class RepeatBackground extends ProgrammaticSkin
	{  
		/**
		 * 使用方法：
		 * backgroundImage: Embed(source="assets/bg1.gif"); 
		 * border-skin:ClassReference("RepeatBackground");
		 */
		public function RepeatBackground() 
		{
			
		}
		override protected function updateDisplayList(w:Number, h:Number):void
		{  
			super.updateDisplayList(w,h);  
			graphics.clear();
			var b:BitmapFill = new BitmapFill();  
			b.source = getStyle("backgroundImage");//容器必须设置backgroundImage样式绑定图片源
			b.begin(graphics,new Rectangle(0,0,w,h),new Point(0,0));  
			graphics.drawRect(0,0,w,h);  
			b.end(graphics); 
		}  
		
	}
	
}