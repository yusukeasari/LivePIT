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
import ws.fossette.PIT.*;
	//import jp.pitcom.asari.util.StageUtil;
	//import jp.pitcom.asari.util.Dumper;
	
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class TwitterWidget extends ViewBClass{
		public static const EVENT_1:String = "loadComp";
		private var model:Object;
		private var ILoader1:Loader;
		private var LoadCompMn:Number=0;
		private var info:LoaderInfo;
		
		private var maxTLNum:Number;
		private var TLData:Array;
		private var aTimer:MovieClip=new MovieClip();
		
		private var actionFlag:Boolean=false;
		
		private var TLList:Array = new Array();
		
		private var tweenDelayObjR:MovieClip=new MovieClip();
		
		private var pobj;
		
		
		private var htbitmap:Array;
		private var htbitmapsize:Array;
        private var htlist:Vector.<HeartMcSMT2> = new Vector.<HeartMcSMT2>();


		private var bgbg:BitmapData;
		
		
		function TwitterWidget(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			model = _model;
			model.setEvent(this,"miniTimelineAdd");
			//model.setEvent(this,EVENT_1);
			model.addEventListener("loadCompM",xmlLInfoComplete);
			model.addEventListener("newDataSetOKM",xmlLInfoComplete);
			model.addEventListener("zoomIn2M",zoomInM);
			model.addEventListener("actionEndM",actionEndM);
			//model.dumper(model.commentDbArraySet);
			
		//	pobj = new PatLine5McSMT(args.ptgt,{});
			
			bgbg = new BitmapData(1920,1080,true,0x00000000);
			args.ptgt.addChild(new Bitmap(bgbg));

			htbitmap = new Array();
			htbitmapsize = new Array();
			var ht0:MovieClip = new BgSnow();
			ht0.filters = [new GlowFilter(0xffffff, 0.2, 10, 10, 4, 3 )]
			var rect:Rectangle = ht0.getBounds(this);
			var size:Number = Math.sqrt(rect.right*rect.right+rect.bottom*rect.bottom)+30;
			for (var s:uint=2;s<=15;s++){
				htbitmap[s] = new Vector.<BitmapData>();
				htbitmapsize[s] = new Vector.<Rectangle>();
				var scale:Number = s / 10;
				for (var i:uint=0; i < 360; i++ ) {
					var bmd:BitmapData = new BitmapData(size*2*scale+1,size*2*scale+1,true,0);
					var m:Matrix = new Matrix();
					m.scale(scale,scale);
					m.rotate(i*0.01744444444/*Math.PI/180*/);
					m.tx = size * scale;
					m.ty = size * scale;
					bmd.draw(ht0,m);
					htbitmap[s].push(bmd);
					htbitmapsize[s].push(new Rectangle(0, 0, size*2*scale+1, size*2*scale+1));
				}
			}

			
			var sp = new Sprite();
			args.ptgt.addChild(sp);
			sp.mouseChildren = false;
			sp.mouseEnabled = false;
			args.ptgt.mouseChildren = false;
			args.ptgt.mouseEnabled = false;

			
			for (i=0;i<150;i++){
				
				htlist.push(new HeartMcSMT2(Math.random()*1900,Math.random()*1000,i/*,htbitmap*/));
				//sp.addChild(htlist[i]);
				
				
				//var _rotation = Math.round( 1 % 360 )
				
				//htlist[i]._bmp0= htbitmap[htlist[i].sc][_rotation];
			}			

			addEventListener(Event.ENTER_FRAME,bgsnowmove);
			
		}
		private function xmlLInfoComplete(event:Event) {
			var ii=0;
			for each(var element:Object in model.commentDbArraySet){
				var temp3:Object = new Object();
				
				var newChild = new TwitterWidgetChild(mc,element,model,ii);
				TLList.push(newChild);
				
				if(ii>=model.twitNum) break;
				ii++;
			}

		}


		private function zoomInM(eventObj:CEvent):void{
			var element = eventObj.args;
			
			if(element.rnd != 1){
				//pobj.fadeIN(0);

				//var newObject = twitterData2.shift();
				//model.dumper(mc);
				var newChild = new TwitterWidgetChild(mc,element,model,0);
				TLList.unshift(newChild);
				
				action();
			}
		}
		private function action():void{
			if(!actionFlag){
				
				dispatchEvent(new CEvent("miniTimelineAdd",TLList[TLList.length-1].mine()));
//@@@@2015
				for(var i=0;i<TLList.length;i++){
				//for each(var item in TLList){
					actionFlag=true;
					if(i==(TLList.length-1)){
						TLList[i].moveOut2(i);
					}else{
						TLList[i].moveOut(i);
					}
				}
			}else{
				Tweener.addTween(aTimer,{time:1,onComplete:action});
			}
		}
		private function actionEndM(eventObj:CEvent){
			trace(TLList.length+"-1) > "+model.twitNum);
			if((TLList.length) > model.twitNum){
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
		function bgsnowmove(e:Event):void {
			for (var i:uint=0;i<150;i++){
				bgbg.copyPixels(htbitmap[2][10], htbitmapsize[2][10],new Point(Math.random()*1000,100));
				
				/*htlist[i].x -= htlist[i].vx/(0.02*i+1)+0.3;
				htlist[i].y +=htlist[i].vy/(0.02*i+1)+0.3;
				htlist[i].rot++;
				
				 var rot = Math.round( htlist[i].rot % 360 )
				//htlist[i].bitmapData =  htbitmap[2][_rotation];
				htlist[i]._bmp0= htbitmap[htlist[i].sc][rot];

				if (htlist[i].y>1100||htlist[i].x>1300) {
					htlist[i].x = Math.random()*1200;
					htlist[i].y = -50;
				}*/
			}

		}
	}
}
