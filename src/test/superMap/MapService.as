package test.superMap
{
	import com.supermap.web.core.Point2D;
	import com.supermap.web.events.MapEvent;
	import com.supermap.web.mapping.FeaturesLayer;
	import com.supermap.web.mapping.Map;
	import com.supermap.web.utils.GeoUtil;
	

	public class MapService
	{
		public var map:Map;
		private var TDTLayer1:TiledTDTLayer
		private var TDTLayer2:TiledTDTLayer
		public var fl:FeaturesLayer=new FeaturesLayer();
		public function MapService()
		{
			map=new Map();
			map.percentHeight=100;
			map.percentWidth=100;
			
		}
		private function mapInit():void{
			
		}
		public function getTDTMap():Map
		{
			TDTLayer1=new TiledTDTLayer();
			TDTLayer2=new TiledTDTLayer();
			TDTLayer1.projection="900913";
			TDTLayer1.layerType="vec";	
			TDTLayer2.isLabel=true;
			TDTLayer2.projection="900913"
			TDTLayer2.layerType="vec";
			map.addLayer(TDTLayer1);
			map.addLayer(TDTLayer2);
			map.addEventListener(MapEvent.LOAD,TDTMapLoadEvent);
			return map;
		}
		public function getTDTMap2():Map
		{
			map.addLayer(TDTLayer1);
			map.addLayer(TDTLayer2);
			return map;
		}
		private function TDTMapLoadEvent(event:MapEvent):void
		{
			var pos:Point2D = GeoUtil.lonLatToMercator(119.28,26.08);	
			map.zoomToLevel(5,pos);
		}
		
		
		public function getBaiduMap():Map
		{
			
			var BaiduLayer:BaiduMapLayer=new BaiduMapLayer();
			map.addLayer(BaiduLayer);
			map.resolutions = BaiduLayer.resolutions;
			map.addEventListener(MapEvent.LOAD,BaiduMapLoadEvent);
			return map;
		}
	
		private function BaiduMapLoadEvent(event:MapEvent):void
		{
			//设置最大分辨率！，由于更大的两级百度没有图片
			map.maxResolution = 32768;
//			map.zoomToLevel(3,new Point2D(119.28,26.08));
			var pos:Point2D = GeoUtil.lonLatToMercator(119.28,26.08);	
			map.zoomToLevel(5,pos);
		}
		
		public function getGoogleMap():Map
		{
			var GoogleLayer:GoogleMapLayer=new GoogleMapLayer();
			GoogleLayer.mapType="map";
			map.addLayer(GoogleLayer);
			map.addEventListener(MapEvent.LOAD,GoogleMapLoadEvent);
			return map;
		}
		
		private function GoogleMapLoadEvent(event:MapEvent):void
		{
			var pos:Point2D = GeoUtil.lonLatToMercator(119.28,26.08);	
			map.zoomToLevel(5,pos);
		}
		
	}
}