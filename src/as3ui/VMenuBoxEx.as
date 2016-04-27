package as3ui
{
	import flash.display.Graphics;
	import flash.events.Event;
	
	import mx.core.mx_internal;
	
	import as3ui.evt.MenuEvt;
	import as3ui.core.TrianglesLabel;

	public class VMenuBoxEx extends VMenuBox
	{
		public function VMenuBoxEx()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			
		}
		
		override public function set headerText(value:String):void
		{
			m_oHeaderText = value;
		}
		/**
		 * 设置数据源
		 */
		override public function set dataProvider(value:Object):void
		{
			m_oDataProvider = value;
			var numItemChild:int = 0;
			for each(var item:Object in m_oDataProvider)
			{
				numItemChild += item.children.length;
			}
			updateMenu();
			initTween();
			invalidateDisplayList();
		}
		
		/**
		 * 设置显示对象的大小和位置
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var l:int = m_oDataProvider.length;
			var my:int = 1;
			for (var i:int=0;i<l;i++)
			{
				var childIndex:int = i*2;
				var item:Object = m_oDataProvider[i];
				var menuProvider:Object = item.children;
				
				m_oTrianglesLabel = getChildAt(childIndex) as TrianglesLabel;
				m_oTrianglesLabel.x = 1;
				m_oTrianglesLabel.y = my;
				m_oTrianglesLabel.width = unscaledWidth - 2;
				m_oTrianglesLabel.height = headerHeight - 2;
				my += headerHeight-2;
				m_oTrianglesLabel.updateGraphics();
				m_oCheckMenu = getChildAt(childIndex+1) as VMenu;
				
				m_oCheckMenu.visible = m_oTrianglesLabel.state == TrianglesLabel.TOP;
				if(m_oCheckMenu.visible)
				{
					m_oCheckMenu.width = width - 1;
					m_oCheckMenu.lineHeight = lineHeight ;
					m_oCheckMenu.x = 1;
					m_oCheckMenu.y = my;
					m_oCheckMenu.dataProvider = menuProvider;
					my += m_oCheckMenu.height;
				}else if(i!=l-1)//分割线
				{
					var graphics:Graphics = m_oTrianglesLabel.graphics;
					graphics.lineStyle(borderThickness, 0xFFFFFF, borderAlpha * 0.5, true);
					graphics.moveTo(-1,m_oTrianglesLabel.height);
					graphics.lineTo(m_oTrianglesLabel.width+1,m_oTrianglesLabel.height);
				}else
				{
					my+=1;
				}
			}
			mx_internal::_height = my;
			updateGraphics();
		}
		//
		override public function updateMenuSelected(value:Object,searchProvider:Object=null):void
		{
			var childIndex:int = 1;
			for (var i:int=0;i<m_oDataProvider.length;i++)
			{
				searchProvider = m_oDataProvider[i].children;
				childIndex+=2*i;
				m_oCheckMenu = this.getChildAt(childIndex) as VMenu;
				if(m_oCheckMenu)
				{
					super.updateMenuSelected(value,searchProvider);
				}
				
			}
		}
		//
		public function updateMenu():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
			var l:int = m_oDataProvider.length;
			for (var i:int=0;i<l;i++)
			{
				var item:Object = m_oDataProvider[i];
				m_oTrianglesLabel = new TrianglesLabel("state" in item?item.state:TrianglesLabel.TOP);
				m_oTrianglesLabel.color = headerColor;
				addChild(m_oTrianglesLabel);
				m_oTrianglesLabel.text = item.label;
				m_oTrianglesLabel.addEventListener(Event.CHANGE,onArrowChange);
				m_oTrianglesLabel.backgroundColor = headerBackgroundColor;
				m_oCheckMenu = new VMenu();
				addChild(m_oCheckMenu);
				m_oCheckMenu.itemGap = itemGap;
				m_oCheckMenu.addEventListener(MenuEvt.CHANGE,onMenuChange);
			}
		}
		/**
		 * 隐藏
		 */
		override public function hide(duration:Number=0.3):void
		{
			invalidateDisplayList();
		}
		/**
		 * 显示
		 */
		override public function show(duration:Number=0.3):void
		{
			invalidateDisplayList();
		}
	}
}