package jp.pitcom{
	import jp.pitcom.*;
	import flash.events.Event;

	public class CEvent extends Event{
		public var args:Object;

		function CEvent(type:String,args:Object=null){
			if(type!="checkUpdateDataM" && type!="completeUpdateDataM" && type!="checkUpdateData" && type!="completeUpdateData" && type!="onTimelineLoaded" && type!="onTimelineLoadedM" && type!="pitOn2" && type!="imageMMove" && type!="imageMMoveM")trace("CEVENT:"+type);
			
			super(type);
			this.args = args;
		}
		public override function clone():Event{
			return new CEvent(type,args);
		}
		public override function toString():String{
			return formatToString("CEvent","type","args");
		}
	}
}