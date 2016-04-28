package as3ui.ex.dateField
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import as3ui.ex.dateField.core.picker.DateChooserEx;
	import as3ui.ex.dateField.core.picker.TimeChooser;
	import as3ui.ex.dateField.core.picker.TimeInput;
	
	import mx.containers.Box;
	import mx.containers.Panel;
	import mx.controls.DateChooser;
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	import mx.core.UITextField;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;

	/**
	 * 继承DateField重新封装成一个带有时分秒的时间控件，并有年份月份，时分秒快速选择的功能
	 * <br/>暂时不支持从textInput格式化时间
	 * DateFormatter.parseDateString  //只支持特定格式 
	 * DateField.stringToDate   //不支持时分秒
	 * @author gyb
	 * @date：2014-12-23 下午01:39:24
	 */
	public class DateFieldEx extends DateField
	{
		//==================================================属性及构造函数================================================
		private var _dateChooser:DateChooserEx;
		private var _timeChooser:TimeChooser;
		private var _timeInput:TimeInput;
		private var isRangeEndNewDate:Boolean = false;
		private var isHoursEditable:Boolean = true;
		private var isMinutesEditable:Boolean = true;
		private var isSecondsEditable:Boolean = true;
		public function DateFieldEx()
		{
			super();
			this.formatString = "YYYY-MM-DD JJ:NN:SS"; //默认时间格式
			this.dayNames=["日", "一", "二", "三", "四", "五", "六"];
			this.monthNames=["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];
			this.dropdownFactory = new ClassFactory(DateChooserEx);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			this.addEventListener(DropdownEvent.CLOSE,onDropDownClose);
		}
		//===================================================Getter/Setter================================================
		/**
		 *
		 */
		public function set timeChooserVisible(value:Boolean):void	
		{
			_timeChooser.visible = value;
		}
		/**
		 * 时分秒是否可编辑
		 */
		public function set timeEditable(value:Boolean):void
		{
			hoursEditable = minutesEditable = secondsEditable = value;
			
		}
		/**
		 * 时是否可编辑
		 */
		public function set hoursEditable(value:Boolean):void
		{
			isHoursEditable = value;
			if(_timeInput && _timeInput.hoursInputField)
			{
				_timeInput.hoursInputField.enabled = value;
			}
		}
		/**分是否可编辑
		 * 
		 */
		public function set minutesEditable(value:Boolean):void
		{
			isMinutesEditable = value;
			if(_timeInput && _timeInput.minutesInputField)
			{
				_timeInput.minutesInputField.enabled = value;
			}
		}
		/**
		 * 秒是否可编辑
		 */
		public function set secondsEditable(value:Boolean):void
		{
			isSecondsEditable = value;
			if(_timeInput && _timeInput.secondsInputField)
			{
				_timeInput.secondsInputField.enabled = value;
			}
		}
		/**
		 * 选择的时间是否不能大于计算机本地时间
		 */
		public function set rangeEndNewDate(value:Boolean):void
		{
			if(isRangeEndNewDate!=value)
			{
				if(isRangeEndNewDate == true)
				{
					this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
				isRangeEndNewDate = value;
				if(isRangeEndNewDate == true)
				{
					if(selectableRange==null)
					{
						selectableRange = {};
					}
					selectableRange.rangeEnd = new Date();
					this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
			}
		}
		/**
		 *设置时间当selectedDate!=selectedDate时触发文本更改事件
		 */
		override public function set selectedDate(value:Date):void
		{
			super.selectedDate = value;
			//因为flex 的延迟优化机制，selectedDateChanged事件会在以下方法执行完再执行，使得timeChooser可以获取到时分秒
			if(value)
			{
				selectedDate.hours = value.hours;
				selectedDate.minutes = value.minutes;
				selectedDate.seconds = value.seconds;
			}
		}
		/**
		 * 是否重置时分秒控件的值为0
		 */
		public function set resetTimeChooser(value:Boolean):void
		{
			if(value)
			{
				_timeInput.hoursInputField.text = "00";
				_timeInput.minutesInputField.text = "00";
				_timeInput.secondsInputField.text = "00";
			}
		}
		/**
		 * 
		 */
		public function set dateEnabled(value:Boolean):void
		{
			_dateChooser.dateEnabled = value;
		}
		public function set monthEnabled(value:Boolean):void
		{
			_dateChooser.monthEnabled = value;
		}
		public function set yearEnabled(value:Boolean):void
		{
			_dateChooser.yearEnabled = value;
		}
		//=======================================================事件=====================================================
		protected function onDropDownClose(event:Event):void
		{
			if(_dateChooser)
			{
				_dateChooser.resetPopup();
			}
		}
		/**
		 * 刷新最新时间范围
		 */
		protected function onEnterFrame(event:Event):void
		{
			selectableRange.rangeEnd = new Date();
		}
		/**
		 *  重写，防止DateChooser被关掉
		 */
		override protected function focusOutHandler(event:FocusEvent):void
		{
			_dateChooser.resetPopup();
		}
		/**
		 * 构建完成事件处理
		 */
		private function onCreationComplete(event:Event):void
		{
			_dateChooser = this.dropdown as DateChooserEx;
			_dateChooser.doubleClickEnabled = false;
//			_dateChooser.addEventListener(FlexEvent.CREATION_COMPLETE,onDateChooserComplete);
			_dateChooser.addEventListener(CalendarLayoutChangeEvent.CHANGE,onDateChooserClick);
			
			//
			_timeChooser = _dateChooser.timeChooser;
			_timeChooser.addEventListener(FlexEvent.CREATION_COMPLETE,onTimeChooserComplete);
			_timeChooser.addEventListener(Event.CANCEL,onCancelHandle);
			_timeChooser.addEventListener(Event.COMPLETE,onCompleteHandle);
			_timeChooser.addEventListener(Event.CHANGE,onChangeHandle);
			_timeChooser.addEventListener("newDate",onNewDateHandle);
			//
			_timeInput = _timeChooser.timeInput;
			
			this.labelFunction = formatDate; //从日历上格式化时间到textInput
			this.parseFunction = null;
		}
		
		/**
		 * 要弹出DateChooser后才开始分派事件
		 */
		private function onDateChooserComplete(event:Event):void
		{
			
		}
		/**
		 * 要弹出DateChooser后才开始分派事件
		 */
		private function onTimeChooserComplete(event:Event):void
		{
			_timeInput.hoursInputField.enabled = isHoursEditable;
			_timeInput.minutesInputField.enabled = isMinutesEditable;
			_timeInput.secondsInputField.enabled = isSecondsEditable;
			
		}
		/**
		 * 时间值变化监听函数
		 * 单击日期值(包括时分秒)不关闭datechooser
		 */
		private function onDateChooserClick(event:Event):void	
		{
			this.open();
		}
		/**
		 * 改变时分秒事件
		 */
		private function onChangeHandle(event:Event):void
		{
			updateTextInput();
		}
		/**
		 * 清空事件(必须阻止冒泡事件的传递)
		 */
		private function onCancelHandle(event:Event):void	
		{
			selectedDate = null;
			event["oriEvent"].stopPropagation();
		}
		/**
		 * 重置事件(必须阻止冒泡事件的传递)
		 */
		private function onNewDateHandle(event:Event):void	
		{
			selectedDate = new Date();
			event["oriEvent"].stopPropagation();
		}
		/**
		 * 确定事件(必须阻止冒泡事件的传递)
		 */
		private function onCompleteHandle(event:Event):void	
		{
			this.close();
			event["oriEvent"].stopPropagation();
		}
		//=======================================================方法=====================================================
		/**
		 * 
		 */
		public function updateTimeInupt():void
		{
			if(_timeInput && selectedDate)
			{
				_timeInput.hours = selectedDate.hours;
				_timeInput.minutes = selectedDate.minutes;
				_timeInput.seconds = selectedDate.seconds;
			}
		}
		/**
		 * 更新时间文本显示
		 */
		public function updateTextInput():void
		{
			textInput.text = formatDate(selectedDate);
		}
		/**
		 * 格式化时间
		 */
		private function formatDate(currentDate:Date):String	
		{
			if (currentDate)
			{
				if(_timeInput)
				{
					currentDate.hours = _timeInput.hours;
					currentDate.minutes = _timeInput.minutes;
					currentDate.seconds = _timeInput.seconds;
				}
			}
			var df:DateFormatter=new DateFormatter();
			df.formatString= formatString;
			var times:String=df.format(currentDate);
			return times;
		}
	}
}