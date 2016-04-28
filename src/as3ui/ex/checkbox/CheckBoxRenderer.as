package as3ui.ex.checkbox
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.controls.CheckBox;
	
	/**
	 * @author gyb
	 * @date：2015-3-25 下午03:45:31
	 */
	public class CheckBoxRenderer extends CheckBox
	{
		private var _loader:Loader;
		private var _icon:String;
		public function CheckBoxRenderer()
		{
			super();
			this.width = 120;
			this.addEventListener(Event.CHANGE,onClickCheckBox);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(!_loader && _icon)
			{
				_loader = new Loader();
				_loader.load(new URLRequest(_icon));
				addChild(_loader);
			}
		}
		/**
		 * @param value  {selected:选中状态，label：文本，enabled：灰色关闭状态}
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value !=null)
			{
				this.selected = value.selected;
				this.label = value.label;
				_icon = value.icon;
			}
		}
		
		//此属性可设置 数据源任意一项不可选 （enabled）
		override public function set enabled(value:Boolean):void
		{ 
			if(data && "enabled" in data)
			{
				value = data.enabled;
			}
			super.enabled=value;
		}
		
		
		private function onClickCheckBox(e:Event):void
		{    
			if(data)
			{
				data.selected = this.selected;
			}
		}
	}
}
