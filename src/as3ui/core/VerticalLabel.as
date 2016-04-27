package as3ui.core
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class VerticalLabel extends TextLabel
	{
		protected var m_oIsOver:Boolean = false;
		public var selected:Boolean = false;
		
		public function VerticalLabel()
		{
			super();
			measuredWidth = 22;
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			if(!initFlag)
			{
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = color;
				m_oTextField.x = paddingLeft;
				m_oTextField.y = paddingTop;
				m_oTextField.defaultTextFormat = textFormat;
				m_oTextField.multiline = true;
				m_oTextField.wordWrap = true;
				m_oTextField.autoSize = TextFieldAutoSize.CENTER;
				m_oTextField.width = 18;
				addChild(m_oTextField);
				initFlag = true;
			}
		}
		
		/**
		 *
		 */
		override public function set text(value:String):void
		{
			m_oTextField.text = value;
			m_oTextField.height = value.length * 20;
			height = m_oTextField.height + paddingTop *2;
		}
		
		/**
		 * 
		 */
		protected function onRollOver(event:Event):void
		{    
			if(m_oIsOver!=true)
			{
				stage.addEventListener(MouseEvent.MOUSE_OVER,onStageOver);
				m_oIsOver = true;
				updateGraphics();
			}
		}
		/**
		 * 
		 */
		protected function onStageOver(event:MouseEvent):void
		{    
			if(!m_oTextField.hitTestPoint(event.stageX,event.stageY))
			{
				if(m_oIsOver)
				{
					m_oIsOver = false;
					updateGraphics();
				}
			}
		}
		
		/**
		 * 刷新背景
		 */
		override public function updateGraphics():void
		{
			if(m_oIsOver || selected)
			{
				super.updateGraphics();
			}else
			{
				graphics.clear();
				graphics.lineStyle(1,0xB9CDE9,1);
				this.graphics.drawRect(0,0,measuredWidth,measuredHeight);
			}
		}
		
	}
}