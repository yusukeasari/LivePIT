/************************************************************
　Class SuperView 2010 Fossette EichiKawano
 ************************************************************/
package ws.fossette.PIT{
	import ws.fossette.PIT.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.geom.Point;

	
	//import mx.events.EventDispatcher;
	public class SuperView extends MovieClip{
		public var mc:MovieClip;
		public var iid:Timer;
		public var twdmy:MovieClip=new MovieClip();
//		var addEventListener:Function;
//		var removeEventListener:Function;
//		private var dispatchEvent:Function;
		
		function SuperView(){
			//EventDispatcher.initialize(this);		
		}
		function getAncXY(_xx:Number,_yy:Number,_tx:Number,_ty:Number,_rad:Number):Point{
			var mcP1:Point = new Point(_xx,_yy);
			var mcP2:Point = new Point(_tx,_ty);
			var disP:Number = Point.distance(mcP1,mcP2);
			var interpolatedPoint:Point = Point.interpolate(mcP1,mcP2,.5);
			
			disP = disP/3;//*Math.random();
			
			var rad:Number;

			rad= _rad * Math.PI/180;
   			
			var nXY:Point = Point.polar(disP,rad);
			nXY.offset(interpolatedPoint.x,interpolatedPoint.y);
			
			return nXY;
		}
		function removeChildAll(_mc:MovieClip):void {
			var num:uint = _mc.numChildren;
			trace('child'+num);
			
			for(var i:uint=0;i< num;i++){
				var child:* = _mc.getChildAt(0);				
				//if (child is MovieClip) {
					if(child!=null){
						_mc.removeChild(child);
					}
					trace("del",i);
				//}
			}
		}
		function disChildAll(_mc:MovieClip):void {
			var num:uint = _mc.numChildren;
			trace('child'+num);
			
			for(var i:uint=0;i< num;i++){
				var child:* = _mc.getChildAt(i);				
				//if (child is MovieClip) {
					if(child!=null){
						_mc.visible = false;
					}
					trace("dis",i);
				//}
			}
		}
	}
}