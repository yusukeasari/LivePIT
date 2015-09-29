package jp.pitcom{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.net.*;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	import jp.pitcom.*;
	import caurina.transitions.Tweener;
	import flash.utils.ByteArray;
	import flash.utils.escapeMultiByte;

	//import jp.pitcom.asari.util.StageUtil;
	//import jp.pitcom.asari.util.Dumper;
	
	public class MiniTimeline extends ViewBClass{
		public static const EVENT_1:String = "loadComp";
		private var model:Object;
		private var ILoader1:Loader;
		private var LoadCompMn:Number=0;
		private var info:LoaderInfo;
		
		private var maxTLNum:Number;
		private var TLData:Array;
		private var aTimer:MovieClip=new MovieClip();
		
		private var actionFlag:Boolean=false;;
		
		private var TLList:Array = new Array();
		
		private var tweenDelayObjR:MovieClip=new MovieClip();
		
		function MiniTimeline(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			model = _model;
			
			//model.setEvent(this,EVENT_1);
			model.addEventListener("loadCompM",xmlLInfoComplete);
			model.addEventListener("newDataSetOKM",xmlLInfoComplete);
			model.addEventListener("miniTimelineAddM",zoomInM);
			model.addEventListener("miniActionEndM",actionEndM);
			
			//model.dumper(model.commentDbArraySet);
		}
		
		private function xmlLInfoComplete(event:Event) {
			var tlmax = model.twitNum+model.miniTwitNum;
			var ii=0;
			for each(var element:Object in model.commentDbArraySet){
				var temp3:Object = new Object();
				
				//var total=model.twitNum;
				//var defPos=total-ii;
				if(ii>3){
				var newChild = new MiniTimelineChild(mc,element,model,ii-4);
				TLList.push(newChild);
				}
				if(ii>=tlmax) break;
				ii++;
			}
			trace("MINITIMELINE"+TLList);

		}
		
		

		private function zoomInM(eventObj:CEvent):void{
			var element = eventObj.args;
			
				//var newObject = twitterData2.shift();
				//model.dumper(mc);
				var newChild = new MiniTimelineChild(mc,element,model,0);
				TLList.unshift(newChild);
				
				action();
		}
		private function action():void{
			if(!actionFlag){
				for each(var item in TLList){
					actionFlag=true;
					item.moveOut();
				}
			}else{
				Tweener.addTween(aTimer,{time:1,onComplete:action});
			}
			/*
			if(!actionFlag){
				if(TLList.length > 0){
					for each(var item in TLList){
						actionFlag=true;
						item.moveOut();
					}
				}
				if(TLList.length > 7){
					var delData = TLList.pop();
					delData.remove();
				}
			}else{
				Tweener.addTween(aTimer,{time:1,onComplete:action});
			}*/
		}
		private function actionEndM(eventObj:CEvent){
			if((TLList.length-1) > 7){
				trace("ACTIONENDM!!!");
				var delData = TLList.pop();
				delData.remove();
			}
			actionFlag=false;
		}
		
		private function xmlLInfoOpen(event:Event){
		}
		private function xmlInfoProgress(event:Event){
			
		}
		private function xmlLInfoInit(event:Event){
		}
		private function xmlLInfoIOError(event:Event){
			trace("ERROR:"+event);
		}
		function strReplace(_str:String,_sa:String,_sb:String):String {
			var str:Array = _str.split(_sa);
			return str.join(_sb);
		}
		private function strParse(_str:String):String{
			_str = strReplace(_str,"&apos;", "'");
			_str = strReplace(_str,"&quot;", "\"");
			_str = strReplace(_str,"&amp;", "&");
			_str = strReplace(_str,"&gt;", ">");
			_str = strReplace(_str,"&lt;", "<");
			
			return _str;
		}
		
		private function clone(source:Object):*{
		
		 var myBa:ByteArray = new ByteArray();
		 myBa.writeObject(source);
		 myBa.position = 0;
		 return(myBa.readObject());
		}
	}
}
