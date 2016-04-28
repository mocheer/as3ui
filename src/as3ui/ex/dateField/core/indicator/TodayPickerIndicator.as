package as3ui.ex.dateField.core.indicator
{
	import flash.display.Graphics;
	import mx.skins.halo.DateChooserIndicator;
	/**
	 * @author gyb
	 * @date：2014-12-23 下午02:29:29
	 * datechooser当前时间显示的背景皮肤
	 */
	public class TodayPickerIndicator extends DateChooserIndicator
	{
		public function TodayPickerIndicator()
		{
			super();
		}
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(22, 20);
			var g:Graphics=graphics;
			
			
			g.clear();
			g.lineStyle(0, getStyle("themeColor"), 0)
			g.beginFill(!this.getStyle("todayColor")?0x818181:this.getStyle("todayColor"));
			g.drawRect(4, 0, 22, 20);
			g.endFill();
		}
	}
}