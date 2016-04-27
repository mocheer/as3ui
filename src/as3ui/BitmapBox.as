package as3ui
{
	import as3ui.evt.MenuEvt;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	

	public class BitmapBox extends UIComponent
	{
		public var backgroundAlpha:Number = .9;
		public var backgroundColor:uint = 0xECF4FF;//0xC8DBF0;
		public var borderThickness:Number = 1;
		public var borderColor:uint = 0x6293D6;
		public var state:int = 0;//0:收缩，1:展开
		public var tweenShowVars:Object ;
		public var tweenHideVars:Object ;
		public var itemWidth:Number = 65;
		public var itemHeight:Number = 45;
		public var itemGap:Number = 10;
		public var paddingLeft:Number = 5;
		public var paddingTop:Number = 5;
		public var type:int = 0; //0向右1向下
		//
		public var selectedItem:BitmapSprite;
		
		//
		protected var m_oDataProvider:Object;
//		protected var m_oIndex:int =0;//默认显示下标
		
		public function BitmapBox()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		/**
		 * 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			updateGraphics();
		}
		
		/**
		 * 设置数据源
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
			switch(type)
			{
				case 0: //向右
				case 2: //向左
					tweenHideVars = {width:itemWidth+paddingLeft*2,onStart:onHideStart};
					tweenShowVars = {width:(itemWidth+itemGap)*(value.length-1)+tweenHideVars.width,onComplete:onShowEnd};
					width =  tweenHideVars.width;
					height = itemHeight+paddingTop*2;
					break;
				case 1://向下
				case 3://向上
					tweenHideVars = {height:itemHeight+paddingTop*2,onStart:onHideStart};
					tweenShowVars = {height:(itemHeight+itemGap)*(value.length-1)+tweenHideVars.height,onComplete:onShowEnd};
					width = itemWidth+paddingLeft*2;
					height = tweenHideVars.height;
					break;
			}
			m_oDataProvider = value;
			updateBox();
		}
		
		//=================================================
		/**
		 * 菜单事件触发：添加弹出菜单
		 */
		protected function onMouseOver(event:Event):void
		{
			if(state!=1)
			{
				addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				state = 1;
				TweenLite.to(this,0.05,tweenShowVars);
			}
		}
		
		protected function onHideStart():void
		{
			var i:int;
			selectedItem.x = paddingLeft;
			selectedItem.y = paddingTop;
			var displayObjcet:DisplayObject;
			for (i=0;i<numChildren;i++)
			{
				displayObjcet = getChildAt(i);
				displayObjcet.visible = displayObjcet==selectedItem;
			}
			
		}
		
		protected function onShowEnd():void
		{
			var i:int;
			var displayObjcet:DisplayObject;
			var mx:Number = paddingLeft;
			var my:Number = paddingTop;
			for (i=0;i<numChildren;i++)
			{
				displayObjcet = getChildAt(i);
				displayObjcet.x = mx;
				displayObjcet.y = my;
				displayObjcet.visible = true; 
				switch(type)
				{
					case 0:
					case 2:
						mx += itemWidth+itemGap;
						break;
					case 1:
					case 3:
						my += itemHeight+itemGap;
						break;
				}
			}
		}
		
		/**
		 * 
		 */
		protected function onMouseOut(event:Event):void
		{
			if(state!=0)
			{
				state = 0;
				TweenLite.to(this,0.05,tweenHideVars);
				removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			}
		}
		
		/**
		 * 
		 */
		protected function onMouseClick(event:Event):void
		{
			var target:BitmapSprite = event.target as BitmapSprite;
			if(target && selectedItem!=target)
			{ 
				selectedItem.selected = false;
				selectedItem = target;
				selectedItem.selected = true;
				var dispatcherEvent:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
				dispatcherEvent.data = target.data;
				dispatchEvent(dispatcherEvent);
			}
		}
		/**
		 * 
		 */
		protected function updateBox():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
			var num:int = m_oDataProvider.length;
			for (var i:int = 0;i<num;i++)
			{
				var data:Object =  m_oDataProvider[i];
				var bitmapSprite:BitmapSprite = new BitmapSprite();
				bitmapSprite.buttonMode = true;
				bitmapSprite.mouseChildren = false;
				
				addChild(bitmapSprite);
				if(i==0)
				{
					selectedItem = bitmapSprite;
					data.selected = true;
					bitmapSprite.visible = true;
					bitmapSprite.x = paddingLeft;
					bitmapSprite.y = paddingTop;
				}else
				{
					bitmapSprite.visible = false;
				}
				bitmapSprite.data =data;
			}
		}
		
		/**
		 * 刷新背景
		 */
		public function updateGraphics():void
		{
			graphics.clear();
			graphics.lineStyle(borderThickness,borderColor,1);
			graphics.beginFill(backgroundColor,backgroundAlpha);
			graphics.drawRoundRectComplex(0,0,width,height,2,2,2,2);
			graphics.endFill();
		}
	}
}


