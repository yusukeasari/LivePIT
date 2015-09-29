package jp.pitcom{
	import jp.pitcom.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
    import flash.events.TimerEvent;

	public class SuperView extends MovieClip{
		public var mc:MovieClip;
		public var vObj:Timer;
		public var twdmy:MovieClip=new MovieClip();
		
		function SuperView(){
			
		}
		function removeChildAll(_mc:MovieClip):void {
			var num:uint = _mc.numChildren;
			
			for(var i:uint=0;i< num;i++){
				var child:* = _mc.getChildAt(0);				
				if(child!=null){
					_mc.removeChild(child);
				}
			}
		}
		function disChildAll(_mc:MovieClip):void {
			var num:uint = _mc.numChildren;
			
			for(var i:uint=0;i< num;i++){
				var child:* = _mc.getChildAt(i);				
				if(child!=null){
					_mc.visible = false;
				}
			}
		}
		function returnChildAll(_mc:MovieClip):Array {
			var num:uint = _mc.numChildren;
			
			var arr:Array=new Array();
			
			for(var i:uint=0;i< num;i++){
				var child:* = _mc.getChildAt(0);				
				if(child!=null){
					arr.push(child);
				}
			}
			return arr;
		}
		
		function deleteChildFromArray(_mc):void {
			
			var num:uint = _mc.numChildren/2-1;
			
			for(var i:uint=0;i< num;i++){
				var child:* = _mc.getChildAt(i);				
						if(child!=null){
							_mc.removeChild(child);
						}
			}
		}
		
	}
}