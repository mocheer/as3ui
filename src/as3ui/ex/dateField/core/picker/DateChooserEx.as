package as3ui.ex.dateField.core.picker
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import as3ui.ex.dateField.core.indicator.DatePickerIndicator;
	import as3ui.ex.dateField.core.indicator.TodayPickerIndicator;
	
	import mx.containers.Grid;
	import mx.controls.Alert;
	import mx.controls.DateChooser;
	import mx.controls.TextInput;
	import mx.controls.TileList;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.DropdownEvent;
	import mx.events.ListEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.FocusManager;
	import mx.managers.PopUpManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	[Style(name="todayIndicatorSkin", type="Class", inherit="no")]
	[Style(name="rollOverIndicatorSkin", type="Class", inherit="no")]
	[Style(name="selectionIndicatorSkin",type="Class",inherit="no") ]
	/**
	 * @author gyb
	 * @date：2014-12-23 下午02:02:42
	 */
	public class DateChooserEx extends DateChooser
	{
		//==================================================属性及构造函数================================================
		private static var stylesInited:Boolean=initStyles();
		private var _monthChooser:TileList;
		private var _yearChooser:TileList;
		private var _quickChooser:TileList;
		private var _hoursChooser:TileList;
		private var _minutesChooser:TileList;
		private var isDateEnabled:Boolean = true;
		private var isMonthEnabled:Boolean = true;
		private var isYearEnabled:Boolean = true;
		private var _timeChooser:TimeChooser;
		private var _timeInput:TimeInput;
		private var _hoursInputField:TextInput;
		private var _minutesInputField:TextInput;
		/**
		 *  设置默认中文显示
		 *  添加了时分秒的选择，并带有年份月份快速选择的功能
		 */
		public function DateChooserEx()
		{
			super();
			this.width = 195;
			this.height = 230;
			this.dayNames=["日", "一", "二", "三", "四", "五", "六"];
			this.monthNames=["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];
			
			this.addEventListener(MouseEvent.CLICK,onMouseClick,true);
			_timeChooser = new TimeChooser();
			
		}
		/**
		 * 子对象
		 */
		override protected  function createChildren():void
		{
			super.createChildren();
			if(_timeChooser.parent !=this)
			{
				_timeChooser.x = 10;
				_timeChooser.width = this.width;
				_timeChooser.addEventListener("quickSelect",onQuickSelectClick);
				addChild(_timeChooser);
				_timeInput = _timeChooser.timeInput;
				_hoursInputField = _timeInput.hoursInputField;
				_minutesInputField = _timeInput.minutesInputField;
				_hoursInputField.addEventListener(MouseEvent.CLICK,onHoursClick);
				_minutesInputField.addEventListener(MouseEvent.CLICK,onMinutesClick);
			}
			if(monthDisplay)
			{
				monthDisplay.addEventListener(MouseEvent.CLICK,onMonthDisplayClick);
			}
			if(yearDisplay)
			{
				yearDisplay.addEventListener(MouseEvent.CLICK,onYearDisplayClick);
			}
			
			if(upYearButton)
			{
				upYearButton.addEventListener(MouseEvent.CLICK,onYearMonthButtoonClick);
			}
			if(downYearButton)
			{
				downYearButton.addEventListener(MouseEvent.CLICK,onYearMonthButtoonClick);
			}
			if(fwdMonthButton)
			{
				fwdMonthButton.addEventListener(MouseEvent.CLICK,onYearMonthButtoonClick);
			}
			if(backMonthButton)
			{
				backMonthButton.addEventListener(MouseEvent.CLICK,onYearMonthButtoonClick);
			}
			
			dateEnabled = isDateEnabled;
			monthEnabled = isMonthEnabled;
			yearEnabled =  isYearEnabled;
			
		}
		
		//===================================================Getter/Setter================================================
		/**
		 * 日期可选
		 */
		public function set dateEnabled(value:Boolean):void
		{
			if(dateGrid && dateGrid.enabled != value)
			{
				dateGrid.enabled = value;
			}else if(isDateEnabled != value)
			{
				isDateEnabled = value;
			}
		}
		/**
		 * 月份可选
		 */
		public function set monthEnabled(value:Boolean):void
		{
			if(monthDisplay)
			{
				monthDisplay.enabled = value;
			}
			if(fwdMonthButton)
			{
				fwdMonthButton.enabled = value;
			}
			if(backMonthButton)
			{
				backMonthButton.enabled = value;
			}
			if(isMonthEnabled != value)
			{
				isMonthEnabled = value;
			}
			
		}
		/**
		 * 年份可选
		 */
		public function set yearEnabled(value:Boolean):void
		{
			if(yearDisplay)
			{
				yearDisplay.enabled = value;
			}
			if(upYearButton)
			{
				upYearButton.enabled = value;
			}
			if(downYearButton)
			{
				downYearButton.enabled = value;
			}
			if(isMonthEnabled != value)
			{
				isYearEnabled = value;
			}
		}
		/**
		 * 时分秒选择器
		 */
		public function get timeChooser():TimeChooser
		{
			return _timeChooser;
		}
		/**
		 * 时分秒选择器是否可见
		 */
		public function set timeChooserVisible(value:Boolean):void
		{
			if(value)
			{
				dateGrid.height = this.height - dateGrid.y;
			}else
			{
				dateGrid.height = this.height - dateGrid.y -30;
			}
		}
		/**
		 * 设置时间
		 */
		override public function set selectedDate(value:Date):void
		{
			super.selectedDate = value;
			if(value)
			{
				if(_timeChooser && _timeChooser.timeInput)
				{
					_timeChooser.timeInput.hours = value.hours;
					_timeChooser.timeInput.minutes = value.minutes;
					_timeChooser.timeInput.seconds = value.seconds;
				}
			}
			
		}
		
		//=======================================================事件=====================================================
		/**
		 * 快速点击事件处理
		 */
		private function onQuickSelectClick(event:Event):void
		{
			dateGrid.visible = !dateGrid.visible;
			if(_quickChooser == null)
			{
				_quickChooser = new TileList();
				_quickChooser.columnCount = 1;
				_quickChooser.height = dateGrid.height - 28;
				_quickChooser.rowHeight = 25;
				_quickChooser.width = dateGrid.width;
				_quickChooser.x = dateGrid.x;
				_quickChooser.y = dateGrid.y;
				this.addChild(_quickChooser);
				_quickChooser.addEventListener(ListEvent.CHANGE,onQuickListChange);
			}
			if(dateGrid.visible)
			{
				_quickChooser.visible = false;
			}else
			{
				_quickChooser.visible = true;
				var _quickDate:Date = new Date(displayedYear,displayedMonth,selectedDate.date);
				var _dataProvider:Array = [];
				var df:DateFormatter=new DateFormatter();
				df.formatString= "YYYY-MM-DD JJ:NN";
				for (var i:int =0;i<24;i++)
				{
					_quickDate.setHours(i);
					for (var j:int=0;j<60;j=j+5)
					{
						_quickDate.setMinutes(j);
						var quickTimeString:String=df.format(_quickDate);
						_dataProvider.push(quickTimeString);
					}
				}
				_quickChooser.dataProvider = _dataProvider;
			}
		}
		/**
		 * 日历点击事件处理
		 */
		private function onMouseClick(event:Event):void
		{
			resetPopup();
		}
		
		/**
		 * 年份点击事件处理
		 */
		private function onYearDisplayClick(event:Event):void
		{
			yearDisplay.background = !yearDisplay.background;
			if(_yearChooser == null)
			{
				_yearChooser = new TileList();
				_yearChooser.verticalScrollPolicy = "off";
				_yearChooser.columnCount = 2;
				_yearChooser.rowCount = 5;
				//				_yearChooser.move(monthDisplay.x,monthDisplay.y + monthDisplay.height);
				var showPosition:Point = yearDisplay.localToGlobal(new Point(0,yearDisplay.height));
				_yearChooser.x = showPosition.x;
				_yearChooser.y = showPosition.y;
				_yearChooser.addEventListener(ListEvent.CHANGE,onYearChange);
			}
			if(yearDisplay.background)
			{
				var _yearDataProvider:Array = [];
				for (var i:int = displayedYear-5;i<displayedYear+5;i++)
				{
					_yearDataProvider.push(i);
				}
				_yearChooser.selectedIndex = 5;
				_yearChooser.selectedIndices
				_yearChooser.dataProvider = _yearDataProvider;
				PopUpManager.addPopUp(_yearChooser,this);
			}else
			{
				PopUpManager.removePopUp(_yearChooser);
			}
		}
		
		/**
		 * 月份点击事件处理
		 */
		private function onMonthDisplayClick(event:Event):void
		{
			monthDisplay.background = !monthDisplay.background;
			if(_monthChooser == null)
			{
				_monthChooser = new TileList();
				_monthChooser.verticalScrollPolicy = "off";
				_monthChooser.columnCount = 2;
				_monthChooser.rowCount = 6;
				//				_monthChooser.move(monthDisplay.x,monthDisplay.y + monthDisplay.height)
				_monthChooser.dataProvider = this.monthNames;
				var showPosition:Point = monthDisplay.localToGlobal(new Point(0,monthDisplay.height));
				_monthChooser.x = showPosition.x;
				_monthChooser.y = showPosition.y;
				_monthChooser.addEventListener(ListEvent.CHANGE,onMonthChange);
			}
			if(monthDisplay.background)
			{
				_monthChooser.selectedIndex = displayedMonth;
				
				PopUpManager.addPopUp(_monthChooser,this);
			}else
			{
				PopUpManager.removePopUp(_monthChooser);
			}
		}
		/**
		 * 时点击事件处理
		 */
		protected function onHoursClick(event:Event):void
		{
			if(_hoursChooser == null)
			{
				_hoursChooser = new TileList();
				_hoursChooser.verticalScrollPolicy = "off";
				_hoursChooser.setStyle("fontSize",10);
				_hoursChooser.columnCount = 6;
				_hoursChooser.rowCount= 4;
				_hoursChooser.width = 142;
				_hoursChooser.height = 96;
				//				_hoursChooser.move(_hoursInputField.x,_hoursInputField.y + _hoursInputField.height);
				var showPosition:Point = _hoursInputField.localToGlobal(new Point(0,0));
				_hoursChooser.x = showPosition.x;
				_hoursChooser.y = showPosition.y - _hoursChooser.height;
				_hoursChooser.addEventListener(ListEvent.CHANGE,onHoursChange);
				_hoursChooser.dataProvider = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"];
			}
			if( _hoursChooser.parent==null)
			{
				PopUpManager.addPopUp(_hoursChooser,this);
			}
			
		}
		/**
		 * 分点击事件处理
		 */
		protected function onMinutesClick(event:Event):void
		{
			if(_minutesChooser == null)
			{
				_minutesChooser = new TileList();
				_minutesChooser.verticalScrollPolicy = "off";
				_minutesChooser.setStyle("fontSize",10);
				_minutesChooser.setStyle("paddingRight",0);
				_minutesChooser.columnCount = 6;
				_minutesChooser.rowCount = 2;
				_minutesChooser.width = 142;
				_minutesChooser.height = 48;
				//				_minutesChooser.move(_minutesInputField.x,_minutesInputField.y + _minutesInputField.height);
				var showPosition:Point = _hoursInputField.localToGlobal(new Point(0,0));
				_minutesChooser.x = showPosition.x;
				_minutesChooser.y = showPosition.y - _minutesChooser.height;
				_minutesChooser.addEventListener(ListEvent.CHANGE,onMinutesChange);
				_minutesChooser.dataProvider = ["0","5","10","15","20","25","30","35","40","45","50","55"];
			}
			if( _minutesChooser.parent==null)
			{
				PopUpManager.addPopUp(_minutesChooser,this);
			}
		}
		
		/**
		 * 快速选择窗口点击事件处理
		 */
		private function onQuickListChange(event:Event):void
		{
			dateGrid.visible = true;
			_quickChooser.visible = false;
			selectedDate =  DateFormatter.parseDateString(_quickChooser.selectedItem as String);
		}
		
		/**
		 * 年份弹出窗口点击事件处理
		 */
		private function onYearChange(event:Event):void
		{
			var selYear:int = Number(_yearChooser.selectedItem);
			if(selectableRange)
			{
				if(selectableRange.rangeEnd && selectableRange.rangeEnd.fullYear < selYear)
				{
					selYear = selectableRange.rangeEnd.fullYear;
				}else if(selectableRange.rangeStart && selectableRange.rangeStart.fullYear > selYear)
				{
					selYear = selectableRange.rangeStart.fullYear;
				}
			}
			displayedYear = selYear;
			var newDate:Date = new Date(selYear,displayedMonth,selectedDate.date);
			super.selectedDate = newDate;
			dispatchCalendarLayout(event);
			yearDisplay.background = false;
			PopUpManager.removePopUp(_yearChooser);
		}
		private function onYearMonthButtoonClick(event:Event):void
		{
			var newDate:Date = new Date(displayedYear,displayedMonth,selectedDate.date);
			super.selectedDate = newDate;
			dispatchCalendarLayout(event);
		}
		
		/**
		 * 月份弹出窗口点击事件处理
		 */
		private function onMonthChange(event:Event):void
		{	
			var selIndex:int = _monthChooser.selectedIndex;
			if(selectableRange)
			{
				if(selectableRange.rangeEnd && selectableRange.rangeEnd.fullYear == displayedYear && selectableRange.rangeEnd.month < selIndex)
				{
					selIndex = selectableRange.rangeEnd.month;
					
				}else if(selectableRange.rangeStart && selectableRange.rangeStart.fullYear == displayedYear && selectableRange.rangeStart.month > selIndex)
				{
					selIndex = selectableRange.rangeStart.month;
				}
			}
			displayedMonth = selIndex;
			var newDate:Date = new Date(displayedYear,selIndex,selectedDate.date);
			super.selectedDate = newDate;
			dispatchCalendarLayout(event);
			monthDisplay.background = false;
			PopUpManager.removePopUp(_monthChooser);
		}
		/**
		 * 时弹出窗口点击事件处理
		 */
		protected function onHoursChange(event:Event):void
		{
			_timeInput.hours = Number(_hoursChooser.selectedItem);
			PopUpManager.removePopUp(_hoursChooser);
		}
		/**
		 * 分弹出窗口点击事件处理
		 */
		protected function onMinutesChange(event:Event):void
		{
			_timeInput.minutes = Number(_minutesChooser.selectedItem);
			PopUpManager.removePopUp(_minutesChooser);
		}
		
		//=======================================================方法=====================================================
		/**
		 * 重写显示方法，设置日期dateGrid显示高度，控制按钮不被日期遮挡
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight); 
			if(dateGrid)
			{
				var paddingTimer:Number = 28;
				var paddingdate:Number = 0;
				var uiTextField:UITextField = dateGrid.dayBlocksArray[0][6] as UITextField;
				if(uiTextField && uiTextField.htmlText!="" || uiTextField.text!="" )
				{
					paddingdate = 22;
				}
				dateGrid.height =  this.height - dateGrid.y - paddingTimer - paddingdate;
				_timeChooser.y =   dateGrid.y + dateGrid.height - paddingTimer +2 + paddingdate;
				
			}
		}
		/**
		 * 关闭年月时分弹出窗口
		 */
		public function resetPopup():void
		{
			yearDisplay.background = false;
			PopUpManager.removePopUp(_yearChooser);
			
			monthDisplay.background = false;
			PopUpManager.removePopUp(_monthChooser);
			
			PopUpManager.removePopUp(_hoursChooser);
			
			PopUpManager.removePopUp(_minutesChooser);
		}
		/**
		 * 分派时间改变事件
		 */
		private function dispatchCalendarLayout(event:Event):void
		{
			var e:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
			e.newDate = selectedDate;
			e.triggerEvent = event;
			dispatchEvent(e);
		}
		//=======================================================样式=====================================================
		/**
		 * 样式处理
		 */
		private static function initStyles():Boolean
		{
//			if (!StyleManager.getStyleDeclaration("DateChooserEx"))
//			{
//				// If there is no CSS definition for MyDateChooser, 
//				// then create one and set the default value.
//				var dateChooserStyle:CSSStyleDeclaration=new CSSStyleDeclaration();
//				dateChooserStyle.defaultFactory=function():void
//				{
//					this.todayIndicatorSkin = TodayPickerIndicator;
//					this.rollOverIndicatorSkin = DatePickerIndicator;
//					this.selectionIndicatorSkin = DatePickerIndicator;
//				}
//				//如果第三个参数设置为true，在使用该组件的页面加载时会有一个蒙板闪一下的问题
//				StyleManager.setStyleDeclaration("DateChooserEx", dateChooserStyle,false);
//			}
			return true;
		}
		
		
	}
}

