package as3ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	import as3ui.evt.MenuEvt;
	import as3ui.core.TileText;
	import as3ui.core.VerticalLabel;
	
	[Event(name = "change", type = "as3ui.evt.MenuEvt")]
	public class TextBox extends UIComponent
	{
		//样式==========================
		public var borderAlpha:Number = 1;
		public var borderThickness:Number = 1;
		public var borderColor:uint = 0xB9CDE9;//0x6293D6
		public var cornorRadius:Number = 2;
		public var paddingTop:Number = 2;
		public var paddingLeft:Number = 10;
		public var headerHeight:Number = 22;
		//
		protected var m_oDataProvider:Object;
		protected var m_oSelectedItem:Object;
		protected var m_oMenuHeight:Number;
		//
		protected var m_oHeaderText:HeaderText;
		protected var m_oTileText:TileText;
		protected var m_oTextMenu:Sprite;
		protected var m_oHeaderTexts:Array;
		//
		public function TextBox()
		{
			super();
		}
		/**
		 * 
		 */
		override protected function createChildren():void
		{
			if(!m_oHeaderText)
			{
				m_oHeaderText = new HeaderText();
				m_oHeaderText.height = headerHeight;
				m_oHeaderText.addEventListener(MenuEvt.CHANGE,onHeaderMenuChange);
				addChild(m_oHeaderText);
			}
			if(!m_oTileText)
			{
				m_oTileText = new TileText();
				m_oTileText.width = width- paddingLeft;
				m_oTileText.addEventListener(MenuEvt.CHANGE,onMenuChange);
				addChild(m_oTileText);
			}
		}
		/**
		 * 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(m_oHeaderText)
			{
				m_oHeaderText.x = paddingLeft;
				m_oHeaderText.y = paddingTop;
				m_oHeaderText.width = unscaledWidth;
			}
			if(m_oTileText)
			{
				m_oTileText.x = paddingLeft;
				m_oTileText.y = headerHeight;
				m_oTileText.width = unscaledWidth - paddingLeft;
			}
			updateGrphics();
		}
		/**
		 * 
		 */
		public function set dataProvider(value:Object):void
		{
			m_oDataProvider = value;
			if(m_oDataProvider is Array)
			{
				if(m_oDataProvider.length>1)
				{
					m_oTextMenu = new Sprite();
					m_oTextMenu.addEventListener(MouseEvent.CLICK,onMenuClick);
					m_oTextMenu.x = 2;
					var my:Number = 0;
					for(var i:int =0;i<m_oDataProvider.length;i++)
					{
						var item:Object = m_oDataProvider[i];
						var menuItem:VerticalLabel = new VerticalLabel();
						menuItem.backgroundColor = 0xC8F3FF;
						menuItem.buttonMode = true;
						menuItem.mouseChildren = false;
						menuItem.text = item.type;
						menuItem.y = my;
						if(i==0)
						{
							menuItem.selected = true;
							menuItem.updateGraphics();
						}
						m_oTextMenu.addChild(menuItem);
						
						my += menuItem.height;
					}
					m_oMenuHeight = my;
					addChild(m_oTextMenu);
					paddingLeft += 20;
				}
				selectedItem =  m_oDataProvider[0];
			}else
			{
				selectedItem = m_oDataProvider;
			}
			m_oHeaderText.addText(m_oSelectedItem);
			
		}
		
		public function set selectedItem(value:Object):void
		{
			if(m_oSelectedItem!=value)
			{
				m_oSelectedItem = value;
				if(m_oTileText)
				{
					m_oTileText.data = m_oSelectedItem.children;
					var tileHeight:Number = m_oTileText.height + headerHeight;
					height = m_oMenuHeight>tileHeight?m_oMenuHeight:tileHeight;
				}
			}
			
		}
		
		protected function onMenuClick(event:Event):void
		{
			if(!m_oHeaderTexts)
			{
				m_oHeaderTexts = [m_oHeaderText];
			}
			var target:DisplayObject = event.target as DisplayObject;
			var oldIndex:int =  m_oHeaderTexts.indexOf(m_oHeaderText);
			setMenuState(oldIndex,false);
			var index:int = m_oTextMenu.getChildIndex(target);
			setMenuState(index,true);
			if(index>-1)
			{
				removeChild(m_oHeaderText);
				if(!m_oHeaderTexts[index])
				{
					m_oHeaderText = new HeaderText();
					m_oHeaderText.height = headerHeight;
					m_oHeaderText.addEventListener(MenuEvt.CHANGE,onHeaderMenuChange);
					m_oHeaderTexts[index] = m_oHeaderText;
					m_oHeaderText.addText(m_oDataProvider[index]);
					invalidateDisplayList();
				}
				m_oHeaderText = m_oHeaderTexts[index]
				addChild(m_oHeaderText);
				
				selectedItem = m_oDataProvider[index];
			}
		}
		
		protected function setMenuState(index:int,selected:Boolean):void
		{
			var menuItem:VerticalLabel = m_oTextMenu.getChildAt(index) as VerticalLabel;
			if(menuItem && menuItem.selected!=selected)
			{
				menuItem.selected = selected;
				menuItem.updateGraphics();
			}
		}
		
		protected function onMenuChange(event:MenuEvt):void
		{
			var data:Object = event.data;
			if("children" in data)
			{
				m_oHeaderText.addText(data);
				m_oTileText.data = data.children;
				var tileHeight:Number = m_oTileText.height + headerHeight;
				height = m_oMenuHeight>tileHeight?m_oMenuHeight:tileHeight;
			}
			var dispatcherEvent:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
			dispatcherEvent.data = data;
			dispatchEvent(dispatcherEvent);
		}
		
		protected function onHeaderMenuChange(event:MenuEvt):void
		{
			var data:Object = event.data;
			m_oTileText.data = data.children;
			var tileHeight:Number = m_oTileText.height + headerHeight;
			height = m_oMenuHeight>tileHeight?m_oMenuHeight:tileHeight;
			var dispatcherEvent:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
			dispatcherEvent.data = data;
			dispatchEvent(dispatcherEvent);
		}
		
		/**
		 * 
		 */
		public function updateGrphics():void
		{
			graphics.clear();
			graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
			graphics.beginFill(0xECF4FF,1);
			graphics.drawRoundRectComplex(0,0,width,height,cornorRadius,cornorRadius,cornorRadius,cornorRadius);
			graphics.endFill();
		}
	}
	
}


