package jp.pitcom{
	import jp.pitcom.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.net.*;
	import flash.display.*;
	import flash.display.Bitmap;

	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import com.adobe.serialization.json.JSON;
	
	public class ReLoadViewBClass extends SuperModel{
		private var stage:Stage;
		private var root:Object;
		private var lobj:MovieClip;
		private var model:Object;
		private var frontImageLoader:Loader;
		private var rearImageLoader:Loader;
		
		private var nowB:Number;
		private var totalB:Number;
		private var args:Object;
		public static const EVENT_1:String = "loadComp";
		public static const EVENT_2:String = "entImgOut";
		public var defX:Number;
		public var defY:Number;
		public var defXr:Number;
		public var defYr:Number;
		private var csvData:Array;
		private var csvData2:Array;
		private var allCoordData:Array;
		private var numCoordData:Array;
		private var noNmData:Object;
		private var noNmData2:Object;
		private var isOnline:Boolean;
		private var lNum:int=2;
		private var lNumNow:int=0;
		
		private var jsonLoader:URLLoader;
		private var coordLoader:URLLoader;
		
		private var frontImageLoaderInfo:LoaderInfo;
		private var rearImageLoaderInfo:LoaderInfo;

		
		private var completeLogo:ViewBClass;
		
		function ReLoadViewBClass(_root:Object,_stage:Stage,_lobj:MovieClip,_model:Object,_args:Object){
			super();
			lobj = _lobj;
			//completeLogo = new ViewBClass(lobj.logo,{});
			model = _model;
			stage = _stage;
			root = _root;
			args = _args;
			
			model.setEvent(this,"completeUpdateData");
			model.addEventListener("checkUpdateDataM",checkUpdateDataM);
			
			model.setEvent(this,"coordDataReLoaded");
			model.addEventListener("coordDataReLoadedM",frontImageDataLoad);
			
			model.setEvent(this,"frontImageDataReLoaded");
			model.addEventListener("frontImageDataReLoadedM",rearImageDataLoad);
			
			model.setEvent(this,"rearImageDataReLoaded");
			model.addEventListener("rearImageDataReLoadedM",loadComplete);
		}
		
		private function setupReload(){
			
		}
		
		private function loadAniComplete():void {
			dispatchEvent(new CEvent(EVENT_1,args));

			//dispatchEvent(new CEvent("bgInComp",args));
		}
		
		private function checkUpdateDataM(e:Event):void {
			//座標情報JSONを読み込み
			
			var path = 'pitadmin/updatedb.json';
			//var path =model.srcData("coordData2") + "?id=0101527";
			if(model.srcData("isOnline")){
				path = model.srcData("coordData2") + "?id="+model.latestId;
				path = path + "&="+Math.floor(Math.random()*10000);
			}
			trace("JSON_PATH:"+path);
			var jsonUrl = new URLRequest(path);
			coordLoader = new URLLoader(jsonUrl);
			coordLoader.load(jsonUrl);
			
			//イベント設定
			coordLoader.addEventListener(IOErrorEvent.IO_ERROR , imageLInfoIOError);
			coordLoader.addEventListener(Event.COMPLETE, coordDataSetup);
		}
		
		private function coordDataSetup(e:Event):void {
			//trace("JSON_DATA::"+coordLoader.data);
			coordLoader.removeEventListener(Event.COMPLETE, coordDataSetup);
			var ud = {};
			
			if(coordLoader.data != null){
				var obj:Object = com.adobe.serialization.json.JSON.decode(coordLoader.data);
				//trace("JSON_DATA:1"+obj);
				if(obj != null && obj != ""){
					allCoordData = new Array();
					numCoordData = new Array();
					
					for each(var element:Object in obj){
						allCoordData.push(element);
						
						if(element.num != "" && element.flg == "1"){
							model.commentDbArraySet.push(element);
							model.commentDbArraySet2.push(element);
							numCoordData.push(element);
						}
					}
					model.latestId = numCoordData[0].id;

					dispatchEvent(new CEvent("coordDataReLoaded",args));
				}else{
					
					ud = {num:0};
					dispatchEvent(new CEvent("completeUpdateData",ud));
				}
			}else{
				ud = {num:0};
				dispatchEvent(new CEvent("completeUpdateData",ud));
			}
		}
		
		private function frontImageDataLoad(e:Event):void {
			frontImageLoader = new Loader();
			
			frontImageLoaderInfo = frontImageLoader.contentLoaderInfo;
			
			frontImageLoaderInfo.addEventListener(Event.OPEN,imageLInfoOpen);		
			frontImageLoaderInfo.addEventListener (ProgressEvent.PROGRESS,imageLInfoProgress);
			frontImageLoaderInfo.addEventListener (Event.INIT,imageLInfoInit);
			frontImageLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR,imageLInfoIOError);
			frontImageLoaderInfo.addEventListener (Event.COMPLETE,frontImageDataLoaded);
			
			var path =model.srcData("pmImage2");
			
			var url : URLRequest = new URLRequest(path);
			
			var nowDate:Date = new Date();
/////cache
			if(model.srcData("isOnline")){
				path = path + "?="+Math.floor(Math.random()*10000);
			}
			
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			var ureq:URLRequest = new URLRequest(path);
			ureq.requestHeaders.push(header);
			
			frontImageLoader.load(ureq);
		}
		
		private function frontImageDataLoaded(e:Event):void {
			lNumNow++;
			
			model.frontImageSub = Bitmap(frontImageLoader.content);
			model.frontImage = Bitmap(frontImageLoader.content);
			
			dispatchEvent(new CEvent("frontImageDataReLoaded",args));
		}
		
		private function rearImageDataLoad(e:Event):void {
			rearImageLoader = new Loader();
			rearImageLoaderInfo = rearImageLoader.contentLoaderInfo;

			frontImageLoaderInfo.removeEventListener(Event.OPEN,imageLInfoOpen);		
			frontImageLoaderInfo.removeEventListener (ProgressEvent.PROGRESS,imageLInfoProgress);
			frontImageLoaderInfo.removeEventListener (Event.INIT,imageLInfoInit);
			frontImageLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR,imageLInfoIOError);
			frontImageLoaderInfo.removeEventListener (Event.COMPLETE,frontImageDataLoaded);

			rearImageLoaderInfo.addEventListener(Event.OPEN,imageLInfoOpen);		
			rearImageLoaderInfo.addEventListener (ProgressEvent.PROGRESS,imageLInfoProgress);
			rearImageLoaderInfo.addEventListener (Event.INIT,imageLInfoInit);
			rearImageLoaderInfo.addEventListener (Event.COMPLETE,rearImageDataLoaded);
			rearImageLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			var path = model.srcData("orgImage2");
			
			var url : URLRequest = new URLRequest(args.bPath+Math.floor(Math.random()*1000));
/////cache
			if(model.srcData("isOnline")){
				path = path + "?="+Math.floor(Math.random()*10000);
			}
			
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			var ureq:URLRequest = new URLRequest(path);
			ureq.requestHeaders.push(header);
			
			rearImageLoader.load(ureq);
		}
		
		private function rearImageDataLoaded(e:Event):void {
			lNumNow++;
			
			rearImageLoaderInfo.removeEventListener(Event.OPEN,imageLInfoOpen);		
			rearImageLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			rearImageLoaderInfo.removeEventListener(Event.INIT,imageLInfoInit);
			rearImageLoaderInfo.removeEventListener(Event.COMPLETE,rearImageDataLoaded);
			rearImageLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			model.rearImageSub = Bitmap(rearImageLoader.content);
			model.rearImage = Bitmap(rearImageLoader.content);
			
			dispatchEvent(new CEvent("rearImageDataReLoaded",args));
		}
		
		private function loadComplete(e:Event):void {
			var ud = {};
			trace("allCoordData.length:"+allCoordData.length);
			ud = {num:numCoordData.length,nmSet:numCoordData};
			
			dispatchEvent(new CEvent("completeUpdateData",ud));
			//dispatchEvent(new CEvent(EVENT_1,args));
			//Tweener.removeTweens(lobj);
			//Tweener.addTween(lobj,{alpha:0,transition:"easeInOutQuart",time:2,delay:0});
			//dispatchEvent(new CEvent("bgInComp",args));
		}

		public function bgInCompM(eventObj:CEvent):void{
			root.gotoAndPlay('top');
		}
		public function resizeWinM(eventObj:CEvent):void{
			lobj.x = model.mstageW/defXr;
			lobj.y = model.mstageH/defYr;
		}
		function lInfoProgress(event:ProgressEvent){
			lobj.txt.text = "Image Loading..."+Math.floor(event.bytesLoaded/event.bytesTotal*100)+'%';
			//lobj.bar.scaleX = ((1/lNum)*lNumNow)+event.bytesLoaded/event.bytesTotal/lNum;
		}

		function imageLInfoOpen(event:Event){

		}
		function imageLInfoProgress(event:ProgressEvent){
			lobj.txt.text = "Now Loading..."+Math.floor(event.bytesLoaded/event.bytesTotal*100)+'%';
			//lobj.bar.scaleX = ((1/lNum)*lNumNow)+event.bytesLoaded/event.bytesTotal/lNum;
		}
		function imageLInfoInit(event:Event){
			
		}
		function imageLInfoIOError(event:IOErrorEvent) {
			trace("ERROR!!!!"+event.text);
			///*
			if(event.text.match(/motif_ori/)){
				dispatchEvent(new CEvent("frontImageDataReLoaded",args));
			}else if(event.text.match(/motif\.jpg/)){
				dispatchEvent(new CEvent("coordDataReLoaded",args));
			}else{
				trace("ERROR!!!!"+event.text);
				var ud = {};
				ud = {num:0};
				dispatchEvent(new CEvent("completeUpdateData",ud));
			}
			//*/
		}

		function dataLoadProgressX(event:ProgressEvent) {
			lobj.txt.text = "Text Loading..."+Math.floor(event.bytesLoaded/event.bytesTotal*100)+'%';
			//lobj.bar.scaleX = ((1/lNum)*lNumNow)+event.bytesLoaded/event.bytesTotal/lNum;
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
		public function chkNo(_no:int):String{
			return csvData[_no];
		}
	}
}