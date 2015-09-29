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
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.text.Font;

	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import com.adobe.serialization.json.JSON;
	
	public class LoadViewBClass extends SuperModel{
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
		private var dbg:Boolean;
		private var lNum:int=2;
		private var lNumNow:int=0;
		
		private var jsonLoader:URLLoader;
		private var coordLoader:URLLoader;
		
		private var completeLogo:ViewBClass;
		
		function LoadViewBClass(_root:Object,_stage:Stage,_lobj:MovieClip,_model:Object,_args:Object){
			super();
			lobj = _lobj;
			//completeLogo = new ViewBClass(lobj.logo,{});
			model = _model;
			stage = _stage;
			root = _root;
			args = _args;
			
			isOnline = false;
			dbg = false;
			
			frontImageLoader = new Loader();
			rearImageLoader = new Loader();
			
			//lobj.bar.scaleX=0;
			lobj.alpha = 0;
			
			var info:LoaderInfo = root.loaderInfo;
			
			info.addEventListener(ProgressEvent.PROGRESS,lInfoProgress);
			info.addEventListener(Event.COMPLETE,initDataLoad);
			
			//coordDataLoad 座標データの読み込み
			//imageDataLoad 画像データ読み込み開始
			
			
			model.setEvent(this,"bgInComp");
			model.addEventListener("bgInCompM",bgInCompM);
			
			model.setEvent(this,"initDataLoaded");
			model.addEventListener("initDataLoadedM",coordDataLoad);
			//model.addEventListener("initDataLoadedM",fontLoad);
			
			//model.setEvent(this,"fontLoaded");
			//model.addEventListener("fontLoadedM",coordDataLoad);
			
			model.setEvent(this,"coordDataLoaded");
			model.addEventListener("coordDataLoadedM",frontImageDataLoad);
			
			model.setEvent(this,"frontImageDataLoaded");
			model.addEventListener("frontImageDataLoadedM",rearImageDataLoad);
			
			model.setEvent(this,"rearImageDataLoaded");
			model.addEventListener("rearImageDataLoadedM",loadComplete);
						
			model.setEvent(this,EVENT_1);
			model.setEvent(this,EVENT_2);
			
			Tweener.removeTweens(lobj);
			Tweener.addTween(lobj,{alpha:1,transition:"easeInOutQuart",time:1,delay:0});
		}

		private function initDataLoad(e:Event):void {
			//設定JSONを読み込み
			trace(args.setupJson);
			var path = args.setupJson;
			if(dbg){
				path = path + "?="+Math.floor(Math.random()*10000);
			}
			var jsonUrl = new URLRequest(path);
			jsonLoader = new URLLoader(jsonUrl);
			jsonLoader.load(jsonUrl);


			
			//イベント設定
			jsonLoader.addEventListener(Event.COMPLETE, initDataSetup);
		}
		private function initDataSetup(e:Event) {
			//JSONデータをデコード
			var obj:Object = com.adobe.serialization.json.JSON.decode(jsonLoader.data);
			model.srcSetup = obj;
			
			dispatchEvent(new CEvent("initDataLoaded",args));
		}
		
		
		private function fontLoad(e:Event):void {
			//var req :URLRequest = new URLRequest("HiraginoKakugo7.swf");
			//var loader:Loader = new Loader();
			//var context :LoaderContext = new LoaderContext();
			//context.applicationDomain = ApplicationDomain.currentDomain;
			//loader.contentLoaderInfo.addEventListener( Event.COMPLETE, fontSetup );
			//loader.load( req, context );
		}
		private function fontSetup(e:Event) {
			e.target.removeEventListener( Event.COMPLETE, fontSetup );
			
			var FontLibrary:Class = ApplicationDomain.currentDomain.getDefinition("HiraginoKakugo7") as Class;
		
			Font.registerFont( FontLibrary);
			
			//model.fonts = Font.enumerateFonts(false);
			
			model.fonts = FontLibrary;
			//var allFonts:Array = Font.enumerateFonts(false);
			//trace(allFonts);
			dispatchEvent(new CEvent("fontLoaded",args));
		}
		
		
		private function coordDataLoad(e:Event):void {
			//座標情報JSONを読み込み
			var path =model.srcData("coordData");
			//var path =model.srcData("coordData2") + "?id=0101527";
			if(model.srcData("isOnline")){
				path = path + "?="+Math.floor(Math.random()*10000);
			}
			var jsonUrl = new URLRequest(path);
			coordLoader = new URLLoader(jsonUrl);
			coordLoader.load(jsonUrl);
			
			//イベント設定
			coordLoader.addEventListener(Event.COMPLETE, coordDataSetup);
		}
		
		private function coordDataSetup(e:Event):void {
			var obj:Object = com.adobe.serialization.json.JSON.decode(coordLoader.data);
			trace("JSON:"+coordLoader.data);
			allCoordData = new Array();
			numCoordData = new Array();
			if(obj.length > 0){
			for each(var element:Object in obj){
				trace("ID:"+element.id);
				allCoordData.push(element);
				
				if(element.num != "" && element.flg == "1"){
					numCoordData.push(element);
					//trace(allCoordData[0].num);
					}

				}
			}
			model.commentDbArraySet = numCoordData;
			model.commentDbArraySet2 = numCoordData;
			model.latestId=numCoordData[0].id;
			dispatchEvent(new CEvent("coordDataLoaded",args));
		}
		
		private function frontImageDataLoad(e:Event):void {
			frontImageLoader = new Loader();
			
			var info:LoaderInfo = frontImageLoader.contentLoaderInfo;
			
			info.addEventListener(Event.OPEN,imageLInfoOpen);		
			info.addEventListener (ProgressEvent.PROGRESS,imageLInfoProgress);
			info.addEventListener (Event.INIT,imageLInfoInit);
			info.addEventListener (IOErrorEvent.IO_ERROR,imageLInfoIOError);
			info.addEventListener (Event.COMPLETE,frontImageDataLoaded);
			
			var path =model.srcData("pmImage");
			
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
			
			dispatchEvent(new CEvent("frontImageDataLoaded",args));
		}
		
		private function rearImageDataLoad(e:Event):void {
			rearImageLoader = new Loader();
			
			var info:LoaderInfo = rearImageLoader.contentLoaderInfo;

			info.addEventListener(Event.OPEN,imageLInfoOpen);		
			info.addEventListener (ProgressEvent.PROGRESS,imageLInfoProgress);
			info.addEventListener (Event.INIT,imageLInfoInit);
			info.addEventListener (Event.COMPLETE,rearImageDataLoaded);
			info.addEventListener (IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			var path = model.srcData("orgImage");
			
			var url : URLRequest = new URLRequest(args.bPath+Math.floor(Math.random()*1000));
/////cache
			if(model.srcData("isOnline")){
				path = path + "?="+Math.floor(Math.random()*10000);
			}
			
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			var ureq:URLRequest = new URLRequest(path);
			ureq.requestHeaders.push(header);
			
			rearImageLoader.load(ureq);
			
/////trace("KOKOMADE:"+path);
		}
		
		private function rearImageDataLoaded(e:Event):void {
			lNumNow++;
			
			
			
			dispatchEvent(new CEvent("rearImageDataLoaded",args));
		}
		
		private function loadComplete(e:Event):void {
			Tweener.removeTweens(lobj);
			Tweener.addTween(lobj,{alpha:0,transition:"easeInOutQuart",time:2,delay:0});
			dispatchEvent(new CEvent("bgInComp",args));
		}
		
		function modelRmv():void{
			model.removeEventListener("bgInCompM",bgInCompM);
			model.removeEvent(this,EVENT_1);
			model=null;
		}
		public function bgInCompM(eventObj:CEvent):void{
			trace("COMPLETE");
			var timer:Timer = new Timer(1000 ,1); // 1000ミリ秒 = １秒
			timer.addEventListener(TimerEvent.TIMER, timerFunc);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompFunc);
			timer.start();
		}
		private function timerFunc(eventObj:Event){
			trace("予定する繰り返し回数：");
			trace("現在の繰り返し回数　：");
		}

		
		private function timerCompFunc(eventObj:Event):void{
			model.frontImage = Bitmap(frontImageLoader.content);
			model.rearImage = Bitmap(rearImageLoader.content);
			
			dispatchEvent(new CEvent(EVENT_1,args));
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