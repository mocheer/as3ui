/*
* 创建：trg
* 时间：20110218
* 功能：微件容器，提供微件展开、收起状态及功能。
*/
package as3ui.dn.component.legend
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import as3ui.dn.component.button.ImageButton;
	
	
	public class LegendContainer extends Sprite
	{
		private var m_iState:int = 1;	//展开、收起状态。0：收起，1：展开
		private var m_iCaptionHeight:Number = 24;
		private var m_iContentWidth:Number;
		private var m_iContentHeight:Number;
		
		private var m_oWidget:DisplayObject;
		
		private var m_sCaption:String;
		private var titleTextField:TextField;
		
		private var m_oShadowCanvas:Sprite;
		private var m_oControlButton:ImageButton;
		
		public var borderAlpha:Number = 1;
		public var borderThickness:Number = 1;
		public var borderColor:uint = 0x6293D6;
		public var cornorRadius:Number = 4;
		public var backgroundAlpha:Number = 0.8;
		public var backgroudColor:uint = 0xC8DBF0;
		
		public var leftMargin:Number = 0;
		public var rightMargin:Number = 6;
		public var topMargin:Number = 0;
		public var bottomMargin:Number = 6;
		public var horizonPadding:Number = 3;
		public var verticalPadding:Number = 3;
		
		public function LegendContainer(widget:DisplayObject, widgetCaption:String, widgetWidth:Number = 0, widgetHeight:Number = 0, widgetState:int = 1)
		{
			super();
			m_oWidget = widget;
			m_sCaption = widgetCaption;
			m_iContentWidth = widgetWidth;
			m_iContentHeight = widgetHeight;
			m_iState = widgetState;
			
			//阴影效果
			m_oShadowCanvas = new Sprite();
			m_oShadowCanvas.filters = [
				new DropShadowFilter(2, 45, 0, 0.43, 3, 3, 2, 2)
			];
			addChild(m_oShadowCanvas);
			
			m_oWidget.x = leftMargin + horizonPadding;
			m_oWidget.y = topMargin + verticalPadding + m_iCaptionHeight;
			addChild(m_oWidget);
			
			m_oControlButton = new ImageButton("../Map/Images/ImageButtonState0.gif", "../Map/Images/ImageButtonState1.gif", widgetState);
			m_oControlButton.x = this.fullWidth - rightMargin - 19;
			m_oControlButton.y = topMargin + verticalPadding;
			addChild(m_oControlButton);
			m_oControlButton.addEventListener(MouseEvent.CLICK, onControlButtonClick);
			
			updateGraphics();
		}
		
		//=========================================== 事件部分 ============================================
		private function onControlButtonClick(e:MouseEvent):void
		{
			m_oControlButton.state = (m_oControlButton.state == ImageButton.NORMAL ? ImageButton.PRESSED : ImageButton.NORMAL);
			this.state = m_oControlButton.state;
			this.dispatchEvent(new Event(Event.RESIZE, false, false));
		}
		
		//=========================================== 属性部分 ============================================
		public function get contentHeight():Number {
			return m_iContentHeight;
		}
		
		public function set contentHeight(height:Number):void {
			m_iContentHeight = height;
			updateGraphics();
		}
		
		public function get contentWidth():Number {
			return m_iContentWidth;
		}
		
		public function set contentWidth(width:Number):void {
			m_iContentWidth = width;
			updateGraphics();
		}
		
		public function get currentHeight():Number {
			return (m_iState == 1 ? this.fullHeight : this.minHeight);
		}
		
		public function get currentWidth():Number {
			return this.fullWidth;
		}
		
		public function get fullHeight():Number {
			return topMargin + m_iCaptionHeight + verticalPadding + m_iContentHeight + verticalPadding + bottomMargin;
		}
		
		public function get fullWidth():Number{
			return leftMargin + horizonPadding + m_iContentWidth + horizonPadding + rightMargin;
		}
		
		public function get minHeight():Number {
			return topMargin + m_iCaptionHeight + bottomMargin;
		}
		
		public function get minWidth():Number {
			return leftMargin + horizonPadding + m_iContentWidth + horizonPadding + rightMargin;
		}
		
		public function get state():int {
			return m_iState;
		}
		
		public function set state(newState:int):void{
			if(m_iState != newState){
				m_iState = newState;
				updateGraphics();
			}
		}
		
		public function get widget():DisplayObject {
			return m_oWidget;
		}
		//=========================================== 方法部分 ============================================
		private function buildTitleText():void
		{
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.align = TextFormatAlign.LEFT;
			titleFormat.leftMargin = 0;
			titleFormat.size = 12;
			titleFormat.bold = true;
			
			titleTextField = new TextField();
			titleTextField.autoSize = TextFieldAutoSize.LEFT;
			titleTextField.defaultTextFormat = titleFormat;
			titleTextField.selectable = false;
			titleTextField.x = leftMargin + 4;
			titleTextField.y = topMargin + 3;
			titleTextField.text = m_sCaption;
			this.addChild(titleTextField);
		}
		
		public function updateGraphics():void {
			m_oWidget.visible = (m_iState == 1);
			
			if(titleTextField == null){
				buildTitleText();
			}
			
			var _width:Number = this.currentWidth - leftMargin - rightMargin;
			var _height:Number = this.currentHeight - topMargin - bottomMargin;
			
			this.graphics.clear();
			//绘制左上边线条
			this.graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
			this.graphics.moveTo(leftMargin + cornorRadius, topMargin + _height); //移动到左下角
			this.graphics.curveTo(leftMargin, topMargin + _height, leftMargin, topMargin + _height - cornorRadius); //左下角圆角
			this.graphics.lineTo(leftMargin, topMargin + cornorRadius);
			this.graphics.curveTo(leftMargin, topMargin, leftMargin + cornorRadius, topMargin); //左上角圆角
			this.graphics.lineTo(leftMargin + _width - cornorRadius, topMargin);
			this.graphics.curveTo(leftMargin + _width, topMargin, leftMargin + _width, topMargin + cornorRadius);
			
			//绘制内部白色边框及背景
			this.graphics.lineStyle();
			this.graphics.beginFill(backgroudColor, backgroundAlpha);
			this.graphics.drawRoundRect(leftMargin + 1, topMargin + 1, _width - 2, _height - 2, 2 * cornorRadius, 2 * cornorRadius);
			this.graphics.endFill();
			
			//右下两边线条及阴影
			m_oShadowCanvas.graphics.clear();
			m_oShadowCanvas.graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
			m_oShadowCanvas.graphics.moveTo(leftMargin + _width, topMargin + cornorRadius);
			m_oShadowCanvas.graphics.lineTo(leftMargin + _width, topMargin + _height - cornorRadius);
			m_oShadowCanvas.graphics.curveTo(leftMargin + _width, topMargin + _height, leftMargin + _width - cornorRadius, topMargin + _height); //右下角圆角
			m_oShadowCanvas.graphics.lineTo(leftMargin + cornorRadius, topMargin + _height);
		}
	}
}