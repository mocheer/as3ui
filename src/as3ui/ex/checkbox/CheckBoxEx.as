package as3ui.ex.checkbox
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.controls.CheckBox;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	
	public class CheckBoxEx extends CheckBox
	{
		/***/
		protected var _loader:Loader;
		/** 图标路径*/
		protected var _isOver:Boolean = false;
		/**鼠标停留颜色*/
		public var overColor:uint = 0xC8F3FF;
		
		public function CheckBoxEx()
		{
			super();
			this.addEventListener(Event.CHANGE,onChanged);
		}
		/**
		 * 
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
		}
		
		/**
		 * @param value  {selected:选中状态，label：文本，icon:图片路径,enabled：灰色关闭状态}
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value !=null)
			{
				this.selected = value.selected;
				this.label = value.label;
				if(!_loader  && value.icon)
				{
					_loader = new Loader();
					_loader.load(new URLRequest(value.icon));
					addChild(_loader);
				}
				if("enabled" in data)
				{
					super.enabled = data;
				}
				
			}
		}
		
		//此属性可设置 数据源任意一项不可选 （enabled）
		override public function set enabled(value:Boolean):void
		{ 
			if(data)
			{
				data.enabled = value;
			}
			super.enabled=value;
		}
		
		/**
		 * 
		 */
		protected function onChanged(event:Event):void
		{    
			if(data)
			{
				data.selected = this.selected;
			}
		}
		/**
		 * 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			updateGraphics();
		}
		/**
		 * 
		 */
		override protected function rollOverHandler(event:MouseEvent):void
		{
			super.rollOverHandler(event);
			_isOver = true;
		}
		/**
		 * 
		 */
		override protected function rollOutHandler(event:MouseEvent):void
		{
			super.rollOutHandler(event);
			_isOver = false;
		}
		
		/**
		 * 画箭头 ▲
		 * @end
		 * @param radius 箭头的大小
		 */
		protected function updateGraphics(radius:Number = 7):void
		{
			graphics.clear();
			var iconVisible:Boolean = !data.hideFoldIcon && !(data.children && data.children.length>0) && width>50;
			var currentIcon:DisplayObject= super.mx_internal::currentIcon;
			if(currentIcon)currentIcon.visible = iconVisible;
			graphics.lineStyle();
			graphics.beginFill(overColor,_isOver?0.8:0);
			if(_loader)
			{
				_loader.x = (iconVisible || (!data.hideFoldIcon && width>50))?26:0;
				graphics.drawRect(_loader.x,0,width-_loader.x,height);
			}else
			{
				graphics.drawRect(0,0,width,height);
			}
			
			if(data.children && data.children.length>0)
			{
				graphics.beginFill(0x6F94B7,1);
				var angle:Number = Math.PI
				var exAngle:Number = Math.PI * 0.23; 
				var p1:Point= new Point(width - 5,13);
				var p2:Point=Point.polar(radius, angle + exAngle);
				var p3:Point=Point.polar(radius, angle - exAngle);
				p2.offset(p1.x, p1.y);
				p3.offset(p1.x, p1.y);
				
				graphics.moveTo(p1.x, p1.y);
				graphics.lineTo(p2.x, p2.y);
				graphics.lineTo(p3.x, p3.y);
				graphics.lineTo(p1.x, p1.y);
			}
			graphics.endFill();
	
		}
		
	}
}