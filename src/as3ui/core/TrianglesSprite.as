package as3ui.core
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class TrianglesSprite extends Sprite
	{
		public function TrianglesSprite()
		{
			super();
		}
		
		public function updateGraphics(angle:Number=0,radius:Number=7,color:uint=0xFFFFFF,hasCircle:Boolean=true):void
		{
			var rr:Number = radius*0.5;
			var graphics:Graphics = graphics;
			
			graphics.clear();
			if(hasCircle)
			{
				graphics.lineStyle(1.5,color,1);
				graphics.beginFill(color,0);
				graphics.drawCircle(rr,rr,radius+1);
				graphics.endFill();
			}
			graphics.lineStyle();
			graphics.beginFill(color,1);
			
			var exAngle:Number= Math.PI * 0.21; 
			var p1:Point= new Point(rr,rr);
			var p2:Point=Point.polar(radius,angle + exAngle);
			var p3:Point=Point.polar(radius,angle - exAngle);
			var oP:Point = Point.polar(rr*0.9,angle);
			p1.offset(-oP.x,-oP.y);
			p2.offset(p1.x, p1.y);
			p3.offset(p1.x, p1.y);
			
			graphics.moveTo(p1.x, p1.y);
			graphics.lineTo(p2.x, p2.y);
			graphics.lineTo(p3.x, p3.y);
			graphics.lineTo(p1.x, p1.y);
			graphics.endFill();
		}
		
		
		
		
	}
}