import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;

internal class BitmapSprite extends Sprite
{
	protected var m_oData:Object;
	protected var m_oLoader:Loader;
	protected var m_oIsOver:Boolean = false;
	protected var m_oTextField:TextField;
	protected var m_oOverColor:uint = 0xFFFFFF;//0xFFFFFF;
	protected var m_oColor:uint = 0x000000;
	protected var m_oOverBackgroundColor:uint = 0x0033FF;//0xFFFFFF;
	protected var m_oBackgorundColor:uint = 0xFFFFFF;
	//
	public function BitmapSprite()
	{
		super();

		addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
	}
	
	public function set data(value:Object):void
	{
		if(m_oData!=value)
		{
			m_oData = value;
			if(!m_oTextField)
			{
				m_oTextField = new TextField();
				m_oTextField.background = true;
				m_oTextField.alpha = 0.70;
				
				m_oTextField.backgroundColor = value.selected?m_oOverBackgroundColor:m_oBackgorundColor;
				var  defaultTextFormat:TextFormat = m_oTextField.defaultTextFormat;
				defaultTextFormat.align = "right";
				defaultTextFormat.color = value.selected?m_oOverColor:m_oColor;
				m_oTextField.defaultTextFormat = defaultTextFormat;
				addChild(m_oTextField);
			}
			m_oTextField.text = value.label;
			if(!m_oLoader)
			{
				m_oLoader = new Loader();
			}
			m_oLoader.load(new URLRequest(value.icon));
			m_oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadedComplete);

		}
	}
	
	public function get data():Object
	{
		return m_oData;
	}
	
	private function onMouseOver(event:Event):void
	{
		if(!m_oIsOver)
		{
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			graphics.clear();
			var rect:Rectangle = this.getRect(this);
			graphics.lineStyle(1,0x0033FF);
			graphics.drawRect(-1,-1,rect.width+2,rect.height+2);
			if(m_oTextField)
			{
				var  defaultTextFormat:TextFormat = m_oTextField.defaultTextFormat;
				m_oTextField.backgroundColor = m_oOverBackgroundColor;
				defaultTextFormat.color = m_oOverColor;
				m_oTextField.setTextFormat(defaultTextFormat);
			}
			m_oIsOver = true;
		}
	}
	
	public function set selected(value:Boolean):void
	{
		if(m_oTextField && m_oData.selected!=value )
		{
			m_oData.selected = value;
			var  defaultTextFormat:TextFormat = m_oTextField.defaultTextFormat;
			defaultTextFormat.color = value?m_oOverColor:m_oColor;
			m_oTextField.backgroundColor = value?m_oOverBackgroundColor:m_oBackgorundColor;
			m_oTextField.setTextFormat(defaultTextFormat);
		}
	}
	
	private function onMouseOut(event:Event):void
	{
		if(m_oIsOver)
		{
			m_oIsOver = false;
			graphics.clear();
			if(!m_oData.selected && m_oTextField)
			{
				var  defaultTextFormat:TextFormat = m_oTextField.defaultTextFormat;
				defaultTextFormat.color = m_oColor;
				m_oTextField.setTextFormat(defaultTextFormat);
				m_oTextField.backgroundColor = 0xFFFFFF;
			}
		}
	}
	
	private function onLoadedComplete(event:Event):void
	{
		var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
		var content:DisplayObject = loaderInfo.content;
		addChildAt(content,0);
		m_oLoader = null;
		if(m_oTextField)
		{
			m_oTextField.width = content.width;
			m_oTextField.y = content.height - 18;
			m_oTextField.height = 18;
		}
		
	}
}