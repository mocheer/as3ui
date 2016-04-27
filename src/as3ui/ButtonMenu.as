package as3ui
{
	import as3ui.evt.MenuEvt;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	
	public class ButtonMenu extends UIComponent
	{
		protected var m_oDataProvider:Object;
		public var itemWidth:Number = 68;
		public function ButtonMenu()
		{
			super();
			buttonMode = true;
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		public function set dataProvider(value:Object):void
		{
			m_oDataProvider = value;
			if(m_oDataProvider)
			{
				var l:int = m_oDataProvider.length;
				var i:int = 0;
				var data:Object;
				var mx:Number = 0;
				for(;i<l;i++)
				{
					data = m_oDataProvider[i];
					var loader:Loader = createButton(data);
					loader.x = mx;
					addChild(loader);
					mx += itemWidth;
				}
			}
		}
		/**
		 * 
		 */
		protected function createButton(data:Object):Loader
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(data.url));
			return loader;
		}
		
		/**
		 * 
		 */
		protected function onMouseClick(event:Event):void
		{
			var loader:Loader = event.target as Loader;
			if(loader)
			{
				var index:int = getChildIndex(loader);
				var menuEvt:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
				menuEvt.data = m_oDataProvider[index];
				dispatchEvent(menuEvt);
			}
		}
	}
}