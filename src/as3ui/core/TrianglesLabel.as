package as3ui.core
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class TrianglesLabel extends TextLabel
	{
		public static const LEFT:Number = 0;
		public static const RIGHT:Number = 1;
		public static const TOP:Number = 0.5;
		public static const BOTTOM:Number= -0.5;
		//=============
		public var m_oState:Number = 5e-324;//Number.MIN_VALUE
		//=============
		protected var m_oButton:TrianglesSprite;
		/**
		 * 
		 */
		public function TrianglesLabel(angle:Number=5e-324)//Number.MIN_VALUE
		{
			super();
			if(angle != 5e-324)
			{
				m_oTextField.x  = 3;
				m_oButton = new TrianglesSprite();
				m_oButton.addEventListener(MouseEvent.CLICK,onMouseClick);
				m_oButton.y = (height-7)*0.5;
				addChild(m_oButton);
				this.state = angle;
			}
		}
		/**
		 * 
		 */
		override protected function onAddedToStage(event:Event):void
		{
			if(!initFlag)
			{
				m_oTextField.autoSize = auto;
				var textFormat:TextFormat = new TextFormat();
				textFormat.bold = true;
				textFormat.size = 14;
				textFormat.color = color;
				m_oTextField.x = paddingLeft;
				m_oTextField.y = paddingTop;
				m_oTextField.defaultTextFormat = textFormat;
				addChild(m_oTextField);
				initFlag = true;
			}
		}
		/**
		 * TODO
		 */
		public function addLoader(loader:Loader,clickListener:Function):void
		{
			if(m_oButton)
			{
				loader.x = m_oButton.x - 30;
				loader.y = 7;
			}
			loader.addEventListener(MouseEvent.CLICK,clickListener);
			addChild(loader);
		}
		/**
		 * 
		 */
		override public function set width(value:Number):void
		{
			if(!m_oButton)
			{
				super.width = value;
			}else
			{
				measuredWidth = value;
				m_oTextField.visible = m_oTextField.width<value;
				m_oButton.x = value - 15;
			}
		}
		/**
		 * 
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			if(m_oButton)
			{
				m_oButton.y = (value-7)*0.5;
			}
		}
		
		public function get state():Number
		{
			return m_oState;
		}
		
		/**
		 * 按钮点击事件派发
		 */
		private function onMouseClick(event:Event):void
		{
			changeState(m_oState);
		}
		/**
		 * 改变状态
		 */
		public function changeState(value:Number):void
		{
			switch(value)
			{
				case LEFT:
					state =  RIGHT;
					break;
				case RIGHT:
					state = LEFT;
					break;
				case TOP:
					state = BOTTOM;
					break;
				case BOTTOM:
					state = TOP;
					break;
			}
		}
		/**
		 * 
		 */
		public function set state(value:Number):void
		{
			if(m_oState!=value)
			{
				m_oState = value;
				if(m_oButton)
				{
					m_oButton.updateGraphics(m_oState*Math.PI);
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
	}
}