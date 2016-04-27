package as3ui.ex.component.dateField.core.indicator
{
	import flash.display.Graphics;
	import mx.skins.halo.DateChooserIndicator;
	/**
	 * @author gyb
	 * @date：2014-12-23 下午02:30:29
	 * 鼠标移动到日期、选择日期背景皮肤
	 */
	public class DatePickerIndicator extends DateChooserIndicator
	{
		public var todayColor:uint = 0x818181;
		public var rollOverColor:uint = 0xEEFEE6;
		public function DatePickerIndicator()
		{
			super();
		}
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(22, 20);
			var g:Graphics=graphics;
			g.clear();
			g.lineStyle(0, getStyle("themeColor"), 0)
			g.beginFill(!this.getStyle("rollOverColor")?0xEEFEE6:this.getStyle("rollOverColor"));
			g.drawRect(4, 0, 22, 20);
			g.endFill();
		}
	}
}