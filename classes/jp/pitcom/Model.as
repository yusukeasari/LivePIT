package jp.pitcom{
	import jp.pitcom.*;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.net.*;
	import flash.geom.Point;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.Loader;
	
	public class Model extends SuperModel {
		public static var stage:Stage;
		private var root:Object;
		private var tw:MovieClip;
		private var nxtlb:String;
		private var nowVol:Boolean;
		private var ureq:URLRequest;
		private var nmNo:Array;
		private var nmNo2:Array;
		private var commentDbArray:Array;
		private var commentDbArray2:Array;
		private var nm2Img:Object;


		private var flineData0:Array = new Array();
		private var allLineData0:Array = new Array();
		private var newLineData0:Array = new Array();

		private var fRequestLineData0:Array = new Array();
		private var allRequestLineData0:Array = new Array();
		private var newRequestLineData0:Array = new Array();

		private var frontImageData:Bitmap;
		private var rearImageData:Bitmap;
		
		private var frontImageSubData:Bitmap;
		private var rearImageSubData:Bitmap;
		
		private var commentDbArray3:Array;
		private var noNmData:Object;
		private var noNmData2:Object;
		public static const EVENT_1:String = "resizeWinM";
		public static const EVENT_2:String = "phpResM";
		private var px:int;
		private var py:int;
		private var pw:int;
		private var ph:int;
		private var bimgW:Number;
		private var bimgH:Number;
		private var bimgW2:Number;
		private var bimgH2:Number;
		private var simgW:Number;
		private var simgH:Number;
		private var imgzp:Number;
		private var srcset:MovieClip;
		private var cboxData:uint;
		private var categoryNameList:Array;
		
		private var fonts0;
		
		private var latestId0:String;
		private var twitNum0:Number=8;
		private var miniTwitNum0:Number=8;
		
		private var TLDataSet0:Array = new Array();
		private var newNmCmt0:Array = new Array();
		
		private var srcRsNum:int=0;
		private var srcRsSet:Object;
		
		private var srcSetup0:Object;
		
		private var searchResultCategory:int=0;
		private var searchResultCategorySet:Object;
		
		private var nowKey:String;
		
		private var personalID:String="";
				
		function Model(_stage:Stage,_root:Object){
			super();
			stage = _stage;
			root = _root;
			tw = new MovieClip();
		}
		
		public function get randomItem(){
			var a:int = Math.floor(Math.random()*(commentDbArray.length));
			return commentDbArray[a];
		}
		
		public function set frontImage(data:Bitmap){
			frontImageData=data;
		}
		public function get frontImage():Bitmap{
			return frontImageData;
		}
		
		
		public function set fonts(data){
			fonts0=data;
		}
		public function get fonts(){
			return fonts0;
		}		
		
		
		public function set rearImage(data:Bitmap){
			rearImageData=data;
		}
		public function get rearImage():Bitmap{
			return rearImageData;
		}
		
		public function set latestId(data:String){
			latestId0=data;
		}
		public function get latestId():String{
			return latestId0;
		}
		
		public function set frontImageSub(data:Bitmap){
			frontImageSubData=data;
		}
		public function get frontImageSub():Bitmap{
			return frontImageSubData;
		}
		
		public function set rearImageSub(data:Bitmap){
			rearImageSubData=data;
		}
		public function get rearImageSub():Bitmap{
			return rearImageSubData;
		}

		public function set twitNum(data:Number){
			twitNum0=data;
		}
		public function get twitNum():Number{
			return twitNum0;
		}
		public function set miniTwitNum(data:Number){
			miniTwitNum0=data;
		}
		public function get miniTwitNum():Number{
			return miniTwitNum0;
		}
		
		public function set TLDataSet(data:Array){
			TLDataSet0 = data;
		}
		public function get TLDataSet():Array{
			return TLDataSet0;
		}
		
		public function set personalID0(string:String){
			personalID=string;
		}
		public function get personalID0():String{
			return personalID;
		}
		
		public function get searchResultCategory0():Number{
			return searchResultCategory;
		}
		public function get searchResultCategorySet0():Object{
			return searchResultCategorySet;
		}
		
		public function set srcSetup(obj:Object){
			srcSetup0 = obj;
		}
		public function get srcSetup():Object{
			return srcSetup0;
		}
		
		public function srcData(str:String){
			return srcSetup0[str];
		}
		
		public function get srcRsNum0():Number{
			return srcRsNum;
		}
		public function get srcRsSet0():Object{
			return srcRsSet;
		}		
		public function set srcset0(_mc:MovieClip):void{
			srcset = _mc;
		}
		public function set bimgW0(_nm:Number):void{
			bimgW = _nm;
		}
		public function set bimgH0(_nm:Number):void{
			bimgH = _nm;
		}
		public function set bimgW20(_nm:Number):void{
			bimgW2 = _nm;
		}
		public function set bimgH20(_nm:Number):void{
			bimgH2 = _nm;
		}
		public function set simgW0(_nm:Number):void{
			simgW = _nm;
		}
		public function set simgH0(_nm:Number):void{
			simgH = _nm;
		}
		public function set imgzp0(_nm:Number):void{
			imgzp = _nm;
		}
		public function get imgzp0():Number{
			return imgzp;
		}
		public function get bimgW0():Number{
			return bimgW;
		}
		public function get bimgH0():Number{
			return bimgH;
		}
		public function get bimgW20():Number{
			return bimgW2;
		}
		public function get bimgH20():Number{
			return bimgH2;
		}
		public function get simgW0():Number{
			return simgW;
		}
		public function get simgH0():Number{
			return simgH;
		}
		public function set nmNoSet(_arr:Array):void{
			nmNo = _arr;
		}
		public function get nmNoSet():Array{
			return nmNo;
		}
		public function set nmNoSet2(_arr:Array):void{
			nmNo2 = _arr;
		}
		public function get nmNoSet2():Array{
			return nmNo2;
		}
		public function set commentDbArraySet(_arr:Array):void{
			commentDbArray = _arr;
			
			makeConvertArray();
		}

		public function get commentDbArraySet():Array{
			return commentDbArray;
		}
		
		public function commentDbArraySetFromID(ids):Object{
			ids=String(ids);
			for each(var element:Object in commentDbArray){
				trace("IDS:"+element.id);
				if(ids.length == 6){
					if(ids==element.id){
						return element;
						break;
					}
				}
			}
			return false;
		}
		
		public function commentDbArraySetFromImg(ids):Object{
			ids=String(ids);
			for each(var element:Object in commentDbArray){
				if(ids.length == 6){
					
					if(ids==element.id){
						return element;
						break;
					}
				}else{
					//trace("length:0:"+ids);
					if(Number(ids)+1==element.num){
						return element;
						break;
					}
				}
			}
			
			return false;
		}
		
		//newNmCmt0
		public function set newNmCmt(_arr:Array):void{
			newNmCmt0 = _arr;
		}
		public function get newNmCmt():Array{
			return newNmCmt0;
		}

		public function newLineDataShift(){
			return newLineData0.shift();
		}
		public function newLineDataPop(){
			var d = newLineData0.pop();
			return d;
		}

		public function newRequestLineDataShift(){
			return newRequestLineData0.shift();
		}
		public function newRequestLineDataPop(){
			var d = newRequestLineData0.pop();
			return d;
		}

		public function newNmCmtPop(){
			return newNmCmt0.pop();
		}
		public function get newNmCmtShift(){
			var data0 = newNmCmt0.shift();
			return data0;
		}
		public function newNmCmtConcat(_arr){
			newNmCmt0.concat(_arr);
		}
		public function newNmCmtPush(_arr:Array){
			newNmCmt0.push(_arr);
		}
		public function newNmCmtUnshift(_arr:Array){
			newNmCmt0.unshift(_arr);
		}
		
		public function set flineData(_arr):void {
			flineData0 = _arr;
		}
		public function get flineData():Array{
			return flineData0;
		}
		public function set allLineData(_arr):void {
			allLineData0 = _arr;
		}
		public function get allLineData():Array{
			return allLineData0;
		}
		public function set newLineData(_arr):void {
			newLineData0 = _arr;
		}
		public function get newLineData():Array{
			return newLineData0;
		}

		public function set fRequestLineData(_arr):void {
			fRequestLineData0 = _arr;
		}
		public function get fRequestLineData():Array{
			return fRequestLineData0;
		}
		public function set allRequestLineData(_arr):void {
			allRequestLineData0 = _arr;
		}
		public function get allRequestLineData():Array{
			return allRequestLineData0;
		}
		public function set newRequestLineData(_arr):void {
			newRequestLineData0 = _arr;
		}
		public function get newRequestLineData():Array{
			return newRequestLineData0;
		}

		public function set commentDbArraySet2(_arr:Array):void{
			commentDbArray2 = _arr;
		}
		public function get commentDbArraySet2():Array{
			return commentDbArray2;
		}
		public function set commentDbArraySet3(_arr:Array):void{
			commentDbArray3 = _arr;
		}
		public function get commentDbArraySet3():Array{
			return commentDbArray3;
		}
		public function set noNmDataSet(_obj:Object):void{
			noNmData = _obj;
		}
		public function get noNmDataSet():Object{
			return noNmData;
		}
		public function set noNmDataSet2(_obj:Object):void{
			noNmData2 = _obj;
		}
		public function get noNmDataSet2():Object{
			return noNmData2;
		}
		public function resizeWin(event):void{
			var t:Object = new Object();
			dispatchEvent(new CEvent(EVENT_1,t));
		}
		public function set px0(_x:int):void{
			px = _x;
		}
		public function set py0(_y:int):void{
			py= _y;
		}
		public function set pw0(_w:int):void{
			pw= _w;
		}
		public function set ph0(_h:int):void{
			ph= _h;
		}
		public function get px0():int{
			return px;
		}
		public function get py0():int{
			return py;
		}
		public function get pw0():int{
			return pw;
		}
		public function get ph0():int{
			return ph;
		}
		public function get mstage():Stage{
			return stage;
		}
		public function get mstageW():int{
			return stage.stageWidth;
		}
		public function get mstageH():int{
			return stage.stageHeight;
		}
		public function get mstageCX():int{
			return mstageW/2;
		}
		public function get mstageCY():int{
			return mstageH/2;
		}
		public function set nowVolF(_nowVol:Boolean):void{
			nowVol = _nowVol;
		}
		public function get nowVolF():Boolean{
			return nowVol;
		}
		public function set comboBoxData(d:uint):void {
			cboxData = d;
		}
		public function get comboBoxData():uint {
			return cboxData;
		}
		public function set categoryName(d:Array):void {
			categoryNameList = d;
		}
		public function get categoryName():Array {
			return categoryNameList;
		}
		public function setEvent(_obj:Object,_evt:String){
			_obj.addEventListener(_evt,cEvent);
			
		}
		
		public function removeEvent(_obj:Object,_evt:String){
			_obj.removeEventListener(_evt,cEvent);
		}
		public function cEvent(event:CEvent):void{
			var evt:String = String(event.type)+"M";
			dispatchEvent(new CEvent(evt,event.args));
			
			if(evt!='deltetePatM'){
				
			}
			var vars:Object = new Object();
			var i:int=0;
			switch(evt){
				case 'srcBtnReleseM':
					vars.num=0;
					if(srcset.itxt2.itxt.text!=''){
						for(i=0;i<commentDbArray2.length;i++){
							if(commentDbArray2[i].b1.indexOf(srcset.itxt2.itxt.text)!=-1 && commentDbArray2[i].flg==1){
								vars.num++;
								vars['no_'+vars.num]=Number(commentDbArray2[i].num)-1;
								//trace('ああああああああああああ'+vars['no_'+vars.num]);
							}
						}
					}
					srcRsNum=vars.num;
					srcRsSet=vars;
					
					dispatchEvent(new CEvent(EVENT_2,vars));
					break;
			}
		}
		
		public function DBG_pitsearchOoComplete():void{
			var arr=[0,1614,1609,1258,1183];
		}
		public function logldOoErr(event:Event):void{
			
		}
		public function logldOoComplete(event:Event):void{
			
		}
		public function pitsearchOoComplete(event:Event):void{
			var vars:URLVariables = new URLVariables(event.target.data);

			srcRsNum=vars.num;
			srcRsSet=vars;
			
			dispatchEvent(new CEvent(EVENT_2,vars));
		}
		function nextJump():void{
			root.gotoAndPlay('top');
		}
		function nextJump2():void{
			root.gotoAndPlay(nxtlb);
		}
		function nextJumpCt():void{

		}
		function nextJumpCt2():void{

		}
		
		public function nm2ImgId(nm){
			//trace("nm2ImgId"+nm2Img+":"+nm+":"+nm2Img[nm+1]);
			if(nm2Img[nm+1] != undefined && nm2Img[nm+1] != null && nm2Img[nm+1] != ''){
				return nm2Img[nm+1];				
			}else{
				return nm;
			}
		}
		//public function nm2
		
		private function makeConvertArray():void {
			nm2Img = new Object();
			
			for each(var element:Object in commentDbArray){
				if(element.num != undefined && element.num != null && element.num != ''){
					nm2Img[element.num] = element.id;
				}
			}
			//trace(dumper(nm2Img));
		}
		
		function clearFromSearchForID():void {
			//srcset.itxt2.itxt.text="";
			//srcset.searchCategoryMenu.selectedIndex=0;
		}
		function clearFromSearchForText():void {
			//srcset.itxt3.itxt.text="";
			//srcset.searchCategoryMenu.selectedIndex=0;
		}
		
		function clearFromSearchForCategoryMenu():void {
			//srcset.itxt2.itxt.text="";
			//srcset.itxt3.itxt.text="";

		}
		function dumper(... args):void {
			for each (var arg:* in args){
				trace(Dumper.toString(arg));
			}
		}
	}
}