import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Rectangle;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import as3ui.evt.MenuEvt;

internal class HeaderText extends TextField
{
	protected var m_oDataProvider:Array=[];
	protected var m_oStyle:StyleSheet;
	protected var oriCursor:String;
	public function HeaderText()
	{
		super();
		m_oStyle = new StyleSheet();
		m_oStyle.setStyle(".content", {fontWeight:"bold",color:"#25381",fontSize:13,marginLeft:0,marginRight:0});
		m_oStyle.setStyle(".marker", {fontWeight:"bold",color:"#000000",fontSize:12});
		styleSheet = m_oStyle;
		addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		addEventListener(TextEvent.LINK,onTextLink);
	}
	
	protected function onMouseOver(event:Event):void
	{
		if(Mouse.cursor!= MouseCursor.ARROW)
		{
			oriCursor = Mouse.cursor;
			Mouse.cursor = MouseCursor.ARROW;
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
	}
	
	protected function onMouseOut(event:Event):void
	{
		if(Mouse.cursor!=oriCursor)
		{
			Mouse.cursor=oriCursor;
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
	}
	
	public function addText(data:Object):void
	{
		m_oDataProvider.push(data);
		htmlText += "<a href='event:"+m_oDataProvider.length+"'><span class='content'>"+data.label+"</span><span class='marker'>></span></a>"
		
	}
	
	protected function onTextLink(event:TextEvent):void
	{
	 	var index:int = int(event.text);
		htmlText = "";
		var i:int=0;
		while(i<index)
		{
			var data:Object = m_oDataProvider[i];
			htmlText += "<a href='event:"+(++i)+"'><span class='content'>"+data.label+"</span>></a>"
		}
		m_oDataProvider = m_oDataProvider.slice(0,index);
		var dispatcherEvent:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
		dispatcherEvent.data = m_oDataProvider[index-1];
		dispatchEvent(dispatcherEvent);
	}
}