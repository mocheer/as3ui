package as3ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	import as3ui.evt.MenuEvt;
	import as3ui.ex.checkbox.CheckBoxEx;
	import as3ui.ex.RadioButtonEx;

	public class VMenu extends Menu
	{
		public static const Type_CheckBoxEx:int = 0;
		public static const Type_RadioButtonEx:int = 1;
		//
		public var iconWidth:Number = 25; //用于绘制分割线和缩放时的最小宽度
		//
		protected var radioItemSelected:Object;
		/**
		 * 
		 */
		public function VMenu()
		{
			super();
		}
	
		override protected function createMenu():Menu
		{
			return new VMenu();
		}
		
		override public function set dataProvider(value:Object):void
		{
			super.dataProvider = value;
			height = value.length*lineHeight;
		}
		//=============================================
		/**
		 * 鼠标停留是否自动展开：默认为true
		 */
		public function set isOverToShow(value:Boolean):void
		{
			if(value)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			}else
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			}
		}
		
		/**
		 *
		 */
		override protected function getMenuItem(data:Object):DisplayObject
		{
			var menuItem:DisplayObject;
			switch(data.type)
			{
				case Type_CheckBoxEx:
					menuItem = new CheckBoxEx();
					break;
				case Type_RadioButtonEx:
					menuItem = new RadioButtonEx();
					if(data.selected)
					{
						radioItemSelected = data;
					}
					break;
				default:
					menuItem = new CheckBoxEx();
					break
			}
			if(!data.children || !data.children.length)
			{
				menuItem.addEventListener(Event.CHANGE,onMenuChange);
			}
			menuItem.height = lineHeight;
			return menuItem;
		}
		
		/**
		 * 单选
		 */
		override protected function onMenuChange(event:Event):void
		{
			var currentTarget:Object = event.currentTarget;
			if(currentTarget is RadioButtonEx)
			{
				if(!radioItemSelected)
				{
					radioItemSelected = currentTarget.data;
				}else if(radioItemSelected!=currentTarget.data)
				{
					var oEvt:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
					oEvt.data = radioItemSelected;
					radioItemSelected.selected = false;
					dispatchEvent(oEvt);
					radioItemSelected = currentTarget.data;
				}
			}
			super.onMenuChange(event);
		}
	
		/**
		 * 刷新背景
		 */
		override public function updateGraphics():void
		{
			super.updateGraphics();
			
			graphics.lineStyle(1,0xB9CDE9,1);
			graphics.moveTo(iconWidth,borderThickness);
			graphics.lineTo(iconWidth,height);
			var l:int = m_oDataProvider?m_oDataProvider.length:0;
			for (var i:int=1;i<l;i++)
			{
				var my:int = lineHeight * i;
				if(my>height)
				{
					break;
				}
				graphics.moveTo(iconWidth,my);
				graphics.lineTo(width,my);
			}
			
		}
	
	}
}