package as3ui.core
{
	import as3ui.evt.MenuEvt;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	

	public class TileText extends Sprite
	{
		//
		public var itemGap:Number = 11;
		public var lineHeight:Number = 22;
		//
		protected var measuredWidth:Number = 0;
		protected var measureHeight:Number = 0;
		//
		protected var m_oDataProvider:Object;
		protected var m_oOverTarget:TextField;
		
		public function TileText()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		public function set data(value:Object):void
		{
			m_oDataProvider = value;
			createText();
			updateTextList();
		}
		
		override public function set width(value:Number):void
		{
			if(measuredWidth!=value)
			{
				measuredWidth = value;
				updateTextList();
			}
		}
		
		override public function set height(value:Number):void
		{
			if(measureHeight!=value)
			{
				measureHeight = value;
			}
		}
		
		override public function get height():Number
		{
			return measureHeight;
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var target:TextField = event.target as TextField;
			if(target && m_oOverTarget!=target)
			{
				m_oOverTarget = target;
				addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				var textFormat:TextFormat = target.getTextFormat();
				textFormat.underline = true;
				target.setTextFormat(textFormat);
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if(m_oOverTarget)
			{
				var textFormat:TextFormat = m_oOverTarget.getTextFormat();
				textFormat.underline = false;
				m_oOverTarget.setTextFormat(textFormat);
				m_oOverTarget = null;
				removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			}
		}
		
		public function createText():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
			var l:int = m_oDataProvider?m_oDataProvider.length:0;
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 12;
			for (var i:int=0;i<l;i++)
			{
				var item:Object = m_oDataProvider[i];
				var textItem:TextField = new TextField();
				textItem.autoSize = TextFieldAutoSize.LEFT;
				textItem.selectable = false;
				textItem.defaultTextFormat = textFormat;
				textItem.text = item.label;
				addChild(textItem);
				
			}
		}
		
		protected function onMouseClick(event:Event):void
		{
			var textFideld:TextField = event.target as TextField;
			if(textFideld)
			{
				var index:int = getChildIndex(textFideld);
				var data:Object = m_oDataProvider[index];
				var dispatcherEvent:MenuEvt = new MenuEvt(MenuEvt.CHANGE);
				dispatcherEvent.data = data;
				dispatcherEvent.oriEvent = event;
				dispatchEvent(dispatcherEvent);
			}
			
		}
		/**
		 * 
		 */
		protected function updateTextList():void
		{
			var l:int = numChildren;
			var mx:Number = 0;
			var my:Number = 0;
			for (var i:int=0;i<l;i++)
			{
				var textItem:TextField = getChildAt(i) as TextField;
				textItem.x = mx;
				textItem.y = my;
				mx += textItem.width;
				if(mx>measuredWidth)
				{
					my += lineHeight;
					textItem.x = 0;
					textItem.y = my;
					mx = textItem.width;
				}
				mx += itemGap;
			}
			measureHeight = my+lineHeight;
		}
	}
	
}