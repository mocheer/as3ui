package as3ui.ex.component.dateField.core.picker
{
	[ExcludeClass]
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.events.DynamicEvent;
	import mx.events.FlexEvent;
	
	//======================================================事件类型=======================================================
	/**当改变时分秒时分派事件**/
	[Event(name="change", type="flash.events.Event")]
	/**当点击清空按钮时分派事件**/
	[Event(name="cancel", type="flash.events.Event")]
	/**当点击确定按钮时分派事件**/
	[Event(name="complete", type="flash.events.Event")]
	/**当点击选择按钮时分派事件**/
	[Event(name="quickSelect", type="flash.events.Event")]
	/**
	 * @author gyb
	 * @date：2014-12-23 下午01:48:50
	 * 实现时分秒的选择
	 */
	public class TimeChooser extends VBox
	{
		//==================================================属性及构造函数================================================
		private var timeLabel:Label;
		//时分秒输入控件
		private var _timeInput:TimeInput;
		//时分秒容器
		private var timeHbox:HBox;
		//按钮容器
		private var btnHbox:HBox;
		//清空按钮
		private var clearBtn:LinkButton;
		//当前按钮
		private var newDateBtn:LinkButton;
		//确定按钮
		private var sureBtn:LinkButton;
		//快速选择
		private var quickBtn:LinkButton;
		public function TimeChooser()
		{
			super();
			this.width=180;
			this.height=55;
			this.setStyle("horizontalGap", "0");
			this.setStyle("verticalGap", "0");
			this.setStyle("horizontalScrollPolicy","off");
			this.setStyle("verticalScrollPolicy","off");
			_timeInput = new TimeInput();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
		}
		protected override function createChildren():void
		{
			super.createChildren();
			if (!timeHbox)
			{
				timeHbox=new HBox();
				timeHbox.percentWidth = 100;
				timeHbox.horizontalScrollPolicy = "off";
				timeHbox.setStyle("verticalAlign","middle");
				timeHbox.setStyle("horizontalGap", "2");
				
			}
			if (!btnHbox)
			{
				btnHbox=new HBox();
				btnHbox.percentWidth = 100;
				btnHbox.horizontalScrollPolicy = "off";
				btnHbox.setStyle("paddingTop","3");
				btnHbox.setStyle("paddingRight","20");
				btnHbox.setStyle("horizontalGap", "2");
				btnHbox.setStyle("horizontalAlign", "right");
			}
			if(!timeLabel)
			{
				timeLabel = new Label();
				timeLabel.text = "时间";
				timeHbox.addChild(timeLabel);
			}
			
			if(_timeInput.parent !=this)
			{
				
				_timeInput.addEventListener(Event.CHANGE,onChangeHandle);
				timeHbox.addChild(_timeInput);
			}	
			
			if(!quickBtn)
			{
				quickBtn = new LinkButton();
				quickBtn.label = "选择";
				quickBtn.addEventListener(MouseEvent.CLICK,onQuickBtnClick);
				timeHbox.addChild(quickBtn);
			}
			
			
			if (!newDateBtn)
			{
				newDateBtn=new LinkButton();
				newDateBtn.label="当前";
				newDateBtn.addEventListener(MouseEvent.CLICK, onNewDateHandle);
				btnHbox.addChild(newDateBtn);
			}
			if (!clearBtn)
			{
				clearBtn=new LinkButton();
				clearBtn.label="清空";
				clearBtn.addEventListener(MouseEvent.CLICK, onClearHandle);
				btnHbox.addChild(clearBtn);
			}
			
			if (!sureBtn)
			{
				sureBtn=new LinkButton();
				sureBtn.label="确定";
				sureBtn.addEventListener(MouseEvent.CLICK, onCompleteHandle);
				btnHbox.addChild(sureBtn);
			}
			this.addChild(timeHbox);
			this.addChild(btnHbox);
			
			
		}
		//===================================================Getter/Setter================================================
		public function get timeInput():TimeInput
		{
			return _timeInput;
		}
		//=======================================================事件处理==================================================
		private function onCreationComplete(event:Event):void
		{
			fillButton(clearBtn);
			fillButton(sureBtn);
			fillButton(newDateBtn);
			clearBtn.setStyle("rollOverColor",0x39ADDE);
			sureBtn.setStyle("rollOverColor",0x39ADDE);
			newDateBtn.setStyle("rollOverColor",0x39ADDE);
		}
		protected function onNewDateHandle(event:Event):void
		{
			var newDateEvent:DynamicEvent = new DynamicEvent("newDate");
			newDateEvent.oriEvent = event;
			dispatchEvent(newDateEvent);
		}
		protected function onChangeHandle(event:Event):void
		{
			dispatchEvent(new Event("change"));
		}
		private function onClearHandle(event:MouseEvent):void
		{
			var clearEvent:DynamicEvent = new DynamicEvent("cancel");
			clearEvent.oriEvent = event;
			dispatchEvent(clearEvent);
		}
		private function onCompleteHandle(event:MouseEvent):void
		{
			var completeEvent:DynamicEvent = new DynamicEvent("complete");
			completeEvent.oriEvent = event;
			dispatchEvent(completeEvent);
		}
		protected function onQuickBtnClick(event:Event):void
		{
			var quickSelectEvent:DynamicEvent = new DynamicEvent("quickSelect");
			quickSelectEvent.oriEvent = event;
			dispatchEvent(quickSelectEvent);
		}
		//=======================================================方法=====================================================
		//Halo 主题的默认值为 0xB2E1FF。Spark 主题的默认值为 0xCEDBEF。
		private function fillButton(button:Button,color:uint=0xB2E1FF):void
		{
			if(button)
			{
				button.graphics.clear();
				button.graphics.beginFill(color); 
				button.graphics.drawRect(0,0,button.measuredWidth,button.measuredHeight); 
				button.graphics.endFill(); 
			}
		}
		
	}
}

