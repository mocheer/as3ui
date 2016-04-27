package as3ui.core
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TextLabel extends Sprite
	{
		//
		public var backgroundColor:uint = 0xECF4FF;
		public var backgroundAlpha:Number = 1;
		public var color:uint = 0x25381;
		public var autoSize:Boolean = false;
		public var auto:String = TextFieldAutoSize.LEFT;
		public var paddingLeft:Number = 5;
		public var paddingTop:Number = 2;
		public var showCloseButton:Boolean = false;
		public var position:int = 0;//left,right,center
		public var leftMargin:Number = 0;
		//
		protected var measuredWidth:Number;
		protected var measuredHeight:Number;
		protected var initFlag:Boolean = false;
		//
		protected var m_oTextField:TextField;
		protected var m_oCloseButton:Sprite;
		//
		public static const CENTER:int = 0;
		public static const LEFT:int = 1;
		public static const RIGHT:int = 2;
		/**
		 * 文本控件，附带关闭按钮
		 */
		public function TextLabel()
		{
			super();
			m_oTextField = new TextField();
			m_oTextField.mouseEnabled = false;
			m_oTextField.selectable = false; //不可选
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		/**
		 * 初始化加载文本对象
		 */
		protected function onAddedToStage(event:Event):void
		{
			if(!initFlag)
			{
				m_oTextField.autoSize = auto;
				var textFormat:TextFormat = new TextFormat();
				textFormat.leftMargin = leftMargin;
				textFormat.color = color;
				m_oTextField.x = paddingLeft;
				m_oTextField.y = paddingTop;
				m_oTextField.defaultTextFormat = textFormat;
				addChild(m_oTextField);
				initFlag = true;
			}
		}
		/**
		 * 
		 */
		override public function get width():Number
		{
			return measuredWidth;
		}
		/**
		 * 
		 */
		override public function set width(value:Number):void
		{
			measuredWidth = value;
			if(position==CENTER)
			{
				m_oTextField.x = (value - m_oTextField.width)*0.5;//居中
			}
		}
		/**
		 * 
		 */
		override public function get height():Number
		{
			return measuredHeight;
		}
		/**
		 * 
		 */
		override public function set height(value:Number):void
		{
			measuredHeight = value;
		}
		/**
		 *
		 */
		public function set text(value:String):void
		{
			m_oTextField.text = value;
			if(autoSize)
			{
				width = m_oTextField.width+paddingLeft*2;
				height = m_oTextField.height + paddingTop *2;
			}
		}
		
		public function get content():TextField
		{
			return m_oTextField;
		}
		
		/**
		 *	刷新背景
		 */
		public function updateGraphics():void
		{
			graphics.clear();
			graphics.lineStyle(1,0xB9CDE9,1);
			graphics.beginFill(backgroundColor,backgroundAlpha);
			
			if(showCloseButton)
			{
				measuredWidth += 2;
				if(!m_oCloseButton)
				{
					m_oCloseButton = new Sprite();
					m_oCloseButton.addEventListener(MouseEvent.CLICK,onCloseClick);
					m_oCloseButton.buttonMode = true;
					var graphics:Graphics = m_oCloseButton.graphics;
					graphics.lineStyle();
					graphics.beginFill(0xFFFFFF,0);
					graphics.drawRect(0,0,8,8);
					graphics.endFill();
					
					graphics.lineStyle(1,0xFF0000,1);
					graphics.lineTo(6,6);
					graphics.moveTo(6,0);
					graphics.lineTo(0,6);
					
					addChild(m_oCloseButton);
				}
				m_oCloseButton.x = measuredWidth - 8;
				m_oCloseButton.y = 3;
			}else if(m_oCloseButton)
			{
				removeChild(m_oCloseButton);
				m_oCloseButton = null
			}
			this.graphics.drawRect(0,0,measuredWidth,measuredHeight);
			this.graphics.endFill();
		}
		
		/**
		 * 
		 */
		protected function onCloseClick(event:Event):void
		{
			var dispatcherEvent:Event = new Event("CloseClick");
			dispatchEvent(dispatcherEvent);
		}
	}
}