package as3ui.renderer
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.charts.chartClasses.LegendData;
	import mx.charts.series.LineSeries;
	import mx.charts.series.items.BubbleSeriesItem;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;

	
	public class itemRenderer_BubbleSeries extends UIComponent implements IDataRenderer
	{
		private var chartItem:BubbleSeriesItem;
		
		public function itemRenderer_BubbleSeries():void
		{
			super();
		}
		
		public function get data():Object
		{
			return chartItem;
		}
		
		public function set data(value:Object):void
		{
			if (chartItem == value)
				return;
			if (value is BubbleSeriesItem)
			{
				chartItem=BubbleSeriesItem(value);
				
			}
			else if (value is LegendData)
			{
				
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var chartGraphics:Graphics=graphics;
			chartGraphics.clear();

			chartGraphics.lineStyle(3,chartItem.item["color"])
			var radius:Number=Number(chartItem.zValue);
			chartGraphics.drawCircle(unscaledWidth/2,unscaledHeight/2,radius);
			chartGraphics.endFill();
		
			
			
		}
	}
}