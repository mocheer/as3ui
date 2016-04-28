/**
 *
 */
package as3ui.map
{
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	/**
	 * 地图点图元标注组件 
	 */	
	public class TextLabel extends Sprite
	{
		/**
		 * 最小显示级别
		 */
		public var minVisibleZoom:int = 0;
		
		/**
		 * 最大显示级别
		 */
		public var maxVisibleZoom:int = int.MAX_VALUE;		

		/**
		 * 是否以颜色填充作为背景
		 */
		public var background:Boolean = false;
		/**
		 * 背景色不透明度
		 */
		public var backgroundAlpha:Number = 1; //背景透明度
		/**
		 * 背景色
		 */
		public var backgroundColor:uint = 0xFFFFFF; //背景色
		/**
		 * 边框不透明度
		 */
		public var borderAlpha:Number = 1; //边框透明度
		/**
		 * 是否需要绘制文本圆角矩形边框
		 */
		public var border:Boolean = false;
		/**
		 * 边框颜色
		 */
		public var borderColor:uint = 0x0; //边框颜色
		/**
		 * 边框线条宽度
		 */
		public var borderThickness:Number = 1; //边框粗细
		/**
		 * 文本左侧补白
		 */
		public var paddingLeft:int = 1;
		/**
		 * 文本右侧补白
		 */
		public var paddingTop:int = 0;
		
		/**
		 * 文本水平偏移量
		 */
		public var pixelOffsetX:int=0;
		
		/**
		 * 文本垂直偏移量
		 */
		public var pixelOffsetY:int=0;		
		
		private var m_nCornorRadius:Number = 0;
		private var m_bTextCenter:Boolean = false;
		private var textFormatDirty:Boolean = false;
		private var textFormat:TextFormat;
		private var textField:TextField;
		
		private var additionalWidth:Number = 3;
		private var additionalHeight:Number = 4;
		private var _originOfDistance:Number=3;
		private var _alignPosition:int=2;
		private var _triangleWidth:Number=8;  //三角形宽度
		private var _triangleHeight:Number=15; //三角形高度
		private var _data:Object;
		/**
		 * 构造函数
		 * @param	text	要显示的文本
		 * @param	font	文本字体
		 * @param	size	文字大小
		 * @param	color	文字颜色
		 */
		public function TextLabel(text:String ="", font:String = null, size:Number = 12, color:uint = 0x0) 
		{			
			textFormat = new TextFormat(font, size, color, false, false, false);
			textFormat.leading = 0;
			
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = textFormat;
			textField.selectable = false;
			this.text = text;
			addChild(textField);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}		
		
		//======================================== 事件处理 ========================================
		public function set data(value:Object):void
		{
			_data = value;
		}
		/**
		 * 用于数据绑定
		 */
		public function get data():Object
		{
			return _data;
		}
		/**
		 * 位置 
		 * @param value
		 * 
		 */		
		public function set alignPosition(value:int):void
		{
			_alignPosition = value;
		}

		/**
		 * 添加到画布事件处理
		 * @param	e	事件参数
		 */
		protected function onAddToStage(e:Event):void
		{
			updateGraphics();
		}
		
		//======================================== 属性部分 ========================================		
		
		public function set triangleWidth(value:Number):void
		{
			_triangleWidth = value;
		}
		/**
		 * 三角形宽度 
		 * @param value
		 */		
		public function get triangleWidth():Number
		{
			return _triangleWidth;
		}
		/**
		 * 三角形高度 
		 * @return 
		 * 
		 */		
		public function get triangleHeight():Number
		{
			return _triangleHeight;
		}
		
		/**
		 * 三角形高度 
		 * @param value
		 * 
		 */		
		public function set triangleHeight(value:Number):void
		{
			_triangleHeight = value;
		}
		
		/**
		 * 正方格位置 
		 * @return 
		 * 
		 */		
		public function get alignPosition():int
		{
			return _alignPosition;
		}
		
		/**
		 * 圆角边框半径
		 */
		public function get cornorRadius():Number
		{
			return m_nCornorRadius;
		}
		/**
		 * 
		 */
		public function set cornorRadius(val:Number):void
		{	
			var minLength:Number=Math.min(this.textField.width,this.textField.height)/2;
			val=val>minLength?minLength:val;
			m_nCornorRadius = Math.abs(val);
		}
		/**
		 * 是否使用嵌入字体
		 */
		public function get embedFonts():Boolean
		{
			return textField.embedFonts;
		}
		
		public function set embedFonts(val:Boolean):void
		{
			textField.embedFonts = val;
			textFormatDirty = true;
		}
		/**
		 * 字体名称
		 */
		public function get font():String
		{
			return textFormat.font;
		}
		/**
		 * 
		 */
		public function set font(val:String):void
		{
			textFormat.font = val;
			textFormatDirty = true;
		}
		/**
		 * 文字颜色
		 */
		public function get fontColor():uint
		{
			return uint(textFormat.color);
		}
		
		public function set fontColor(val:uint):void
		{
			textFormat.color = val;
			textFormatDirty = true;
		}
		/**
		 * 文字大小
		 */
		public function get fontSize():Number
		{
			return Number(textFormat.size);
		}
		/**
		 * 
		 */
		public function set fontSize(val:Number):void
		{
			textFormat.size = val;
			textFormatDirty = true;
		}
		/**
		 * 是否粗体
		 */
		public function get fontBold():Boolean
		{
			return textFormat.bold;
		}
		
		public function set fontBold(val:Boolean):void
		{
			textFormat.bold = val;
			textFormatDirty = true;
		}
		/**
		 * 是否斜体
		 */
		public function get fontItalic():Boolean
		{
			return textFormat.italic;
		}
		
		public function set fontItalic(val:Boolean):void
		{
			textFormat.italic = val;
			textFormatDirty = true;
		}
		/**
		 * 文字是否具有下划线效果
		 */
		public function get fontUnderline():Boolean
		{
			return textFormat.underline;
		}
		
		public function set fontUnderline(val:Boolean):void
		{
			textFormat.underline = val;
			textFormatDirty = true;
		}
		/**
		 * 文字内容
		 */
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(val:String):void
		{
			if (val == null)
			{
				val = "";
			}
			textField.htmlText = val;
			textField.visible = (val.length > 0);
			updateTextPosition();
		}
		/**
		 * 文字是否居中
		 */
		public function get textCenter():Boolean
		{
			return m_bTextCenter;
		}
		/**
		 * 
		 */
		public function set textCenter(val:Boolean):void
		{
			if (m_bTextCenter != val)
			{
				m_bTextCenter = val;
				updateTextPosition();
			}
		}
		/**
		 * 文本宽度
		 */
		public function get textWidth():Number
		{
			return textField.textWidth;
		}
		/**
		 * 文本高度
		 */
		public function get textHeight():Number
		{
			return textField.textHeight;
		}
		
		//======================================== 方法部分 ========================================
		private function updateTextPosition():void
		{
			textField.x = (m_bTextCenter ? -(paddingLeft + textField.textWidth / 2) : paddingLeft);
			textField.y = (m_bTextCenter ? -(paddingTop + Math.round(textField.textHeight / 2)) : paddingTop);
		}
		private function updateTextFormat():void
		{
			if (textFormatDirty)
			{
				textField.defaultTextFormat = textFormat;
				textField.setTextFormat(textFormat);
				updateTextPosition();
				textFormatDirty = false;
			}
		}
		
		/**
		 * 更新对象的图形
		 */
		public function updateGraphics():void
		{
			updateTextFormat();
			
			//绘制边框和背景
			this.graphics.clear();
			if (textField.text.length == 0)
			{
				return;
			}			
			if (border || background)
			{
				if (border)
				{
					this.graphics.lineStyle(borderThickness, borderColor, borderAlpha, true, LineScaleMode.NONE);
				}
				if (background)
				{
					this.graphics.beginFill(backgroundColor, backgroundAlpha);
				}
				
				var mBeginX:Number=textField.x-paddingLeft;
				var mBeginY:Number=textField.y-paddingTop;
				
				var mWidth:Number;
				var mHeight:Number;
			

				mWidth=textField.textWidth + 2 * paddingLeft + additionalWidth;
				mHeight=textField.textHeight + 2 * paddingTop + additionalHeight;
				
				
				var mCurveRadius:Number=cornorRadius;
				
				switch (_alignPosition) {
					case AlignPosition.TOP_LEFT:
						drawTextNoteTopLeft(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.TOP_CENTER:
						drawTextNoteTopCenter(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.TOP_RIGHT:
						drawTextNoteTopRight(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.MIDDLE_LEFT:
						drawTextNoteMiddleLeft(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.MIDDLE_CENTER:
						drawTextNoteMiddleCenter(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.MIDDLE_RIGHT:
						drawTextNoteMiddleRight(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.BOTTOM_LEFT:
						drawTextNoteBottomLeft(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.BOTTOM_CENTER:
						drawTextNoteBottomCenter(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					case AlignPosition.BOTTOM_RIGHT:
						drawTextNoteBottomRight(mBeginX,mBeginY,mWidth,mHeight,mCurveRadius);
						break;
					default:
						break;
				}
				
				if (background)
				{
					this.graphics.endFill();
				}
			}
		}
		
		//右下
		private function drawTextNoteBottomRight(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			
			this.graphics.lineTo(mX+(mWidth-_triangleWidth)/2,mY);  //左
			this.graphics.lineTo(mX-pixelOffsetX,mY-_triangleHeight-pixelOffsetY);   //中间点
			this.graphics.lineTo(mX+(mWidth+_triangleWidth)/2,mY); //右
			
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4				
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}
		
		//中下
		private function drawTextNoteBottomCenter(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			
			this.graphics.lineTo(mX+(mWidth-_triangleWidth)/2,mY);  //左
			this.graphics.lineTo(mX+mWidth/2-pixelOffsetX,mY-_triangleHeight-pixelOffsetY);   //中间点
			this.graphics.lineTo(mX+(mWidth+_triangleWidth)/2,mY); //右
			
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4				
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}
		
		//左下
		private function drawTextNoteBottomLeft(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			
			this.graphics.lineTo(mX+(mWidth-_triangleWidth)/2,mY);  //左
			this.graphics.lineTo(mX+mWidth-pixelOffsetX,mY-_triangleHeight-pixelOffsetY);   //中间点
			this.graphics.lineTo(mX+(mWidth+_triangleWidth)/2,mY); //右
			
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4				
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}		
		
		private function drawTextNoteMiddleRight(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4				
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8	
			
			this.graphics.lineTo(mX,mY+(mHeight+_triangleWidth)/2);  //左
			this.graphics.lineTo(mX-_triangleHeight-pixelOffsetX,mY+mHeight/2-pixelOffsetY);   //中间点
			this.graphics.lineTo(mX,mY+(mHeight-_triangleWidth)/2); //右
			
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}		
		
		private function drawTextNoteMiddleCenter(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4	
			
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}	
		
		private function drawTextNoteMiddleLeft(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4			
			
			this.graphics.lineTo(mX+mWidth,mY+(mHeight-_triangleWidth)/2);  //左
			this.graphics.lineTo(mX+mWidth+_triangleHeight-pixelOffsetX,mY+mHeight/2-pixelOffsetY);   //中间点
			this.graphics.lineTo(mX+mWidth,mY+(mHeight+_triangleWidth)/2); //右
			
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}		
		
		private function drawTextNoteTopLeft(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4				
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			
			this.graphics.lineTo(mX+(mWidth+_triangleWidth)/2,mY+mHeight);  //左
			this.graphics.lineTo(mX+mWidth-pixelOffsetX,mY+mHeight+_triangleHeight-pixelOffsetY);   //中间点
			this.graphics.lineTo(mX+(mWidth-_triangleWidth)/2,mY+mHeight); //右
			
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}
		
		private function drawTextNoteTopCenter(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4				
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			
			this.graphics.lineTo(mX+(mWidth+_triangleWidth)/2,mY+mHeight);  //左
			this.graphics.lineTo(mX+mWidth/2-pixelOffsetX,mY+mHeight+_triangleHeight-pixelOffsetY);   //中间点
			this.graphics.lineTo(mX+(mWidth-_triangleWidth)/2,mY+mHeight); //右
			
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}

		private function drawTextNoteTopRight(mX:Number,mY:Number,mWidth:Number,mHeight:Number,mCurveRadius:Number):void
		{	
			this.graphics.moveTo(mX,mY+mCurveRadius);   //1
			this.graphics.curveTo(mX,mY,mX+mCurveRadius,mY);  //2
			this.graphics.lineTo(mX+mWidth-mCurveRadius,mY);  //3
			this.graphics.curveTo(mX+mWidth,mY,mX+mWidth,mY+mCurveRadius);  //4				
			this.graphics.lineTo(mX+mWidth,mY+mHeight-mCurveRadius);  //5
			this.graphics.curveTo(mX+mWidth,mY+mHeight,mX+mWidth-mCurveRadius,mY+mHeight);  //6	
			
			this.graphics.lineTo(mX+(mWidth+_triangleWidth)/2,mY+mHeight);
			this.graphics.lineTo(mX-pixelOffsetX,mY+mHeight+_triangleHeight-pixelOffsetY);
			this.graphics.lineTo(mX+(mWidth-_triangleWidth)/2,mY+mHeight);
			
			this.graphics.lineTo(mX+mCurveRadius,mY+mHeight);  //7
			this.graphics.curveTo(mX,mY+mHeight,mX,mY+mHeight-mCurveRadius);  //8				
			this.graphics.lineTo(mX,mY+mCurveRadius);
		}
	}
}