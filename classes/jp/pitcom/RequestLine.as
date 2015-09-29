package jp.pitcom{
	import jp.pitcom.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.net.*;
	import flash.display.*;

	import com.adobe.serialization.json.JSON;
	
	public class RequestLine extends SuperModel{
		private var stage:Stage;
		private var root:Object;
		private var model:Object;
		private var lobj:MovieClip;
		
		private var args:Object;

		private var allCoordData:Array;
		private var numCoordData:Array;
		private var isOnline:Boolean;

		private var coordLoader:URLLoader;

		private var fRequestLine;
		
		function RequestLine(_root:Object,_stage:Stage,_lobj:MovieClip,_model:Object,_args:Object){
			super();
			lobj = _lobj;
			model = _model;
			stage = _stage;
			root = _root;
			args = _args;
			
			model.setEvent(this,"completeUpdateRequestData");
			model.addEventListener("checkRequestLineM",checkUpdateDataM);
			
			model.setEvent(this,"RequestLineLoaded");
		}
		
		private function checkUpdateDataM(e:CEvent):void {
			//座標情報JSONを読み込み
			fRequestLine = e.args.fRequestLine;
			trace("fRequestLine/"+e.args.fRequestLine);
			var path =model.srcData("coordData3");
			if(model.srcData("isOnline")){
				path = path + "?="+Math.floor(Math.random()*10000);
			}
			trace("JSONPATH2:"+path);
			var jsonUrl = new URLRequest(path);
			coordLoader = new URLLoader(jsonUrl);
			coordLoader.load(jsonUrl);
			
			//イベント設定
			coordLoader.addEventListener(Event.COMPLETE, coordDataSetup);
			coordLoader.addEventListener(IOErrorEvent.IO_ERROR , defaultErrorHandler);
			coordLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR , defaultErrorHandler);
		}

		private function defaultErrorHandler(error:*){
			//ERROR
			trace("LINE ERROR:"+error.type);
			dispatchEvent(new CEvent("RequestLineLoaded",args));
		}
		
		private function coordDataSetup(e:Event):void {
			coordLoader.removeEventListener(Event.COMPLETE, coordDataSetup);
			coordLoader.removeEventListener(IOErrorEvent.IO_ERROR , defaultErrorHandler);
			coordLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , defaultErrorHandler);
			
			if(coordLoader.data != null && model.newRequestLineData.length < 1){
				var obj:Object = com.adobe.serialization.json.JSON.decode(coordLoader.data);

				if(obj != null && obj != ""){
					if(fRequestLine) model.allRequestLineData = obj;
					var nRequestLineNum = obj.length - model.allRequestLineData.length;
					model.newRequestLineData = new Array();
					trace("fRequestLine:"+fRequestLine+"/allRequestLineData:"+model.allRequestLineData.length+"/obj:"+obj.length+"/nRequestLineNum:"+nRequestLineNum);
					for(var i = model.allRequestLineData.length;i<obj.length;i++){
						model.dumper(obj[i]);
						if(obj[i] != null){
							var n = model.commentDbArraySetFromID(obj[i].id);
							trace("ID:"+obj[i].id + "N:"+n);
							if(!n) break;
							if(!fRequestLine) model.newRequestLineData.push(n);
						}else{
							model.dumper(obj[i])
						}
					}
					//if(model.newLineData.length != 0) model.allLineData.push(model.newLineData);
				}
			}
			dispatchEvent(new CEvent("RequestLineLoaded",args));
		}
		
		private function loadComplete(e:Event):void {
			var ud = {};
			trace("allCoordData.length:"+allCoordData.length);
			ud = {num:numCoordData.length,nmSet:numCoordData};
			
			dispatchEvent(new CEvent("completeUpdateRequestData",ud));
		}
	}
}