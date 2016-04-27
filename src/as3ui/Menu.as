package as3ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import as3ui.core.CheckLabel;
	import as3ui.core.TextLabel;
	
	import mx.controls.Menu;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import as3ui.evt.MenuEvt;

	[Event(name = "change", type = "as3ui.evt.MenuEvt")]
	
	public class Menu extends UIComponent
	{
		//样式==========================
		public var backgroundAlpha:Number = 1;
		public var backgroundColor:uint = 0xECF4FF;//0xC8DBF0;
		public var borderColor:uint = 0x6293D6;
		public var borderThickness:Number = 0;
		public var color:uint = 0x25381;
		public var overColor:uint = 0xC8F3FF;
		//==============
		public var paddingLeft:Number = 5;//checkbox的左边距
		public var paddingTop:Number = 2;
		public var itemGap:Number = 35;
		public var lineHeight:Number = 26;
		public var itemWidth:Number = 60;
		//===============
		protected var m_oDataProvider:Object;
		//==============
		protected var m_oPopMenu:Menu;
		/**
		 * 菜单组件
		 */
		public function Menu()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		/**
		 * 获取数据源
		 */
		public function get dataProvider():Object
		{
			return m_oDataProvider;
		}
		/**
		 * 设置数据源
		 */
		public function set dataProvider(value:Object):void
		{
			if(m_oDataProvider == value)
			{
				return;
			}
			m_oDataProvider = value;
			updateMenu();
		}
		/**
		 * 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			updateMenuPosition();
			updateGraphics();
		}
		/**
		 * 
		 */
		public function get popMenu():Menu
		{
			return m_oPopMenu;
		}
		/**
		 * 
		 */
		protected function createMenu():Menu
		{
			return new Menu();
		}
		
		//=================================================
		/**
		 * 菜单事件触发：添加弹出菜单
		 */
		protected function onMouseOver(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			if(target is IDataRenderer)
			{
				if(!m_oPopMenu)
				{
					m_oPopMenu = createMenu();
					m_oPopMenu.borderThickness = 1;
					m_oPopMenu.itemGap = itemGap;
					m_oPopMenu.paddingLeft = paddingLeft;
					m_oPopMenu.paddingTop = paddingTop;
					m_oPopMenu.addEventListener(MenuEvt.CHANGE,onPopMenuChange);
				}
				var point:Point = target.localToGlobal(new Point());
				var parentItem:Object = target["data"];
				var menuProvider:Object = parentItem.children;
				updatePopMenu(menuProvider,point);
				var needPopup:Boolean = menuProvider && menuProvider.length>0;
				if(needPopup && !m_oPopMenu.isPopUp)
				{
					PopUpManager.addPopUp(m_oPopMenu,this);
					this.stage.addEventListener(MouseEvent.MOUSE_OVER,onStageOver);
				}else if(!needPopup)
				{
					PopUpManager.removePopUp(m_oPopMenu);
				}
			}
		}
		/**
		 * 弹出菜单事件派发
		 */
		protected function onPopMenuChange(event:MenuEvt):void
		{
			var evt:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
			evt.oriEvent = event.oriEvent;
			evt.data = event.data;
			dispatchEvent(evt);
		}
		/**
		 * 舞台事件触发：删除弹出菜单
		 */
		protected function onStageOver(event:MouseEvent):void
		{
			if(!stage)
			{
				return;
			}
			if(!this.hitTestPoint(event.stageX,event.stageY) && !m_oPopMenu.hitTestPoint(event.stageX,event.stageY))
			{
				PopUpManager.removePopUp(m_oPopMenu);
				m_oPopMenu = null;//释放内存，防止缓存
				if(stage)
				{
					stage.removeEventListener(MouseEvent.MOUSE_OVER,onStageOver);
				}
			}
		}
		/**
		 * 刷新菜单
		 */
		protected function updateMenu():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
			var l:int = m_oDataProvider.length;
			for (var i:int=0;i<l;i++)
			{
				var item:Object = m_oDataProvider[i];
				var menuItem:* = getMenuItem(item);
				menuItem.setStyle("horizontalGap",itemGap);
				menuItem.setStyle("paddingLeft",paddingLeft);
				menuItem.setStyle("paddingTop",paddingTop);
				menuItem["data"] = item;
				addChild(menuItem);
			}
			invalidateDisplayList();
		}
		/**
		 * 菜单改变事件
		 */
		protected function onMenuChange(event:Event):void
		{
			var evt:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
			var currentTarget:Object = event.currentTarget;
			evt.oriEvent = event;
			evt.data = currentTarget.data;
			dispatchEvent(evt);
		}
		//================================
		/**
		 * 获取菜单项
		 */
		protected function getMenuItem(data:Object):DisplayObject
		{
			var menuItem:CheckLabel = new CheckLabel();
			menuItem.backgroundColor = overColor;
			menuItem.mouseChildren = false;
			menuItem.color = color;
			menuItem.position = TextLabel.LEFT;
			menuItem.width = itemWidth;
			menuItem.height = lineHeight;
			menuItem.addEventListener(Event.CHANGE,onMenuChange);
			return menuItem;
		}
		/**
		 * 更新弹出菜单
		 */
		public function updatePopMenu(data:Object,point:Point=null):void
		{
			if(data)
			{
				m_oPopMenu.dataProvider = data;
				m_oPopMenu.width = width>140?width:140;//menuControl
				m_oPopMenu.height = data.length * (lineHeight-2);
				if(point)
				{
					m_oPopMenu.x = point.x + width;
					m_oPopMenu.y = point.y;
				}
			}
		}
		/**
		 * 更新
		 */
		protected function updateMenuPosition():void
		{
			var my:Number = 1;
			for(var i:int =0;i<numChildren;i++)
			{
				var menuItem:DisplayObject = getChildAt(i);
				menuItem.y = my;
				menuItem.visible = unscaledHeight-my>lineHeight-2;
				menuItem.width = unscaledWidth;
				menuItem.height = lineHeight-1;
				my += lineHeight;
			}
		}
		/**
		 * 刷新背景
		 */
		public function updateGraphics():void
		{
			graphics.clear();
			if(borderThickness>0)
			{
				graphics.lineStyle(borderThickness,borderColor);
			}
			graphics.beginFill(backgroundColor,backgroundAlpha);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
	}
}