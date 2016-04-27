/**
 * 整合：gyb
 * 功能：自定义的flash加载进度条组件。
 */
package as3ui.dn.component.progress
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.Timer;
	import mx.events.FlexEvent;
	import mx.preloaders.IPreloaderDisplay;
	/**
	 * 自定义的flash加载进度条组件。
	 */
	public class StrongsoftPreloader extends Sprite implements IPreloaderDisplay
	{
		private var _barSprite:Sprite;
		private var progressText:TextField;
		private var ProgressBarSpritIsAdded:Boolean = false;
		
		private var borderThick:int = 1; //边框线宽度
		private var barPadding:int = 1; //边框线和进度条之间的留白
		private var barWidth:int = 302; //进度条宽度，含边框
		private var barHeight:int = 10; //进度条高度，含边框
		
		private var barBorderColor:uint = 0x0;
		private var barBackColor:uint = 0xFFFFFF;
		private var barColors:Array = [0x10cb22, 0x09a118];

		/**
		 * 构造函数
		 */
		public function StrongsoftPreloader(){
			super();
		}

		/**
		 * 设置加载对象，注册事件监听状态
		 */
		public function set preloader(preloader:Sprite):void {
			// 正在下载 
			preloader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			// 下载完成 
			preloader.addEventListener(Event.COMPLETE, handleComplete);
			// 正在初始化 
			preloader.addEventListener(FlexEvent.INIT_PROGRESS, handleInitProgress);
			// 初始化完成 
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, handleInitComplete);
		}

		/**
		 * 初始化
		 */
		public function initialize():void {
		}


		private function addProgressBarSprit():void {
			
			this.graphics.lineStyle();
			//绘制整个舞台渐变背景
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.stage.stageWidth, this.stage.stageHeight, 0, 0, 0);
			this.graphics.beginGradientFill(GradientType.RADIAL, [0xb0c2d0,0x92a8b3], [1, 1], [10, 255],matrix);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
			
			
			//绘制进度条背景 
			var _backSprite:Sprite = new Sprite();
			addChild(_backSprite);
			_backSprite.filters = [
				new GlowFilter(0x92a8b3, 1, 6, 6, 2)
			];
			_backSprite.graphics.lineStyle(borderThick, barBorderColor, 1, true, LineScaleMode.NONE);
			_backSprite.graphics.beginFill(barBackColor);
			_backSprite.graphics.drawRect((this.stage.stageWidth - barWidth) / 2, (this.stage.stageHeight - barHeight) / 2, barWidth, barHeight);
			_backSprite.graphics.endFill();

			//------------------------------------------------- 

			//加载进度条Sprite 
			_barSprite = new Sprite();
			addChild(_barSprite);
			_barSprite.x = (this.stage.stageWidth - barWidth) / 2 + borderThick + barPadding;
			_barSprite.y = (this.stage.stageHeight - barHeight) / 2 + borderThick + barPadding;

			//------------------------------------------------- 

			//加载进度条文字 
			progressText = new TextField();
			addChild(progressText);
			progressText.textColor = 0x0;
			progressText.width = barWidth;
			progressText.height = 18;
			progressText.x = (this.stage.stageWidth - barWidth) / 2;
			progressText.y = (this.stage.stageHeight) / 2 + barHeight / 2;
		}

		//刷新进度条 
		private function drawProgressBar(bytesLoaded:Number, bytesTotal:Number):void {
			if (_barSprite != null && progressText != null){
				var g:Graphics = _barSprite.graphics;
				g.clear();
				
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox((barWidth - borderThick - 2 * barPadding) * (bytesLoaded / bytesTotal), barHeight - borderThick - 2 * barPadding, Math.PI / 2);
				var alphas:Array = [1, 1];
				var ratios:Array = [0, 255];
				
				g.lineStyle();
				g.beginGradientFill(GradientType.LINEAR, barColors, alphas, ratios, matrix);
				//g.beginFill(barColors[1], 1);
				g.drawRect(0, 0, (barWidth - borderThick - 2 * barPadding) * (bytesLoaded / bytesTotal), (barHeight - borderThick - 2 * barPadding));
				g.endFill();


			}
		}

		//正在下载的进度 
		private function handleProgress(event:ProgressEvent):void {
			//第一次处理时绘制进度条Sprit 
			if (ProgressBarSpritIsAdded == false){
				ProgressBarSpritIsAdded = true;
				addProgressBarSprit();
			}

			if (progressText != null){
				progressText.text = "下载进度：已下载 " + (event.bytesLoaded / 1024.0).toFixed(0) + " KB，总大小 " + (event.bytesTotal / 1024.0).toFixed(0) + " KB.";
			}
			drawProgressBar(event.bytesLoaded, event.bytesTotal);
		}

		private function handleComplete(event:Event):void {
			if (progressText != null){
				progressText.text = "下载完成.";
			}
			drawProgressBar(1, 1);
		}

		private function handleInitProgress(event:Event):void {
			if (progressText != null){
				progressText.text = "正在初始化...";
			}
			drawProgressBar(1, 1);
		}

		private function handleInitComplete(event:Event):void {
			if (progressText != null){
				progressText.text = "初始化完成.";
			}
			drawProgressBar(1, 1);

			//0.1秒后抛出完成事件 
			var timer:Timer = new Timer(100, 1);
			timer.addEventListener(TimerEvent.TIMER, dispatchComplete);
			timer.start();
		}

		private function dispatchComplete(event:TimerEvent):void {
			dispatchEvent(new Event(Event.COMPLETE));
		}


		// 实现 IPreloaderDisplay 接口

		/**
		 * 背景色
		 */
		public function get backgroundColor():uint {
			return 0;
		}
		/**
		 * 
		 */
		public function set backgroundColor(value:uint):void {
		}
		/**
		 * 背景不透明度
		 */
		public function get backgroundAlpha():Number {
			return 0;
		}
		/**
		 * 
		 */
		public function set backgroundAlpha(value:Number):void {
		}
		/**
		 * 背景图像
		 */
		public function get backgroundImage():Object {
			return undefined;
		}
		/**
		 * 
		 */
		public function set backgroundImage(value:Object):void {
		}
		/**
		 * 背景尺寸
		 */
		public function get backgroundSize():String {
			return "";
		}
		/**
		 * 
		 */
		public function set backgroundSize(value:String):void {
		}
		/**
		 * 舞台宽度
		 */
		public function get stageWidth():Number {
			return 400;
		}
		/**
		 * 
		 */
		public function set stageWidth(value:Number):void {
		}
		/**
		 * 舞台高度
		 */
		public function get stageHeight():Number {
			return 300;
		}
		/**
		 * 
		 */
		public function set stageHeight(value:Number):void {
		}
	}

}