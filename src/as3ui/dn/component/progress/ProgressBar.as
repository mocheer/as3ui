/**
 * 整合：gyb
 * 功能：轻量级的进度显示组件，只含进度显示，不含任何文本
 */
package as3ui.dn.component.progress
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * 轻量级的进度显示组件，只含进度显示，不含任何文本
	 */
	public class ProgressBar extends Sprite 
	{
		private var m_oSize:Point;
		
		private var m_nMaximum:Number = 100;
		private var m_nMinimum:Number = 0;
		private var m_nValue:Number = 0;
		/**
		 * 背景色
		 */
		public var backgroundColor:Number = 0xFFFFFF;
		/**
		 * 背景色不透明度
		 */
		public var backgroundAlpha:Number = 1;
		/**
		 * 边框颜色
		 */
		public var borderColor:uint = 0x0;
		/**
		 * 边框宽度
		 */
		public var borderThickness:Number = 1;
		/**
		 * 进度条颜色数组，合成进度条渐变效果
		 */
		public var barColors:Array = [0x10cb22, 0x09a118];
		/**
		 * 进度条不透明度数组
		 */
		public var barAlphas:Array = [1, 1];
		/**
		 * 进度条颜色分布比率的数组
		 */
		public var barRatios:Array = [0, 255];
		/**
		 * 进度条边线和内部进度条的间隙
		 */
		public var padding:Number = 1;
		
		//================================================ 构造函数 ===================================================
		/**
		 * 构造函数
		 * @param	width	进度条组件宽度
		 * @param	height	进度条组件高度
		 */
		public function ProgressBar(width:Number = 200, height:Number = 10) {
			m_oSize = new Point(width, height);
		}
		
		//================================================ 属性部分 ===================================================
		/**
		 * 进度条组件大小
		 */
		public function get size():Point {
			return m_oSize;
		}
		/**
		 * 进度条组件大小
		 */
		public function set size(val:Point):void {
			if (val == null) {
				throw new Error("属性值不能为空！");
			}
			m_oSize = val;
		}
		/**
		 * 进度条最大值
		 */
		public function get maxinum():Number {
			return m_nMaximum;
		}
		
		/**
		 * 进度条最大值
		 */
		public function set maxinum(val:Number):void {
			if (val < m_nMinimum) {
				throw new Error("属性值 " + val.toString() + " 不正确");
			}
			m_nMaximum = val;
			m_nValue = Math.min(m_nValue, m_nMaximum);
		}
		/**
		 * 进度条最小值
		 */
		public function get minimun():Number {
			return m_nMinimum;
		}
		/**
		 * 进度条最小值
		 */
		public function set minimun(val:Number):void {
			if (val > m_nMaximum) {
				throw new Error("属性值 " + val.toString() + " 不正确");
			}
			m_nMinimum = val;
			m_nValue = Math.max(m_nValue, m_nMinimum);
		}
		/**
		 * 进度条当前进度值
		 */
		public function get value():Number {
			return m_nValue;
		}
		/**
		 * 进度条当前进度值
		 */
		public function set value(val:Number):void {
			if (val < m_nMinimum || val > m_nMaximum) {
				throw new Error("属性值 " + val.toString() + " 超出范围{" + m_nMinimum.toString() + "," + m_nMaximum.toString() + "}");
			}
			m_nValue = val;
		}
		
		//================================================ 方法部分 ===================================================
		private function drawBackground():void {
			this.graphics.clear();
			var _n:Number = Math.floor(borderThickness / 2); //二分之一边框宽度舍去小数取整
			this.graphics.lineStyle(this.borderThickness, this.borderColor, 1);
			this.graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
			this.graphics.drawRect(_n, _n, m_oSize.x - borderThickness, m_oSize.y - borderThickness);
			this.graphics.endFill();
		}
		private function drawBar():void {
			var _nGraphicWidth:Number = (m_oSize.x - 2 * (borderThickness + padding)) * m_nValue / (m_nMaximum - m_nMinimum);
			var _nGraphicHeight:Number = m_oSize.y - 2 * (borderThickness + padding);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_nGraphicWidth, _nGraphicHeight, Math.PI / 2, padding + borderThickness, padding + borderThickness);
			
			this.graphics.lineStyle();
			this.graphics.beginGradientFill(GradientType.LINEAR, barColors, barAlphas, barRatios, matrix);
			this.graphics.drawRect(borderThickness + padding, borderThickness + padding, _nGraphicWidth, _nGraphicHeight);
			this.graphics.endFill();
		}
		/**
		 * 更新进度条界面图形
		 */
		public function updateGraphic():void {
			drawBackground();
			drawBar();
		}
	}

}