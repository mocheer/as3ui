package test
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.DataGrid;


	public class ExcelHelper
	{
		private static var sheet:Sheet = new Sheet();
		
		public static function exportExcelByDataGrid(dataGrid:DataGrid,name:String):void
		{
			var dataArray:Array = dataGrid.dataProvider as Array;
			exportExcelByArray(dataArray,name);
		}
		public static function exportExcelByArray(dataArray:Array,name:String):void
		{
			var excelFile:ExcelFile=new ExcelFile();
			for(var i:int=0; i<dataArray.length; i++)
			{
				var obj:Object=dataArray[i];
				var j:int=0;
				for(var key:String in obj)
				{
					excelFile.sheets.addItem(generateSheet(0,j,key));	
					excelFile.sheets.addItem(generateSheet(i,j,obj[key]));
					j++;
				}
			}       
			var mbytes:ByteArray = excelFile.saveToByteArray();
			var file:FileReference = new FileReference();
			file.save(mbytes,name+".xls"); 
			
			function generateSheet(i:int,j:int,o:Object):Sheet
			{
				if(!sheet){    
					sheet = new Sheet();    
					sheet.resize(10,10);    
				}    
				sheet.setCell(i, j, String(o));    
				return sheet;    
			}    
		}
		
	}
}

