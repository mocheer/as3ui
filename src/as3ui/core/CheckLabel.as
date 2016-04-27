package as3ui.core
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.core.IDataRenderer;
	
	public class CheckLabel extends TextLabel implements IDataRenderer
	{
		public static const Type_Default:int = 0;
		public static const Type_Checkbox:int = 1;
		//
		public var type:int = 0;
		protected var m_oData:Object;
		protected var m_oLoader:Loader;
		protected var m_oIsOver:Boolean = false;

		public function CheckLabel()
		{
			super();
			this.cacheAsBitmap = false;
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
		}
		
		public function get data():Object
		{
			return m_oData;
		}
		/**
		 * @param value  {selected:选中状态，label：文本，icon:图片路径}
		 */
		public function set data(value:Object):void
		{
			if(m_oData!=value)
			{
				var hasEvent:Boolean = m_oData  && !m_oData.children;
				var needEvent:Boolean = !value.children;
				if(hasEvent && !needEvent)
				{
					this.removeEventListener(MouseEvent.CLICK,onMouseClick);
				}else if(needEvent)
				{
					this.addEventListener(MouseEvent.CLICK,onMouseClick);
				}
				if(!m_oLoader && value.icon)
				{
					m_oLoader = new Loader();
					m_oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadedComplete);
					var icon:String = value.icon;
					switch(value.type)
					{
						case Type_Checkbox:
							icon = (value.selected?icon+"_selected":icon)+".png"
							break;
					}
					m_oLoader.load(new URLRequest(icon));
				}else
				{
					leftMargin = 0;
				}
				text = value.label;
				type = value.type;
				m_oData = value;
				updateGraphics();
			}
		}
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			if(m_oData)
			{
				text = m_oData.label;
			}
		}
		
		/**
		 * 加载完成
		 */
		private function onLoadedComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			var content:DisplayObject = loaderInfo.content;
			content.x = paddingLeft;
			content.y = paddingTop+type;
			addChild(content);
		}
		
		/**
		 * 模拟UIComponent的setStyle方法
		 */
		public function setStyle(key:String,value:Object):void
		{
			switch(key)
			{
				case "horizontalGap":
					leftMargin = value as Number;
					break;
				case "paddingLeft":
					paddingLeft = value as Number;
					break;
				case "paddingTop":
					paddingTop = value as Number;
					break;
			}
		}
		/**
		 * 
		 */
		protected function onMouseClick(event:Event):void
		{    
			if(m_oData)
			{
				m_oData.selected = !m_oData.selected;
				if(type==Type_Checkbox)
				{
					if(contains(m_oLoader.content))
					{
						removeChild(m_oLoader.content);
					}
					var icon:String = (m_oData.selected?m_oData.icon+"_selected":m_oData.icon)+".png"
					m_oLoader.load(new URLRequest(icon));
				}
				
				updateGraphics();
				dispatchEvent(new Event(Event.CHANGE));
			}
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
				if(m_oIsOver!=false)
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
			if(m_oIsOver && type==Type_Default)
			{
				super.updateGraphics();
			}else
			{
				graphics.clear();
			}
			if(m_oData.children)
			{
				drawTriangles();
			}
		}
		/**
		 * 0.5*Math.PI = 1.5707963267949
		 */
		public function drawTriangles(angle:Number=-1.57079,radius:Number=7,color:uint=0x6F94B7):void
		{
			var rr:Number = radius*0.5;
			graphics.lineStyle();
			graphics.beginFill(color,1);
			var exAngle:Number= Math.PI * 0.21; 
			var p1:Point= new Point(width-rr-2,height*0.5);
			var p2:Point=Point.polar(radius,angle + exAngle);
			var p3:Point=Point.polar(radius,angle - exAngle);
			var oP:Point = Point.polar(rr*0.9,angle);
			p1.offset(-oP.x,-oP.y);
			p2.offset(p1.x, p1.y);
			p3.offset(p1.x, p1.y);
			
			graphics.moveTo(p1.x, p1.y);
			graphics.lineTo(p2.x, p2.y);
			graphics.lineTo(p3.x, p3.y);
			graphics.lineTo(p1.x, p1.y);
			graphics.endFill();
		}
	}
}