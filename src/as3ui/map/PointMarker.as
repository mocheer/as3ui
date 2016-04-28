/**
 *
 */
package as3ui.map
{
	import as3lib.helper.load.LoaderHelper;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	/**
	 * 功能：通用点图元（通常用来继承封装成地图的点图元）
	 */
	public class PointMarker extends Sprite
	{
		//=======================================================属性及构造函数===================================

		/**图例(图片/动画/字形)---类似指针的用法**/	
		private var m_oLegend:DisplayObject;
		/** 标注和图例的位置补白*/
		public static var labelPositionPadding:int = 6;
		/**文字左补白距离**/
		public static const TEXTFIELD_PADDING:int = 2;
		/**字形图例的字体种类是否要包括设备字体**/
		public var deviceFontFlag:Boolean = true;
		/**点对象最小可见视野，小于该视野，则组件不可见(自动隐藏) */
		public var minVisibleZoom:int = 0;
		/** 点对象最大可见视野，大于该视野，则组件不可见(自动隐藏)*/
		public var maxVisibleZoom:int = int.MAX_VALUE;
		/**点标记对象的标注最小可见视野。*/
		public var labelMinVisibleZoom:int = 0;
		/**点标记对象的标注最大可见视野。 */
		public var labelMaxVisibleZoom:int = int.MAX_VALUE;
		/**图例获得焦点时缩放的比例*/
		public var LegendScale:Number = 1.6;
		/**点对象的标注集合*/
		public var labels:Array;
	
		
		
		/**字形图例**/
		private var m_oLegendLabel:TextField;
		/**图片/动画图例的资源地址**/
		private var m_slegendImage:String;
		/**字形图例的format对象*/
		private var m_oLegendLabelTextFormat:TextFormat;
		/**偏移X*/
		private var m_iOffsetX:int = 0;
		/**偏移Y*/
		private var m_iOffsetY:int = 0;
		/**字形图例的透明度*/
		private var m_nLegendBorderAlpha:Number = 0;
		/**字形图例的颜色*/
		private var m_iLegendBorderColor:uint = 0xFFFFFF;
		/**得到焦点时是否显示标注（默认级别地图显示问题）*/
		private var m_bAutomaticDisplay:Boolean = true;
		/**存储自定义数据*/
		private var _tag:Object;
		/**
		 * 构造函数
		 */
		public function PointMarker()
		{
			super();
			labels = [];
			this.cacheAsBitmap = true;
		}
		//=========================================== Getter/Setter====================================
		/** 图例对象*/
		public function get legend():DisplayObject
		{
			return m_oLegend;
		}
		public function set legend(display:DisplayObject):void
		{
			if(m_oLegend != display)
			{
				if(m_oLegend && m_oLegend.parent == this)
				{
					this.removeChild(m_oLegend);
					m_oLegend.removeEventListener(MouseEvent.MOUSE_OVER, onLegendMouseOver);
					m_oLegend.removeEventListener(MouseEvent.MOUSE_OUT, onLegendMouseOut);
				}
				m_oLegend = display;
				m_oLegend.addEventListener(MouseEvent.MOUSE_OVER, onLegendMouseOver);
				m_oLegend.addEventListener(MouseEvent.MOUSE_OUT, onLegendMouseOut);
				this.addChildAt(m_oLegend,0);
			}
		}
		/** 字形图例描边线条不透明度*/
		public function get legendBorderAlpha():Number
		{
			return m_nLegendBorderAlpha;
		}
		public function set legendBorderAlpha(val:Number):void
		{
			if(m_nLegendBorderAlpha != val)
			{
				m_nLegendBorderAlpha = val;
				buildLegendFilter();
			}
		}
		/** 字形图例描边颜色*/
		public function get legendBorderColor():uint
		{
			return m_iLegendBorderColor;
		}
		public function set legendBorderColor(val:uint):void
		{
			if(m_iLegendBorderColor != val)
			{
				m_iLegendBorderColor = val;
				buildLegendFilter();
			}
		}
		/**字形图例颜色*/
		public function get legendColor():uint
		{
			return uint(legendLabelTextFormat.color);
		}
		public function set legendColor(value:uint):void
		{
			legendLabelTextFormat.color = value;
			legendLabel.setTextFormat(legendLabelTextFormat);
		}

		/**字形图例字体类型,当字体类型*/
		public function get legendFont():String
		{
			return legendLabelTextFormat.font;
		}
		public function set legendFont(value:String):void
		{
			if (value != null)
			{
				legendLabelTextFormat.font = value;				
				legendLabel.setTextFormat(legendLabelTextFormat);
				var embedFonts:Array = Font.enumerateFonts(deviceFontFlag);
				for each(var embedfont:Font in embedFonts)
				{
					if(embedfont.fontName == value)
					{
						legendLabel.embedFonts = true;
						break;
					}
				}
			}
		}
		/**
		 * 字形图例字体大小。
		 */
		public function get legendFontSize():Number
		{
			return Number(m_oLegendLabelTextFormat.size);
		}
		public function set legendFontSize(value:Number):void
		{
			m_oLegendLabelTextFormat.size = value;
			legendLabel.setTextFormat(m_oLegendLabelTextFormat);
			updateLegend();
		}
		
	    /**图片/动画图例的资源地址**/
		public function get legendImage():String
		{
			return m_slegendImage;
		}
		public function set legendImage(imageUrl:String):void
		{
			var loader:Loader = LoaderHelper.Instance.load(imageUrl);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			legend = loader;
		}
		public function set legendBytes(bytes:ByteArray):void
		{
			var loader:Loader;
			if(legend is Loader)
			{
				loader = legend as Loader;
			}else
			{
				loader = new Loader();
			}
			loader.loadBytes(bytes);
		}
		/**
		 * 点符号在水平方向上的像素偏移量
		 */
		public function get offsetX():int
		{
			return m_iOffsetX;
		}
		public function set offsetX(val:int):void
		{
			m_iOffsetX = val;
			updateMarker();
		}
		/**
		 * 点符号在垂直方向的像素偏移量
		 */
		public function get offsetY():int
		{
			return m_iOffsetY;
		}
		public function set offsetY(val:int):void
		{
			m_iOffsetY = val;
			updateMarker();
		}
		
		/**
		 * 字形图例的文本字符。例如以“◆”作为图例
		 */
		public function get legendText():String
		{
			return legendLabel.text;
		}
		public function set legendText(value:String):void
		{
			if (legendLabel.text != value){
				if (value == null){
					value = "";
				}
				legendLabel.visible = true;
				//m_oLegendLabel.text = value;
				legendLabel.htmlText = "<a href='event:#'>" + value.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;") + "</a>";
				legendLabel.setTextFormat(legendLabelTextFormat);
				updateLegend();
			}
		}
		/**
		 * 鼠标移过去,是否显示标注
		 */		
		public function set automaticDisplay(value:Boolean):void
		{
			m_bAutomaticDisplay=value;
		}
		private function get legendLabel():TextField
		{
			if(m_oLegendLabel == null)
			{
				m_oLegendLabel  = new TextField();
//				m_oLegendLabel.mouseEnabled = false;
				m_oLegendLabel.htmlText = "<a href='event:#'>●</a>";
				m_oLegendLabel.setTextFormat(legendLabelTextFormat);
				m_oLegendLabel.autoSize = TextFieldAutoSize.LEFT;
				m_oLegendLabel.selectable = false;
				m_oLegendLabel.x = -m_oLegendLabel.textWidth / 2 - TEXTFIELD_PADDING;
				m_oLegendLabel.y = -m_oLegendLabel.textHeight / 2 - TEXTFIELD_PADDING;
				legend = m_oLegendLabel;
			}
			return m_oLegendLabel;
		}
		private function get legendLabelTextFormat():TextFormat
		{
			if(m_oLegendLabelTextFormat == null)
			{
				m_oLegendLabelTextFormat = new TextFormat();
				m_oLegendLabelTextFormat.size = 12;
				m_oLegendLabelTextFormat.color = 0x000000;
			}
			return m_oLegendLabelTextFormat;
		}
		public function get tag():Object
		{
			if(_tag == null)
			{
				_tag = new Object()
			}
			return _tag;
		}
		
		//=======================================================事件===================================
		private function onLegendMouseOver(event:MouseEvent):void
		{
			var _oDispObj:DisplayObject = event.currentTarget as DisplayObject;
			var _oLayer:Sprite=this.parent as Sprite;
			if(_oLayer)
			{
				_oLayer.setChildIndex(this,_oLayer.numChildren-1);
			}
			_oDispObj.x -= _oDispObj.width * (LegendScale - 1) / 2;
			_oDispObj.y -= _oDispObj.height * (LegendScale - 1) / 2;
			_oDispObj.scaleX = LegendScale;
			_oDispObj.scaleY = LegendScale;
			if(m_bAutomaticDisplay)
			{
				setLabelsVisible(true);
			}
		}
		private function onLegendMouseOut(event:MouseEvent):void
		{
			var _oDispObj:DisplayObject = event.currentTarget as DisplayObject;
			_oDispObj.x += (_oDispObj.scaleX - 1) * _oDispObj.width / _oDispObj.scaleX / 2;
			_oDispObj.y += (_oDispObj.scaleY - 1) * _oDispObj.height / _oDispObj.scaleY / 2;
			_oDispObj.scaleX = 1;
			_oDispObj.scaleY = 1;
			updateLabelsVisible();			
		}
		private function onLoadComplete(event:Event):void
		{
			updateLegend();
		}
		//======================================== 方法部分 ========================================
		/**
		 * 向点对象添加一个文本标注，设定其相对于点的位置、偏移量等参数
		 * @param text              标注文本
		 * @param position          标注相对于点的位置，采用和DMAP一致的定义。0：居中，1：正上方，2：正下方，3：左侧，4：右侧，5：左上，6：右上，7：左下，8：右下
		 * @param pixelOffsetX      标注水平方向的像素偏移。用于解决标注重叠或遮挡住其它要素等问题
		 * @param pixelOffsetY      标注垂直方向的像素偏移。用于解决标注重叠或遮挡住其它要素等问题
		 * @param background        标注是否需要背景色填充
		 * @param backgroundColor   标注背景颜色
		 * @param backgroundAlpha   标注背景不透明度
		 * @param border            标注边框
		 * @param borderColor       标注边框色
		 * @param cornorRadius      标注边框圆角半径
		 * @param fontName          标注字体名
		 * @param fontColor         标注文字颜色
		 * @param fontSize          标注文字大小
		 * @param bold              标注是否加粗
		 * @param italic            标注是否斜体
		 * @return                  添加成功的标注对象(TextLabel)的引用
		 */		
		public function addLabel(text:String, position:int=1,pixelOffsetX:int = 0,pixelOffsetY:int = 0,
								 background:Boolean = true,backgroundColor:uint = 0xFFFFFF,backgroundAlpha:Number = 1,
								 border:Boolean = true,borderColor:uint = 0x000000,cornorRadius:int =3,
								 fontName:String=null,fontColor:uint = 0x000000,fontSize:Number = 12,bold:Boolean=false,italic:Boolean=false):TextLabel
		{
			var _oTextLabel:TextLabel = new TextLabel(text);
			
			_oTextLabel.fontSize = fontSize;
			_oTextLabel.fontColor = fontColor;
			_oTextLabel.fontBold = bold;
			_oTextLabel.fontItalic = italic;
			_oTextLabel.border = border;
			_oTextLabel.borderColor = borderColor;
			_oTextLabel.background = background;
			_oTextLabel.backgroundAlpha = backgroundAlpha;
			_oTextLabel.backgroundColor = backgroundColor;
			_oTextLabel.cornorRadius = cornorRadius;
			
			setTextLabelPosition(_oTextLabel,position,pixelOffsetX,pixelOffsetY);
		
			labels.push(_oTextLabel);
			return _oTextLabel;
		}	
		
		/**
		 * 移除指定的textLabel
		 * @param textLabel
		 */		
		public function removeTextLabel(textLabel:TextLabel):void
		{
			if(labels!=null&&labels.length>0)
			{
				for(var i:int=0;i<labels.length;i++)
				{
					if(labels[i]==textLabel)
					{
						labels.splice(i,1);
						removeChild(textLabel);
					}
				}				
			}
		}
		/** 	
		 * 设置TextLabel位置		 
		 * @param textLabel
		 * @param position
		 * @param pixelOffsetX
		 * @param pixelOffsetY
		 */		
		public function setTextLabelPosition(textLabel:TextLabel, position:int=1,pixelOffsetX:int = 0,pixelOffsetY:int = 0):void
		{			
			textLabel.alignPosition=position;
			textLabel.pixelOffsetX=pixelOffsetX;
			textLabel.pixelOffsetY=pixelOffsetY;
			
			var _nLabelWidth:Number = textLabel.textWidth + 4;
			var _nLabelHeight:Number = textLabel.textHeight + 4;
			//标注位置，同DMAP
			switch(position)
			{
				case AlignPosition.MIDDLE_CENTER :
					textLabel.x = -_nLabelWidth / 2 + pixelOffsetX;
					textLabel.y = -_nLabelHeight / 2 + pixelOffsetY;
					break;
				case AlignPosition.BOTTOM_CENTER:
					textLabel.x = -_nLabelWidth / 2 + pixelOffsetX;
					textLabel.y = PointMarker.labelPositionPadding + pixelOffsetY+textLabel.triangleHeight;
					break;
				case AlignPosition.MIDDLE_LEFT:
					textLabel.x = -(_nLabelWidth + PointMarker.labelPositionPadding) + pixelOffsetX-textLabel.triangleHeight;
					textLabel.y = -_nLabelHeight / 2 + pixelOffsetY;
					break;
				case AlignPosition.MIDDLE_RIGHT: 
					textLabel.x = PointMarker.labelPositionPadding + pixelOffsetX+textLabel.triangleHeight;
					textLabel.y = -_nLabelHeight / 2 + pixelOffsetY;
					break;
				case AlignPosition.TOP_LEFT:
					textLabel.x = -(_nLabelWidth + PointMarker.labelPositionPadding) + pixelOffsetX;
					textLabel.y = -(_nLabelHeight + PointMarker.labelPositionPadding) + pixelOffsetY-textLabel.triangleHeight;
					break;
				case AlignPosition.TOP_RIGHT:
					textLabel.x = PointMarker.labelPositionPadding + pixelOffsetX;
					textLabel.y = -(_nLabelHeight + PointMarker.labelPositionPadding) + pixelOffsetY-textLabel.triangleHeight;
					break;
				case AlignPosition.BOTTOM_LEFT:
					textLabel.x = -(_nLabelWidth + PointMarker.labelPositionPadding) + pixelOffsetX;
					textLabel.y = PointMarker.labelPositionPadding + pixelOffsetY+textLabel.triangleHeight;
					break;
				case AlignPosition.BOTTOM_RIGHT:
					textLabel.x = PointMarker.labelPositionPadding + pixelOffsetX;
					textLabel.y = PointMarker.labelPositionPadding + pixelOffsetY+textLabel.triangleHeight;
					break;
				case AlignPosition.TOP_CENTER:
				default:
					textLabel.x = -_nLabelWidth / 2 + pixelOffsetX;
					textLabel.y = -(_nLabelHeight + PointMarker.labelPositionPadding) + pixelOffsetY-textLabel.triangleHeight;
					break;
			}
		}
		/**
		 * 字形图例滤镜
		 */
		private function buildLegendFilter():void
		{
			if (m_nLegendBorderAlpha <= 0.0) 
			{
				legendLabel.filters = null;
			}
			else {
				legendLabel.filters = [new GlowFilter(m_iLegendBorderColor, m_nLegendBorderAlpha, 2, 2, 4)];
			}
		}
		
		/**
		 * 清除所有标注
		 */
		public function clearLabel():void
		{
			for (var _k:int = labels.length - 1; _k >= 0 ; _k--)
			{
				if(labels[_k].parent== this)
				{
					removeChild(labels[_k]);
				}
			}
			labels = [];
		}
		
		/**
		 * 显示或隐藏所有标注
		 * @param	val	若需显示，则为true，否则为false
		 */
		public function setLabelsVisible(val:Boolean):void
		{	
			for (var _k:int = 0; _k < labels.length; _k++)
			{
				if(labels[_k].parent != this)
				{
					this.addChild(labels[_k]);
				}
				labels[_k].visible = val;
			}
		}
		/**
		 * 更新点对象图形位置
		 */
		public function updateMarker():void
		{
			updateLegend();
			for (var _k:int = labels.length - 1; _k >= 0 ; _k--)
			{
				labels[_k].x=labels[_k].x+m_iOffsetX;
				labels[_k].y=labels[_k].y+m_iOffsetY;
			}
		}
		/**
		 * 更新点对象图例位置
		 */
		private function updateLegend():void
		{
			if(legend)
			{
				legend.x = -m_oLegend.width / 2 + m_iOffsetX;
				legend.y = -m_oLegend.height / 2 + m_iOffsetY;
			}
		}
		
		/**
		 * 预留接口：根据地图缩放级别，更新标注显示隐藏状态
		 */
		public function updateLabelsVisible():void
		{
			
		}
	}
}