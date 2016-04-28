package as3ui.control
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.Container;
	
	/**
	 * 对象拖动和缩放的控件
	 */		
	public class DrawHandler
	{
		
		//操作的小矩形框的大小
		private static const HandlerSize:int = 10;
		
		//本类的公共对象
		private static var focusObjectHandler:DrawHandler;
		
		//对象的容器
		private var container:Container;
		
		//实际控制对象
		private var widget:DisplayObject;
		
		//9个可拖动框
		private var rects:Array = [];
		
		//当前正在操作的句柄
		private var currRect:Sprite;
		
		//是否可改变大小
		private var sizeable:Boolean;
		
		private static var handler:DrawHandler;
		
		/**
		 * 构造方法
		 *  
		 * @param container
		 * @param single
		 * 
		 */		
		public function DrawHandler(container:Container, single:Single){
			if(single == null){
				throw new Error("DrawHandler new error.");
			}
			this.container = container;
			rects = [];
			for(var i:int = 0; i < 9; i++){
				var rect:Sprite = createRectHandler();
				rect.addEventListener(MouseEvent.MOUSE_DOWN, evt_rect_mouse_down);
				rect.addEventListener(MouseEvent.MOUSE_UP, evt_rect_mouse_up);
				
				rects[i] = rect;
			}
			container.addEventListener(MouseEvent.MOUSE_UP, evt_container_mouse_up);
		}
		
		
		/**
		 * 静态方法，添加对象处理的句柄
		 *  
		 * @param container
		 * @param widget
		 * @param sizeable
		 * 
		 */		
		public static function addHandler(container:Container, widget:DisplayObject, sizeable:Boolean = true):void
		{
			handler = new DrawHandler(container, new Single());
			focusObjectHandler=null;
			handler.addWidget(widget, sizeable);
		} 
		
		/**
		 *移除句柄 
		 * 
		 */			
		public static function removeHandler():void
		{
			if(handler)
			{
				handler.setOperating(false);
			}
			
		}
		
		/**
		 * 添加显示对象
		 * @param _widget
		 * @param sizeable
		 */		
		private function addWidget(_widget:DisplayObject, sizeable:Boolean):void{
			if (widget && widget.parent){
				widget.parent.removeChild(widget);
			}
			this.sizeable = sizeable;
			widget = _widget;
			var p1:Point = new Point(widget.x, widget.y);
			var p2:Point = new Point(widget.x + widget.width, widget.y + widget.height);
			widget.addEventListener(MouseEvent.CLICK, evt_change_focus);
			setRectsPos(p1, p2); 
			if (focusObjectHandler == null){
				setFocus(this);
			}
			else
			{
				setFocus(focusObjectHandler);
			}
		}
		
		
		
		/**
		 * 在控件上点击鼠标左键
		 * @param e
		 */		
		private function evt_change_focus(e:MouseEvent):void{
			//setFocus(this);//选中时也出现控件，修复点击图标不能取消的效果
		}
		
		
		/**
		 * 在容器上按下鼠标左键
		 *  
		 * @param e
		 * 
		 */		
		private function evt_container_mouse_up(e:MouseEvent):void{
			if (currRect){
				currRect.stopDrag();
			}
			
			container.removeEventListener(MouseEvent.MOUSE_MOVE, evt_mouse_move);
		}
		
		
		/**
		 * 在句柄上按下鼠标左键
		 * @param e
		 */		
		private function evt_rect_mouse_down(e:MouseEvent):void{
			var rect:Sprite = e.currentTarget as Sprite;
			rect.startDrag();
			currRect = rect;
			container.addEventListener(MouseEvent.MOUSE_MOVE, evt_mouse_move);
		}
		
		
		/**
		 * 在句柄上松开鼠标左键
		 * @param e
		 */		
		private function evt_rect_mouse_up(e:MouseEvent):void{
			var rect:Sprite = e.currentTarget as Sprite;
			rect.stopDrag();
			currRect = null;
			container.removeEventListener(MouseEvent.MOUSE_MOVE, evt_mouse_move);
		}
		
		
		/**
		 * 拖动矩形句柄，鼠标移动
		 * 
		 */
		private function evt_mouse_move(e:MouseEvent):void{
			if (currRect) {
				updatePosition(currRect);
			}
		}
		
		/**
		 * 当某个句柄移动时，调整相应句柄的位置
		 *  
		 * @param rect
		 * 
		 */		
		private function updatePosition(rect:Sprite):void{
			var ind:int = rects.indexOf(rect);
			var p1:Point = new Point(rects[0].x, rects[0].y);
			var p2:Point = new Point(rects[7].x, rects[7].y);
			if (ind == 0){//左上角
				p1.x = rect.x;
				p1.y = rect.y;
			} else if (ind == 1){//上部
				p1.y = rect.y;
			} else if (ind == 2){//右上角
				p2.x = rect.x;
				p1.y = rect.y;
			} else if (ind == 3){//左边
				p1.x = rect.x;
			} else if (ind == 4){//右边
				p2.x = rect.x;
			} else if (ind == 5){//左下角
				p1.x = rect.x;
				p2.y = rect.y;
			} else if (ind == 6){//下边
				p2.y = rect.y;
			} else if (ind == 7){//右下角
				p2.x = rect.x;
				p2.y = rect.y;
			} else if (ind == 8){//中间的
				var w:Number = p2.x - p1.x;
				var h:Number = p2.y - p1.y;
				p1.x = rect.x - w / 2;
				p1.y = rect.y - h / 2;
				p2.x = p1.x + w;
				p2.y = p1.y + h;
			}else {
				throw new Error("No such a handler");
			}
			setRectsPos(p1, p2);
		}
		
		
		
		/**
		 * 当前对象是否是焦点的操作对象
		 * 
		 * 
		 */
		private function setOperating(value:Boolean):void
		{
			var i:int;
			var handler:Sprite;
			var start:int = sizeable? 0 : 8;
			if (value)
			{//可操作
				for(i = start; i < rects.length; i++)
				{
					handler = rects[i];
					container.rawChildren.addChild(handler);						
				}
			} 
			else 
			{//不可操作
				if(container && container.rawChildren.numChildren>9)
				{
					for(i = start; i < rects.length; i++)
					{
						handler = rects[i]
						if (handler)
						{
							try
							{	
								
								container.rawChildren.removeChild(handler);
								//handler.parent.removeChild(handler);
							}
							catch(e:Event)
							{
								
							}
							
						}
					}
				}
			}
		}
		
		/**
		 * 创建句柄，用来拖动和拉伸对象
		 * 
		 */
		private function createRectHandler():Sprite{
			var img:Sprite = new Sprite();
			var size:int = 10;
			img.graphics.beginFill(0x00ffff, 0.5);
			img.graphics.drawRect(-size / 2, -size / 2, size, size);
			img.graphics.endFill();
			img.graphics.lineStyle(1, 0);
			img.graphics.drawRect(-size / 2, -size / 2, size, size);
			
			return img;
		}
		
		/**
		 * 设定各个句柄的位置
		 *  
		 * @param p1
		 * @param p2
		 * 
		 */		
		private function setRectsPos(p1:Point, p2:Point):void{
			if (p1.x > p2.x){//判定，并且保证 p1 在 p2 的左上方
				var value:Number = p1.x;
				p1.x = p2.x;
				p2.x = value;
			}
			if (p1.y > p2.y){//判定，并且保证 p1 在 p2 的左上方
				value = p1.y;
				p1.y = p2.y;
				p2.y = value;
			}
			rects[0].x = p1.x;
			rects[0].y = p1.y;
			
			rects[1].x = (p1.x + p2.x) / 2;
			rects[1].y = p1.y;
			
			rects[2].x = p2.x;
			rects[2].y = p1.y;
			
			rects[3].x = p1.x;
			rects[3].y = (p1.y + p2.y) / 2;
			
			rects[4].x = p2.x;
			rects[4].y = (p1.y + p2.y) / 2;
			
			rects[5].x = p1.x;
			rects[5].y = p2.y;
			
			rects[6].x = (p1.x + p2.x) / 2;
			rects[6].y = p2.y;
			
			rects[7].x = p2.x;
			rects[7].y = p2.y;
			
			rects[8].x = (p1.x + p2.x) / 2;
			rects[8].y = (p1.y + p2.y) / 2;
			
			//改变对象大小
			widget.x = p1.x;
			widget.y = p1.y;
			widget.width = p2.x - p1.x;
			widget.height = p2.y - p1.y;
		}
		
		/**
		 * 设定当前焦点对象
		 * 
		 */
		private static function setFocus(value:DrawHandler):void
		{
			if (focusObjectHandler){
				focusObjectHandler.setOperating(false);
			}
			focusObjectHandler = value;
			if(focusObjectHandler){
				focusObjectHandler.setOperating(true);
			}
		}
		
		
	}
}class Single{}