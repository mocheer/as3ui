/**
 * 创建：gyb
 * 时间：20141104
 * 功能：flex绘图工具类
 */
package as3ui.dn.control
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import mx.controls.CheckBox;
	import mx.utils.ObjectUtil;

	public class GraphicsControl
	{
		private var graphics:Graphics;
		public function GraphicsControl(graphics:Graphics):void
		{
			this.graphics = graphics;
			GradientType.LINEAR;
		}
		
		/***
		 *  Graphics.copyFrom 这个API是从flash player10开始有的.
		 *  当然你可以说用 BitmapData.draw 这个方法,但是原本是矢量对象,被draw之后就变成了位图.这样不是很好的.
		 *  OK,当然在Graphics.copyFrom方法出来后,又多了一条复制显示对象为矢量对象的途径,但是这个也是有限制的. <br/>
		 *		1.只能对MovieClip,Sprite,Shape这3种对象进行复制,而对于SimpleButton却无能为力. <br/>
		 *		2.只能对用AS代码绘制的部分绘制,而对在Flash 创作工具(Flash CS3,4,5等)里画的图形无能为力. <br/>
		 *		3.对于MovieClip的多帧不起作用.(原理请看第2条限制) <br/>
		 * @see http://www.litefeel.com/category/development/mylib/
		 */
		public static function displayClone(display:DisplayObject):DisplayObject
		{
			// Shape 返回 Shape
			if(display is Shape)
			{
				var shape:Shape = new Shape();
				shape.graphics.copyFrom(shape.graphics);
				return shape;
			}else if(display is Sprite)// Sprite, MovieClip 都返回Sprite
			{
				var sp:Sprite = new Sprite();
				sp.graphics.copyFrom(Sprite(display).graphics);
				var len:int = Sprite(display).numChildren;
				for(var i:int = 0; i < len; i++)
				{
					var d:DisplayObject = displayClone(Sprite(display).getChildAt(i));
					if(d) sp.addChild(d);
				}
				return sp;
			}
			return null;
		}
		
		
		

	}
}