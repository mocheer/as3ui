package as3ui.dn.component.renderer
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import mx.charts.LineChart;
	import mx.charts.chartClasses.LegendData;
	import mx.charts.series.LineSeries;
	import mx.charts.series.items.LineSeriesItem;
	import mx.charts.series.items.LineSeriesSegment;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	public class itemRenderer_LineSeries extends UIComponent implements IDataRenderer
	{
		private var segItem:LineSeriesItem;
		public function itemRenderer_LineSeries():void
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
			if (value is LineSeriesItem)
			{
				segItem=LineSeriesItem(value);
			}else if (value is LegendData)
			{
				
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var chart:LineChart = this.parent.parent.parent.parent as LineChart;
			var chartGraphics:Graphics=graphics;
			chartGraphics.clear();
			
			chartGraphics.lineStyle(2,0x000000,1);
			chartGraphics.moveTo( unscaledWidth/2, -this.y);
			chartGraphics.lineTo( unscaledWidth/2, this.document.height);
			
			var label:Label = new Label();
			label.text = segItem.item["xLabel"];
			
			if( label.text.indexOf(".")!=-1)
			{
				label.x = chart.x + this.x  + unscaledWidth/2 + 28 - (label.text.length-2)*4 -2;
			}else
			{
				label.x = chart.x + this.x  + unscaledWidth/2 + 28 - (label.text.length-1)*4;
			}
			label.y = chart.y + chart.height;
			
			this.document.addChild(label);
	
		}
	}
}