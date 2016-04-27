package as3ui.ex.component.dateField.core.picker
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextLineMetrics;
	
	import mx.containers.HBox;
	import mx.controls.NumericStepper;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManager;
	
	use namespace mx_internal;
	
	/**
	 *当时分秒的值变化分派事件
	 */    
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 当时的值变化分派事件
	 */    
	[Event(name="hoursChange",type="flash.events.Event")]
	
	/**
	 * 当分的值变化分派事件
	 */    
	[Event(name="minutesChange",type="flash.events.Event")]
	
	/**
	 * 当秒的值变化分派事件
	 */    
	[Event(name="secondsChange",type="flash.events.Event")]
	
	/**
	 * @author gyb
	 * @date：2014-12-23 下午03:02:42
	 */
	public class TimeInput extends NumericStepper
	{
		/**
		 * Construction 
		 */
		public function TimeInput()
		{
			super();
			this.maxChars = 2;
			this.minimum = 0;
			this.maximum = 23;
			this.stepSize = 1;
			this.addEventListener(FlexEvent.VALUE_COMMIT,valueCommandHandler);
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected  var inputBox:HBox;
		
		/**
		 *  @private
		 */
		protected  var sText:Text;
		protected  var sText2:Text;
		
		/**
		 *  @private
		 */
		public  var hoursInputField:TextInput;
		
		/**
		 *  @private
		 */
		public  var minutesInputField:TextInput;
		
		/**
		 *  @private
		 */
		public  var secondsInputField:TextInput;
		
		/**
		 *  @private
		 */
		protected var _hours:Number = 0;
		/**
		 *  @private
		 */
		protected var _minutes:Number = 0;
		/**
		 *  @private
		 */
		protected var _seconds:Number = 0;
		/**
		 *  @private
		 */
		protected var _time:Date;
		/**
		 *  @private
		 */
		protected var _text:String;
		/**
		 *  @private
		 */
		private var _enabled:Boolean=true;
		
		
		/**
		 * @override creationChildren 
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!inputBox)
			{
				inputBox = new HBox();
				inputBox.setStyle("paddingLeft",0);
				inputBox.setStyle("paddingRight",0);
				inputBox.setStyle("paddingTop",0);
				inputBox.setStyle("paddingBottom",0);
				inputBox.setStyle("horizontalGap",0);
				inputBox.setStyle("borderStyle","solid");
				inputBox.setStyle("verticalAlign","middle");
				addChild(inputBox);
			}
			var v:String = "00";
			var lineMetrics:TextLineMetrics = this.measureText(v);
			var textWidth:Number = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
			var textHeight:Number = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
			
			if (!hoursInputField)
			{
				hoursInputField = createInputField(_hours,textWidth,textHeight);
				inputBox.addChild(hoursInputField);
			}
			inputField=hoursInputField;
			if(!sText){
				sText = createColonText();
				inputBox.addChild(sText);
			}
			if (!minutesInputField)
			{
				minutesInputField = createInputField(_minutes,textWidth,textHeight);
				inputBox.addChild(minutesInputField);
			}
			if(!sText2)
			{
				sText2 = createColonText();
				inputBox.addChild(sText2);
			}
			if (!secondsInputField)
			{
				secondsInputField = createInputField(_seconds,textWidth,textHeight);
				inputBox.addChild(secondsInputField);
			}
		}
		
		private function createInputField(defaultNumber:Number,textWidth:Number,textHeight:Number):TextInput
		{
			var inputField:TextInput = new TextInput();     
			inputField.focusEnabled = false;
			inputField.styleName = this;
			// restrict to numbers - dashes - commas - decimals
			inputField.restrict = "0-9";
			inputField.maxChars = 2;
			inputField.text = formatNumberWithChar(defaultNumber,2,"0");
			inputField.width = textWidth;
			inputField.height = textHeight;
			//hoursInputField.parentDrawsFocus = true;
			//必须为right否则双击时会出现文本消失的bug
			inputField.setStyle("textAlign","right");
			inputField.setStyle("borderStyle","none");                
			inputField.setStyle("paddingLeft",0);
			inputField.setStyle("paddingRight",0);
			inputField.setStyle("paddingTop",0);
			inputField.setStyle("paddingBottom",0);
			inputField.setStyle("horizontalGap",0);
			
			inputField.addEventListener(FocusEvent.FOCUS_IN,inputField_focusInHandler);
			inputField.addEventListener(FocusEvent.FOCUS_OUT, inputField_focusOutHandler);
			inputField.addEventListener(FlexEvent.VALUE_COMMIT,onTextChange);
			return inputField;
		}
		private function createColonText():Text
		{
			var colonText:Text = new Text();
			colonText.text=":";
			colonText.setStyle("textAlign","center");
			colonText.setStyle("paddingLeft",0);
			colonText.setStyle("paddingRight",0);
			colonText.setStyle("paddingTop",0);
			colonText.setStyle("paddingBottom",0);
			colonText.setStyle("horizontalGap",0);
			return colonText;
		}
		/**
		 *  @private
		 *  Return the preferred sizes of the stepper.
		 */
		override protected function measure():void
		{
			super.measure();
			var inputBoxHeight:Number = inputBox.getExplicitOrMeasuredHeight();
			var buttonHeight:Number = prevButton.getExplicitOrMeasuredHeight() +
				nextButton.getExplicitOrMeasuredHeight();
			
			var h:Number = Math.max(inputBoxHeight, buttonHeight);
			h = Math.max(DEFAULT_MEASURED_MIN_HEIGHT, h);
			
			var inputBoxWidth:Number = inputBox.getExplicitOrMeasuredWidth();
			var buttonWidth:Number = Math.max(prevButton.getExplicitOrMeasuredWidth(),
				nextButton.getExplicitOrMeasuredWidth());
			
			var w:Number = inputBoxWidth + buttonWidth;
			w = Math.max(DEFAULT_MEASURED_MIN_WIDTH, w);
			
			measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
			measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
			
			measuredWidth = w;
			measuredHeight = h;
		}
		/**
		 *  @private
		 *  Place the buttons to the right of the text field.
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var w:Number = nextButton.getExplicitOrMeasuredWidth();
			var h:Number = Math.round(unscaledHeight / 2);
			var h2:Number = unscaledHeight - h;
			
			nextButton.x = unscaledWidth - w;
			nextButton.y = 0;
			nextButton.setActualSize(w, h2);
			
			prevButton.x = unscaledWidth - w;
			prevButton.y = unscaledHeight - h;
			prevButton.setActualSize(w, h);
			var inputBoxHeight:Number = inputBox.getExplicitOrMeasuredHeight();
			var inputBoxWidth:Number = inputBox.getExplicitOrMeasuredWidth();
			
			inputBox.setActualSize(unscaledWidth - w, unscaledHeight);
			
			trace(unscaledWidth - w + "    " + unscaledHeight);
			//          inputBox.setActualSize(inputBoxWidth,inputBoxHeight);    
		}
		
		/**
		 *  @private
		 */
		private function inputField_focusInHandler(event:FocusEvent):void
		{
			if (this.listData) {
				this.Caption = this.listData.label;
			}
			inputField=event.currentTarget as TextInput;
			if(event.currentTarget as TextInput == hoursInputField){
				this.value=parseInt(inputField.text);
				this.minimum=0;
				this.maximum=23;
			}else{
				this.value=parseInt(inputField.text);
				this.minimum=0;
				this.maximum=59;
			}
			
			focusInHandler(event);
			
			// Send out a new FocusEvent because the TextInput eats the event
			// Make sure that it does not bubble.
			dispatchEvent(new FocusEvent(event.type, false, false,
				event.relatedObject,
				event.shiftKey, event.keyCode));
		}
		
		/**
		 *  @private
		 */
		private function inputField_focusOutHandler(event:FocusEvent):void
		{
			if (this.listData) {
				this.listData.label = this.Caption;
			}
			focusOutHandler(event);
			
			// Send out a new FocusEvent because the TextInput eats the event
			// Make sure that it does not bubble
			dispatchEvent(new FocusEvent(event.type, false, false,
				event.relatedObject,
				event.shiftKey,event.keyCode));
		}
		
		private function onTextChange(event:Event):void
		{
			var inputTarget:TextInput = event.currentTarget as TextInput;
			inputField = inputTarget;
			if(inputTarget == hoursInputField){
				this.value=parseInt(inputField.text);
				this.minimum=0;
				this.maximum=23;
			}else{
				this.value=parseInt(inputField.text);
				this.minimum=0;
				this.maximum=59;
			}
			value = Number(inputTarget.text);
		}
		/**
		 * @private
		 * 
		 * do for format number to string
		 */
		private function valueCommandHandler(event:FlexEvent):void{
			//var v=this.value;
			inputField.text=formatNumberWithChar(value,2,"0");
			if(inputField==hoursInputField){
				this.hours=value;
			}
			else if(inputField==minutesInputField){
				this.minutes=value;
			}
			else if(inputField==secondsInputField){
				this.seconds=value;
			}
			this.Caption=formatNumberWithChar(this.hours,2,"0")
				+":"+formatNumberWithChar(this.minutes,2,"0")
				+":"+formatNumberWithChar(this.seconds,2,"0");
			
		}
		
		/**
		 *  @private
		 *  Remove the focus from the text field.
		 */
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			
			var fm:IFocusManager = focusManager;
			if (fm)
				fm.defaultButtonEnabled = false;
		}
		
		/**
		 * 时间转换字符串 
		 */
		public static function formatNumberWithChar(value:Number,length:int=2,pref:String="0"):String
		{
			var str:String = new String(value);
			var len:int = str.length;
			
			if(len > length)
			{
				return str.substr(0,length);
			}
			else
			{
				var n:int = length - len;
				for( var i:int = 0 ; i < n ; i++ ) 
				{
					str = pref + str;
				}
				return str;
			}
		}
		
		[Bindable]
		/**
		 * The hours (an integer from 0 to 23) of the day.  
		 * 
		 * @default 0
		 */        
		public function get hours():Number
		{
			return _hours;
		}
		
		[Inspectable(defaultValue=0,category="Time",name="Hours")]
		public function set hours(val:Number):void
		{
			if (val >= 0 || val <= 24)
			{
				this._hours = val;
				if(inputField){
					if(inputField==hoursInputField && val!=value)
						value=val;
					else{
						hoursInputField.text=formatNumberWithChar(val,2,"0");
					}
				}
			}        
			
			dispatchEvent(new Event("hoursChange"));
			dispatchEvent(new Event("change"));
		}
		
		[Bindable]
		/**
		 * The minutes (an integer from 0 to 59) passed in the hours.
		 * 
		 * @default 30
		 */        
		public function get minutes():Number
		{
			return _minutes;
		}
		
		[Inspectable(defaultValue=30,category="Time",name="Minutes")]
		public function set minutes(val:Number):void
		{
			if (val >= 0 || val <= 59)
			{
				this._minutes = val;
				if(inputField){
					if(inputField==minutesInputField && val!=value)
						value=val;
					else{
						minutesInputField.text=formatNumberWithChar(val,2,"0");
					}
				}
			}
			
			dispatchEvent(new Event("minutesChange"));
			dispatchEvent(new Event("change"));
		}
		
		[Bindable]
		/**
		 * The seconds (an integer from 0 to 59) passed in the hours.
		 * 
		 * @default 30
		 */        
		public function get seconds():Number
		{
			return _seconds;
		}
		
		[Inspectable(defaultValue=30,category="Time",name="Seconds")]
		public function set seconds(val:Number):void
		{
			if (val >= 0 || val <= 59)
			{
				this._seconds = val;
				if(inputField){
					if(inputField==secondsInputField && val!=value)
						value=val;
					else{
						secondsInputField.text=formatNumberWithChar(val,2,"0");
					}
				}
			}
			
			dispatchEvent(new Event("secondsChange"));
			dispatchEvent(new Event("change"));
		}
		
		public function get Time():Date{
			var d:Date=new Date();
			d.hours=_hours;
			d.minutes=_minutes;
			d.seconds=_seconds;
			return d;
		}
		public function set Time(time:Date):void{
			this._time=time;
			this.hours=time.hours;
			this.minutes=time.minutes;
			this.seconds=time.seconds;
		}
		
		[Bindable]
		public function get Caption():String{
			return _text;
		}
		[Inspectable(defaultValue="00:00:00",category="Caption",name="Caption")]
		public function set Caption(timestr:String):void{
			this._text=timestr;
			this.hours=Number(timestr.substring(0,2));
			this.minutes=Number(timestr.substring(3,5));
			this.seconds=Number(timestr.substring(6,8));
		}
		
		/**
		 *  @private
		 */
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(hoursInputField){
				hoursInputField.enabled=value;
				minutesInputField.enabled=value;      
				secondsInputField.enabled=value;      
				sText.enabled=value;
				sText2.enabled=value;
				nextButton.enabled=value;
				prevButton.enabled=value;
			}
			
		}
		/**
		 * 
		 */
		override public function get enabled():Boolean
		{
			return _enabled;
		}
		
	}
}