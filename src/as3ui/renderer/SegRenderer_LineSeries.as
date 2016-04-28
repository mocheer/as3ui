package as3ui.renderer
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import mx.charts.chartClasses.LegendData;
	import mx.charts.series.items.LineSeriesSegment;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	
	public class SegRenderer_LineSeries extends UIComponent implements IDataRenderer
	{
		private var segItem:LineSeriesSegment;
		private var unitValue:Number;
		public function SegRenderer_LineSeries():void
		{
			super();
		}
		
		public function get data():Object
		{
			return segItem;
		}
		
		public function set data(value:Object):void
		{
			if (segItem == value)
				return;
			if (value is LineSeriesSegment)
			{
				segItem=LineSeriesSegment(value);
			}else if (value is LegendData)
			{
				
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}