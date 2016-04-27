package as3ui
{
	import as3lib.helper.evt.EventHelper;
	
	import as3ui.core.TextLabel;
	import as3ui.core.TrianglesLabel;
	import as3ui.core.TrianglesSprite;
	import as3ui.evt.MenuEvt;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.containers.TabNavigator;
	import mx.core.UIComponent;
	
	[Event(name = "change", type = "as3ui.evt.MenuEvt")]
	[Event(name = "stateChange", type = "as3ui.evt.MenuEvt")]
	
	public class ModuleBox extends UIComponent
	{
		//样式==========================
		public var borderAlpha:Number = 1;//边框透明度
		public var borderThickness:Number = 1;//
		public var borderColor:uint = 0x6293D6;
		public var cornorRadius:Number = 5;
		public var backgroundAlpha:Number = 1;
		public var backgroundColor:uint = 0xECF4FF;//0xC8DBF0;
		public var buttonOffsetY:Number = 10;
		public var buttonHeight:Number = 30;
		public var itemWidth:Number = 28;
		public var itemHeight:Number = 30;
		public var state:Number = TrianglesLabel.RIGHT;
		public var showThumbnail:Boolean = false;
		public var trianglesColor:uint = 0x23699E;//0x004C96
		protected var m_oThumbnail:Loader;//todo
		//
		protected var m_oEnabeldW:Boolean = false;
		protected var m_oRangeY:Number = 50;
		protected var m_oDataProvider:Object;
		protected var m_oToolProvider:Object;
		protected var m_oOptionProvider:Object;
		protected var m_oSelectedItem:Object;
		//
		protected var m_oModuleMenu:Sprite;
		protected var m_oToolMenu:Sprite;
		protected var m_oOptionMenu:Sprite;
		//
		protected var m_oTrianglesSprite:TrianglesSprite;
		protected var m_oTab:TabNavigator;
		protected var m_oTipLabel:TextLabel;
		protected var m_oTipData:Object;
		//
		[Bindable]
		[Embed(source="res/images/cur/hcur32.png")]
		protected var hcur:Class;
		
		public function ModuleBox()
		{
			super();
		}
		/**
		 * 
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!m_oTrianglesSprite)
			{
				m_oTrianglesSprite = new TrianglesSprite();
				m_oTrianglesSprite.buttonMode = true;
				m_oTrianglesSprite.addEventListener(MouseEvent.CLICK,onMouseClick);
				m_oTrianglesSprite.updateGraphics(state * Math.PI,7,trianglesColor);
				addChild(m_oTrianglesSprite);
			}
			if(!m_oToolMenu)
			{
				m_oToolMenu = new Sprite();
				m_oToolMenu.visible = false;
				if(m_oToolProvider)
				{
					initMenu(m_oToolMenu,m_oToolProvider);
				}
				m_oToolMenu.buttonMode = true;
				m_oToolMenu.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				m_oToolMenu.addEventListener(MouseEvent.CLICK,onToolClick);
				addChild(m_oToolMenu);
			}
			
			if(!m_oModuleMenu)
			{
				m_oModuleMenu = new Sprite();
				m_oModuleMenu.visible = false;
				m_oModuleMenu.buttonMode = true;
				m_oModuleMenu.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				m_oModuleMenu.addEventListener(MouseEvent.CLICK,onModuleMenuClick);
				addChild(m_oModuleMenu);
			}
			
			if(!m_oTab)
			{
				m_oTab = new TabNavigator();
				m_oTab.setStyle("paddingTop",2);
				addChild(m_oTab);
				this.addEventListener(MouseEvent.MOUSE_OVER,onBoardMouseOver);
			}
		}
		/**
		 * 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(m_oTrianglesSprite)
			{
				m_oTrianglesSprite.x = 14;
				m_oTrianglesSprite.y = buttonOffsetY +14;;
			}
			if(m_oTab)
			{
				m_oTab.x = itemWidth+5;
				m_oTab.y = 2;
				m_oTab.height = height -2;
				m_oTab.width = unscaledWidth-m_oTab.x;
			}
			updateMenuPosition();
			updateGraphics();
		}
		//事件方法====================================
		/**
		 * 伸缩按钮点击事件
		 */
		protected function onMouseClick(event:Event):void
		{
			switch(state)
			{
				case TrianglesLabel.RIGHT:
					hide();
					break;
				case TrianglesLabel.LEFT:
					show();
					break;
			}
			m_oTrianglesSprite.updateGraphics(state * Math.PI,7,trianglesColor);
		}
		/**
		 * 显示
		 */
		public function show():void
		{
			if(state!=TrianglesLabel.RIGHT)
			{
				TweenLite.killTweensOf(this,true);//保证事件触发
				TweenLite.to(this,0.5,{x:parent.width-width,onComplete:onStateChangeEnd});
				state = TrianglesLabel.RIGHT;
				m_oTrianglesSprite.updateGraphics(state * Math.PI,7,trianglesColor);
				if(m_oThumbnail)
				{
					removeChild(m_oThumbnail);
					m_oThumbnail = null;
				}
			}
		}
		/**
		 * 隐藏
		 */
		public function hide():void
		{
			if(state!=TrianglesLabel.LEFT)
			{
				TweenLite.killTweensOf(this,true);//保证事件触发
				TweenLite.to(this,0.5,{x:parent.width-itemWidth,onComplete:onStateChangeEnd});
				state = TrianglesLabel.LEFT;
				m_oTrianglesSprite.updateGraphics(state * Math.PI,7,trianglesColor);
				if(showThumbnail && m_oSelectedItem)
				{
					m_oThumbnail = new Loader;
					m_oThumbnail.load(new URLRequest(m_oSelectedItem.thumbnail));
					addChild(m_oThumbnail);
				}
			}
		}
		/**
		 * 状态结束
		 */
		protected function onStateChangeEnd():void
		{
			var dispatcherEvent:MenuEvt = new MenuEvt(MenuEvt.STATE_CHANGE);
			dispatchEvent(dispatcherEvent);
		}
		
		/**
		 * 设置数据源
		 */
		public function set dataProvider(value:Object):void
		{
			m_oDataProvider = value;
			initMenu(m_oModuleMenu,value);
			selectedItem = value[value.length-1];
			invalidateDisplayList();
		}
		/**
		 * 设置工具栏
		 */
		public function set toolBar(value:Object):void
		{
			m_oToolProvider = value;
			if(m_oToolMenu)
			{
				initMenu(m_oToolMenu,m_oOptionProvider);
				invalidateDisplayList();
			}
		}
		
		public function set optionBar(value:Object):void
		{
			m_oOptionProvider = value;
			if(m_oOptionProvider)
			{
				if(!m_oOptionMenu)
				{
					m_oOptionMenu = new Sprite();
					m_oOptionMenu.buttonMode = true;
					m_oOptionMenu.addEventListener(MouseEvent.CLICK,onOptionClick);
					addChild(m_oOptionMenu);
				}
				initMenu(m_oOptionMenu,m_oOptionProvider);
				invalidateDisplayList();
			}
		}
		
		/**
		 * 
		 */
		protected function onOptionClick(event:Event):void
		{
			var loader:Loader = event.target as Loader;
			if(loader)
			{
				var index:int = m_oOptionMenu.getChildIndex(loader);
				var data:Object = m_oOptionProvider[index];
				switch(data.type)
				{
					case 1:
						var icon:String = data.icon;
						data.selected = !data.selected;
						if(data.selected)
						{
							var iconUrl:Array = icon.split(".");
							icon = iconUrl[0]+"_selected."+iconUrl[1];
						}
						loader.load(new URLRequest(icon));
						break;
					default:
						break;
				}
				switch(data.tool)
				{
					case "td":
						if(data.selected)
						{
							removeChild(m_oTrianglesSprite);
						}else
						{
							addChildAt(m_oTrianglesSprite,0);
						}
						invalidateDisplayList();
						break;
					default:
						break;
				}
			}
			var dispathchEvent:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
			dispathchEvent.data = data;
			dispatchEvent(dispathchEvent);
		}
		
		/**
		 * 选中项
		 */
		public function set selectedItem(value:Object):void
		{
			if(m_oSelectedItem!=value)
			{
				m_oSelectedItem = value;
				while(m_oTab.numChildren>0)
				{
					m_oTab.removeChildAt(0);
				}
				if(value)
				{
					var module:* = value.content;
					if(module is DisplayObject)
					{
						m_oTab.addChild(module);
					}else if("contents" in module)
					{
						for each(var content:* in module.contents)
						{
							m_oTab.addChild(content);
						}
					}else if("content" in module)
					{
						m_oTab.addChild(module.content);
					}
				}
			}
		}
		
		/**
		 * 
		 */
		public function get dataProvider():Object
		{
			return m_oDataProvider;
		}
		
		
		/**
		 * 
		 */
		public function addTab(data:Object):void
		{
			if(!m_oDataProvider)
			{
				m_oDataProvider = [data];
			}else
			{
				m_oDataProvider.push(data);
			}
			if(data.icon)
			{
				var loader:Loader = new Loader();
				m_oModuleMenu.addChild(loader);
				loader.load(new URLRequest(data.icon));
			}
			selectedItem = data;
			invalidateDisplayList();
		}
		
		public function removeAllTab():void
		{
			m_oDataProvider = [];
			while(m_oModuleMenu.numChildren>0)
			{
				m_oModuleMenu.removeChildAt(0);
			}
			selectedItem = null;
			hide();
			invalidateDisplayList();
		}
		/**
		 * 
		 */
		public function removeTab(data:Object,hideEnabled:Boolean=true):void
		{
			var index:int = m_oDataProvider.indexOf(data);
			if(index!=-1)
			{
				if(m_oModuleMenu.numChildren === m_oDataProvider.length)
				{
					m_oModuleMenu.removeChildAt(index);
				}
				m_oDataProvider.splice(index,1);
			}
			if(m_oSelectedItem == data)
			{
				if(m_oDataProvider && m_oDataProvider.length>0)
				{
					selectedItem = m_oDataProvider[m_oDataProvider.length-1];
				}else
				{
					selectedItem = null;
					if(hideEnabled)
					{
						hide();
					}
				}
			}
			invalidateDisplayList();
		}
		/**
		 * 初始化菜单
		 */
		protected function initMenu(menu:DisplayObjectContainer,value:Object):void
		{
			while(menu.numChildren>0)
			{
				menu.removeChildAt(0);
			}
			var num:int = value.length;
			for (var i:int=0;i<num;i++)
			{
				var item:Object = value[i];
				var loader:Loader = new Loader();
				loader.load(new URLRequest(item.icon));
				menu.addChild(loader);
			}
		}
		/**
		 * 
		 */
		protected function onMouseOver(event:Event):void
		{
			var loader:Loader = event.target as Loader;
			if(loader)
			{
				var index:int;
				var data:Object;
				var showButton:Boolean = false;
				switch(event.currentTarget)
				{
					case m_oModuleMenu:
						index = m_oModuleMenu.getChildIndex(loader);
						data = m_oDataProvider[index];
						showButton = true;
						break;
					case m_oToolMenu:
						index = m_oToolMenu.getChildIndex(loader);
						data = m_oToolProvider[index];
						break;
				}
				if(!m_oTipLabel)
				{
					m_oTipLabel = new TextLabel();
					m_oTipLabel.addEventListener("CloseClick",onCloseClick);
					m_oTipLabel.autoSize = true;
					addChild(m_oTipLabel);
				}
				m_oTipLabel.alpha = 1;
				m_oTipData = data;
				m_oTipLabel.text = data.label;
				m_oTipLabel.x = -(m_oTipLabel.width+2);
				m_oTipLabel.y = loader.y+3;
				m_oTipLabel.showCloseButton = showButton;
				m_oTipLabel.updateGraphics();
				TweenLite.to(m_oTipLabel,0.1,{delay:3,alpha:0,onStart:onTweenStart});
			}
		}
		/**
		 * 
		 */
		protected function onCloseClick(event:Event):void
		{
			var menuEvt:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
			if(m_oTipData.selected)
			{
				m_oTipLabel.alpha = 0;
				m_oTipData.selected = false;
				menuEvt.data = m_oTipData;
				EventHelper.getInstance().get("MenuBox").dispatchEvent(menuEvt);
			}
		}
		/**
		 * 
		 */
		protected function onTweenStart():void
		{
			
		}
		/**
		 * 
		 */
		protected function onModuleMenuClick(event:Event):void
		{
			var loader:Loader = event.target as Loader;
			if(loader)
			{
				var index:int = m_oModuleMenu.getChildIndex(loader);
				var data:Object = m_oDataProvider[index];
				selectedItem = data;
			}
		}
		/**
		 * 
		 */
		protected function onToolClick(event:Event):void
		{
			var loader:Loader = event.target as Loader;
			if(loader)
			{
				var index:int = m_oToolMenu.getChildIndex(loader);
				var data:Object = m_oToolProvider[index];
				var dispathchEvent:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
				dispathchEvent.data = data;
				dispatchEvent(dispathchEvent);
			}
		}
		/**
		 * 
		 */
		protected function onBoardMouseOver(event:MouseEvent):void
		{
			if(event.buttonDown)return;
			var enabeldW:Boolean = Math.abs(event.localX - itemWidth)<5  && event.localY>m_oRangeY;
			if(m_oEnabeldW == enabeldW)return;
			m_oEnabeldW = enabeldW;
			if(m_oEnabeldW)
			{
				cursorManager.setCursor(hcur,2,-12,-10);
				this.addEventListener(MouseEvent.MOUSE_DOWN,onBoardMouseDown);
				this.addEventListener(MouseEvent.MOUSE_OUT,onBoardMouseOut);
				
			}else
			{
				cursorManager.removeAllCursors();
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onBoardMouseDown);
			}
		}
		/**
		 * 
		 */
		protected function onBoardMouseOut(event:MouseEvent):void
		{
			if(!event.buttonDown && m_oEnabeldW)
			{
				m_oEnabeldW = false;
				cursorManager.removeAllCursors();
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onBoardMouseDown);
			}
		}
		/**
		 * 按钮按下事件
		 */
		protected function onBoardMouseDown(event:MouseEvent):void
		{
			if(m_oEnabeldW)
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER,onBoardMouseOver);
				stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			}
		}
		/**
		 * 舞台弹出事件
		 */
		protected function onStageMouseUp(event:MouseEvent):void
		{
			if(m_oEnabeldW)
			{
				m_oEnabeldW = false;
				cursorManager.removeAllCursors();
				x = event.stageX-itemWidth;
				width = stage.width - x;
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onBoardMouseDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
				this.addEventListener(MouseEvent.MOUSE_OVER,onBoardMouseOver);
			}
		}
		/**
		 * 刷新菜单位置
		 */
		protected function updateMenuPosition():void
		{

			var my:Number = (m_oThumbnail?m_oThumbnail.height:buttonHeight+buttonOffsetY)+30;
			var updateMenu:Function = 
				function (menu:DisplayObjectContainer,offsetX:Number=10,offsetY:Number=0):void
				{
					var num:int = menu.numChildren;
					if(num==0)return;
					for (var i:int = 0;i<num;i++)
					{
						var child:DisplayObject = menu.getChildAt(i);
						child.x = offsetX;
						child.y = my+offsetY;
						my +=itemHeight;
					}
					my += 30 ;
				}
			updateMenu(m_oToolMenu);
			updateMenu(m_oModuleMenu,2,-5);
			if(m_oOptionMenu)
			{
				m_oOptionMenu.y = 5;
				var mx:Number = unscaledWidth - itemHeight+3;
				var num:int = m_oOptionMenu.numChildren;
				for (var i:int = 0;i<num;i++)
				{
					var child:DisplayObject = m_oOptionMenu.getChildAt(i);
					child.x = mx;
					mx -=itemHeight;
				}
			}
			if(!m_oToolMenu.visible && m_oToolMenu.numChildren>0)m_oToolMenu.visible = true;
			if(!m_oModuleMenu.visible && m_oModuleMenu.numChildren>0)m_oModuleMenu.visible = true;
		}
		/**
		 * 刷新背景
		 */
		protected function updateGraphics():void
		{
			var my:Number = 0;
			
			graphics.clear();
			graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
			graphics.beginFill(backgroundColor,backgroundAlpha);
			graphics.moveTo(width,0);
			graphics.lineTo(itemWidth,0);
			graphics.lineTo(itemWidth,buttonOffsetY);
			
			if(m_oThumbnail)
			{
				my += m_oThumbnail.height;
			}else if(contains(m_oTrianglesSprite))
			{
				graphics.lineTo(cornorRadius,buttonOffsetY);
				graphics.curveTo(0,buttonOffsetY+cornorRadius,cornorRadius,buttonOffsetY+cornorRadius);
				graphics.lineTo(0,buttonOffsetY+buttonHeight);
				
				my += buttonOffsetY+buttonHeight;
				graphics.curveTo(cornorRadius,my+cornorRadius,cornorRadius,my);
				graphics.lineTo(itemWidth,my+cornorRadius);
				my += cornorRadius;
			}else
			{
				my += buttonOffsetY+buttonHeight+cornorRadius;
			}
			var drawMenu:Function = function(menuLength:int):void
			{
				if(menuLength>0)
				{
					my += 10;
					graphics.lineTo(itemWidth,my);
					my += 10;
					graphics.lineTo(cornorRadius*0.5,my);
					
					my += menuLength*itemHeight;
					graphics.lineTo(cornorRadius*0.5,my);
					my += 10;
					graphics.lineTo(itemWidth,my);
				}
			}
			drawMenu(m_oToolMenu.numChildren);
			drawMenu(m_oModuleMenu.numChildren);
			m_oRangeY = my;
		 	graphics.lineTo(itemWidth,height);
			graphics.lineTo(width,height);
			graphics.lineTo(width,0);
			graphics.endFill();
		}
	}
}