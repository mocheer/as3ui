package as3ui
{
	import as3ui.evt.MenuEvt;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import as3ui.core.TrianglesLabel;
	
	import mx.controls.Alert;
	import mx.controls.Menu;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	import as3ui.evt.MenuEvt;

	/**
	 * 加载完成
	 */
	[Event(name = "change", type = "plugin.evt.MenuEvt")]
	public class VMenuBox extends UIComponent
	{
		//样式==========================
		public var borderAlpha:Number = 1;
		public var borderThickness:Number = 1;
		public var borderColor:uint = 0x6293D6;
		public var cornorRadius:Number = 2;
		public var headerBackgroundColor:uint = 0xAEC8E8;
		public var headerColor:uint = 0x25381;
		//属性==========================
		public var dragEnabled:Boolean = true;
		public var headerHeight:Number = 26;
		public var state:Number = TrianglesLabel.LEFT;
		public var lineHeight:Number = 28;
		public var tweenHideVars:Object={};
		public var tweenShowVars:Object={};
		public var itemGap:Number = 35;
		public var showArrow:Boolean = true;
		public var isOverToShow:Boolean = false;
		//==============================
		protected var m_oCheckMenu:VMenu;
		protected var m_oTrianglesLabel:TrianglesLabel;
		//==============================
		protected var m_oDataProvider:Object;
		protected var m_oHeaderText:String;
		
		public function VMenuBox()
		{
			super();
		}
		/**
		 *  
		 */
		override public function set initialized(value:Boolean):void
		{
			super.initialized = value;
			if(dragEnabled)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}
			if(isOverToShow)
			{
				m_oTrianglesLabel.mouseEnabled = false;
				m_oCheckMenu.isOverToShow = false;
				tweenHideVars.onComplete = onHideStart;
				tweenShowVars.onComplete = onShowComplete;
				this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			}
		}
		/**
		 * 加载显示对象
		 */
		override protected function createChildren():void
		{
			if(!m_oTrianglesLabel)
			{
				m_oTrianglesLabel = showArrow?new TrianglesLabel(state):new TrianglesLabel();
				m_oTrianglesLabel.backgroundColor = headerBackgroundColor;
				m_oTrianglesLabel.color = headerColor;
				addChild(m_oTrianglesLabel);
				m_oTrianglesLabel.text = m_oHeaderText;
				m_oTrianglesLabel.addEventListener(Event.CHANGE,onArrowChange);
			}
			
			if(!m_oCheckMenu)
			{
				m_oCheckMenu = new VMenu();
				addChild(m_oCheckMenu);
				m_oCheckMenu.itemGap = itemGap;
				m_oCheckMenu.addEventListener(MenuEvt.CHANGE,onMenuChange);
			}
		}
		/**
		 * 设置标题
		 */
		public function set headerText(value:String):void
		{
			m_oHeaderText = value;
			if(m_oTrianglesLabel)
			{
				m_oTrianglesLabel.text = value;
			}
		}
		/**
		 * 
		 */
		public function get headerText():String
		{
			return m_oHeaderText;
		}
		/**
		 * 手动触发第一层的菜单项
		 */
		public function updateMenuSelected(value:Object,searchProvider:Object=null):void
		{
			if(searchProvider==null)searchProvider = m_oDataProvider;
			var index:int = searchProvider.indexOf(value);
			if(index!=-1 && m_oCheckMenu.numChildren>index)
			{
				var menuItem:DisplayObject = m_oCheckMenu.getChildAt(index);
				if(menuItem["data"] == value && menuItem["selected"]!=value.selected)
				{
					menuItem["selected"] = value.selected;
				}
			}
		}
		/**
		 * 设置数据源
		 */
		public function set dataProvider(value:Object):void
		{
			m_oDataProvider = value;
			height = m_oDataProvider.length * lineHeight + headerHeight;
			initTween();
			invalidateDisplayList();
		}
		/**
		 * 初始化缓动动画,一般在组件大小确定后执行。
		 */
		protected function initTween():void
		{
			switch(state)
			{
				case TrianglesLabel.RIGHT:
					width = 27;
				case TrianglesLabel.LEFT:
					tweenHideVars.width = 27;
					tweenShowVars.width = width>100?width:140;
					break;
				case TrianglesLabel.BOTTOM:
					tweenHideVars.height = headerHeight;
					tweenShowVars.height = height;
					height = headerHeight;
					break;
				case TrianglesLabel.TOP:
					tweenHideVars.height = headerHeight;
					tweenShowVars.height = height;
					break;
			}
		}
		/**
		 * 获取数据源
		 */
		public function get dataProvider():Object
		{
			return m_oDataProvider;
		}
		/**
		 * 设置显示对象的大小和位置
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(m_oTrianglesLabel)
			{
				m_oTrianglesLabel.x = 1;
				m_oTrianglesLabel.y = 1;
				m_oTrianglesLabel.width = unscaledWidth - 2;
				m_oTrianglesLabel.height = headerHeight - 2;
				m_oTrianglesLabel.updateGraphics();
				
				if(m_oCheckMenu)
				{
					m_oCheckMenu.width = unscaledWidth - 1;
					m_oCheckMenu.lineHeight = lineHeight;
					m_oCheckMenu.x = 1;
					m_oCheckMenu.y = headerHeight;
					m_oCheckMenu.dataProvider = m_oDataProvider;
					if(m_oTrianglesLabel.state == TrianglesLabel.TOP || m_oTrianglesLabel.state == TrianglesLabel.BOTTOM || m_oTrianglesLabel.state==Number.MIN_VALUE)
					{
						m_oCheckMenu.height = unscaledHeight - headerHeight;
					}
				}
			}
			updateGraphics();
		}
		//方法、事件============================================
		public function updateGraphics():void
		{
			graphics.clear();
			graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
			graphics.drawRoundRectComplex(0,0,width,height,cornorRadius,cornorRadius,cornorRadius,cornorRadius);
		}
		/**
		 * 
		 */
		protected function onArrowChange(event:Event):void
		{
			state = m_oTrianglesLabel.state;
			switch(state)
			{
				case TrianglesLabel.LEFT:
				case TrianglesLabel.TOP:
					show();
					break;
				case TrianglesLabel.RIGHT:
				case TrianglesLabel.BOTTOM:
					hide();
					break;
			}
		}
		/**
		 * 
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			if(state==TrianglesLabel.RIGHT || state==TrianglesLabel.BOTTOM)
			{
				m_oTrianglesLabel.changeState(state);
			}
			stage.addEventListener(MouseEvent.MOUSE_OVER,onStageOver);
		}
		/**
		 * 
		 */
		protected function onStageOver(event:MouseEvent):void
		{
			if(this.hitTestPoint(event.stageX,event.stageY))
			{
				return;
			}
			if(m_oCheckMenu.popMenu && m_oCheckMenu.popMenu.hitTestPoint(event.stageX,event.stageY))
			{
				return;
			}
			if(state==TrianglesLabel.LEFT || state==TrianglesLabel.TOP)
			{
				m_oTrianglesLabel.changeState(state);
			}
			stage.removeEventListener(MouseEvent.ROLL_OUT,onStageOver);
		}
		/**
		 * 
		 */
		protected function onMenuChange(event:MenuEvt):void
		{
			var evt:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
			evt.oriEvent = event.oriEvent;
			evt.data = event.data;
			dispatchEvent(evt);
		}
		/**
		 * 鼠标按下事件派发：拖动
		 */
		protected function onMouseDown(event:MouseEvent):void
		{
			stopDrag();
			var point:Point = this.globalToLocal(new Point(event.stageX,event.stageY));
			if(point.y > headerHeight)
			{
				return;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			startDrag();
		}
		/**
		 * 鼠标弹出事件派发：拖动
		 */
		protected function onMouseUp(event:Event):void
		{
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		/**
		 * 隐藏
		 */
		public function hide(duration:Number=0.3):void
		{
			TweenLite.to(this,duration,tweenHideVars);
		}
		/**
		 * 显示
		 */
		public function show(duration:Number=0.3):void
		{
			TweenLite.to(this,duration,tweenShowVars);
		}
		/**
		 * 
		 */
		protected function onHideStart():void
		{
			m_oCheckMenu.isOverToShow = false;
		}
		/**
		 * 
		 */
		protected function onShowComplete():void
		{
			m_oCheckMenu.isOverToShow = true;
		}
	}
}