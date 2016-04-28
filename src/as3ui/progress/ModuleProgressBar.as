/**
 * 整合：gyb
 * 功能：加载进度组件
 */
package as3ui.progress
{
	import as3lib.evt.ModuleEventEx;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;
	import mx.events.ModuleEvent;
	

	/**
	 * 地图插件加载进度组件
	 */
	public class ModuleProgressBar extends Sprite 
	{
		private var m_oTimer:Timer;
		private var m_oShadowCanvas:Sprite;
		
		/**
		 * 自定义的轻量级的进度条组件
		 */
		protected var m_oProgressBar:ProgressBar;
		/**
		 * 文本显示组件，用于显示文本信息
		 */
		protected var m_oTopLabel:TextField;
		/**
		 * 文本显示组件，用于显示进度信息
		 */
		protected var m_oBottomLabel:TextField;
		/**
		 * 背景色
		 */
		public var backgroundColor:uint = 0xa3c6f5;
		/**
		 * 背景不透明度
		 */
		public var backgroundAlpha:Number = 0.6;
		/**
		 * 边框不透明度
		 */
		public var borderAlpha:Number = 0.91;
		/**
		 * 边框颜色
		 */
		public var borderColor:uint = 0x2166a5;
		/**
		 * 边框宽度
		 */
		public var borderThickness:Number = 1;
		/**
		 * 边框圆角半径
		 */
		public var cornorRadius:Number = 4;
		
		//---------------------------------------------------------------------------------------------------------------
		//    构造函数
		//---------------------------------------------------------------------------------------------------------------
		/**
		 * 构造函数
		 * @param	map	地图组件
		 */
		public function ModuleProgressBar() 
		{
			//阴影效果
			m_oShadowCanvas = new Sprite();
			m_oShadowCanvas.filters = [
				new DropShadowFilter(2, 45, 0, 0.43, 3, 3, 3, 2)
			];
			addChild(m_oShadowCanvas);
			
			m_oTimer = new Timer(500, 1);
			m_oTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				visible = false;
			});
			
			m_oProgressBar = new ProgressBar(240, 10);
			addChild(m_oProgressBar);
			
			var textFormat:TextFormat = new TextFormat(null, 12, 0x0);
			textFormat.align = TextFormatAlign.LEFT;
			
			m_oTopLabel = new TextField();
			m_oTopLabel.autoSize = TextFieldAutoSize.NONE;
			m_oTopLabel.defaultTextFormat = textFormat;
			m_oTopLabel.width = m_oProgressBar.size.x;
			m_oTopLabel.height = 20;
			addChild(m_oTopLabel);
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//    方法部分
		//---------------------------------------------------------------------------------------------------------------
		/**
		 * 绘制背景
		 */
		protected function drawBackground():void {
			var _x:Number = m_oProgressBar.x - 50;
			var _width:Number = m_oProgressBar.size.x + 100;
			var _y:Number = m_oProgressBar.y - 40;
			var _height:Number = 100;
			
			this.graphics.clear();
			
			//绘制左上边线条
			this.graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
			this.graphics.moveTo(_x + cornorRadius, _y + _height); //移动到左下角
			this.graphics.curveTo(_x, _y + _height, _x, _y + _height - cornorRadius); //左下角圆角
			this.graphics.lineTo(_x, _y + cornorRadius);
			this.graphics.curveTo(_x, _y, _x + cornorRadius, _y); //左上角圆角
			this.graphics.lineTo(_x + _width - cornorRadius, _y);
			this.graphics.curveTo(_x + _width, _y, _x + _width, _y + cornorRadius);
			
			//绘制内部白色边框及背景
			this.graphics.lineStyle(1, 0xffffff, 1, true);
			this.graphics.beginFill(backgroundColor, backgroundAlpha);
			this.graphics.drawRoundRect(_x + 1, _y + 1, _width - 2, _height - 2, 2 * cornorRadius, 2 * cornorRadius);
			this.graphics.endFill();
			
			//右下两边线条及阴影
			m_oShadowCanvas.graphics.clear();
			m_oShadowCanvas.graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
			m_oShadowCanvas.graphics.moveTo(_x + _width, _y + cornorRadius);
			m_oShadowCanvas.graphics.lineTo(_x + _width, _y + _height - cornorRadius);
			m_oShadowCanvas.graphics.curveTo(_x + _width, _y + _height, _x + _width - cornorRadius, _y + _height); //右下角圆角
			m_oShadowCanvas.graphics.lineTo(_x + cornorRadius, _y + _height);
		}
		/**
		 * 模块加载进度处理
		 * @param	moduleInfo	模块信息
		 * @param	e		事件参数
		 */
		public function onModuleLoadProgress(e:ModuleEventEx):void {
			switch(e.type) {
				case ModuleEvent.ERROR:
					m_oTopLabel.text = "加载组件 " + e.moduleInfo.key + " 失败！";
					if(!m_oTimer.running){
						m_oTimer.repeatCount = 1;
						m_oTimer.start();
					}
					break;
				case ModuleEvent.PROGRESS:
					if (e.bytesTotal >= e.bytesLoaded && e.bytesLoaded >= 0) {
						this.visible = true;
						if(m_oTimer.running){
							m_oTimer.stop();
						}
						m_oProgressBar.maxinum = e.bytesTotal;
						m_oProgressBar.value = e.bytesLoaded;
						m_oProgressBar.updateGraphic();
						
						m_oTopLabel.text = "加载组件 " + e.moduleInfo.key + "(" + Math.round(e.bytesLoaded / 1024).toString() + "/" + Math.round(e.bytesTotal / 1024).toString() + "KB)...";
						
						if (m_oProgressBar.value >= m_oProgressBar.maxinum) {
							m_oTimer.repeatCount = 1;
							m_oTimer.start();
						}
					}
					break;
			}
		}
	
	}

}