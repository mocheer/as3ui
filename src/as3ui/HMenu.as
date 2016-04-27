package as3ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Button;
	import mx.managers.PopUpManager;
	
	import as3ui.evt.MenuEvt;
	import as3ui.core.CheckLabel;

	public class HMenu extends Menu
	{
		/**
		 * 
		 */
		public function HMenu()
		{
			super();
			itemGap = 15;
		}
		
		override public function set dataProvider(value:Object):void
		{
			super.dataProvider = value;
			width = value.length * itemWidth;
		}
		//=================================================
		/**
		 * 
		 */
		override public function updatePopMenu(data:Object,point:Point=null):void
		{
			if(data)
			{
				m_oPopMenu.dataProvider = data;
				//TODO
				m_oPopMenu.width = (itemWidth>100?itemWidth-2:itemWidth+itemWidth-2);
				m_oPopMenu.height = data.length * lineHeight + 1;
				if(point)
				{
					m_oPopMenu.x = point.x ;
					m_oPopMenu.y = point.y + height;
				}
			}
		}
		
		/**
		 * 更新菜单项位置
		 */
		override protected function updateMenuPosition():void
		{
			var mx:Number = 1;
			for(var i:int =0;i<numChildren;i++)
			{
				var menuItem:CheckLabel = getChildAt(i) as CheckLabel;
				menuItem.paddingTop = 4;
				menuItem.width = itemWidth -2;
				menuItem.y = 1;
				menuItem.height = height-2;
				menuItem.x = mx;
				mx += itemWidth;
				menuItem.updateGraphics();
			}
		}
		
		/**
		 * 刷新背景
		 */
		override public function updateGraphics():void
		{
			graphics.clear();
			graphics.lineStyle(1,0xB9CDE9,1);
			graphics.beginFill(backgroundColor,backgroundAlpha);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			var l:int = m_oDataProvider?m_oDataProvider.length:0;
			for (var i:int=1;i<l;i++)
			{
				var mx:int = itemWidth * i;
				graphics.moveTo(mx,0);
				graphics.lineTo(mx,height);
			}
		}
	}
}