package jp.pitcom{
	import flash.display.MovieClip;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.net.*;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	import jp.pitcom.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.utils.getDefinitionByName;
	import flash.external.ExternalInterface;
	
	public class PhotoMosaicStage extends ViewBClass{
		private var normalWidth:Number;
		private var normalHeight:Number;
		private var normalWidth2:Number;
		private var normalHeight2:Number;
		private var model:Object;
		private var blockWidth:int;
		private var blockWidthn:int;
		private var blockWidth2:int;
		private var blockHeight:int;
		private var blockHeightn:int;
		private var blockHeight2:int;
		private var enlargedBlockWidth:int;
		private var enlargedBlockHeight:int;
		private var blockInRow:int;
		private var blockInRow2:int;
		
		private var bdata1:BitmapData;
		
		private var commentDbArray:Array;
		private var commentDbArray2:Array;
		
		private var pmImage:MovieClip;
		private var orgImage:MovieClip;
		private var pmImageSub:MovieClip;
		private var orgImageSub:MovieClip;
		private var orgImage2:MovieClip;
		private var popup:MovieClip;
		private var popupPola:MovieClip;
		
		private var nowDataPoint;
		private var newDataList:Array = new Array();
		private var rndDataList:Array = new Array();

		private var newPopupList:Array = new Array();
		private var rndPopupList:Array = new Array();
		
		private var srcSetup:Object;
		
		private var tweenDelayObjR:MovieClip=new MovieClip();
		private var tweenDelayObjR2:MovieClip=new MovieClip();
		private var tweenDelayObjR3:MovieClip=new MovieClip();

		private var fline:Boolean = true;
		private var fRequestLine:Boolean = true;

		private var rndPopupTimer:MovieClip=new MovieClip();
		
		private var popupTimer:MovieClip=new MovieClip();
		
		function PhotoMosaicStage(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			
			
			
			model = _model;
			
			model.setEvent(this,"checkUpdateData");
			
			model.setEvent(this,"zoomIn");
			model.setEvent(this,"zoomInPola");
			model.setEvent(this,"zoomInRequestPopup");
			//修正(北海道新幹線案件より)
			model.setEvent(this,"loadComp2");

			model.addEventListener("loadCompM",loadCompM);
			model.addEventListener("completeUpdateDataM",completeUpdateDataM);

			model.addEventListener("zoomInM",zoomInM);
			model.addEventListener("zoomInPolaM",zoomInPolaM);
			model.addEventListener("zoomInRequestPopupM",zoomInRequestPopupPolaM);
			model.addEventListener("RequestLinePopupClosedM",requestLinePopupClosedM);
			model.addEventListener("completeUpdateRequestDataM",completeUpdateRequestDataM);


			model.setEvent(this,"checkUpdateRequestData");
			model.setEvent(this,"checkRequestLine");

			//model.addEventListener("LineLoadedM",lineLoadedM)
			//model.addEventListener("linePopupClosedM",linePopupClosedM);

			model.addEventListener("RequestLineLoadedM",requestLineLoadedM)
			
			model.addEventListener("popupClosedM",popupClosedM);
			//model.addEventListener("popupOpenedM",popupOpenedM);
		}

		
		public function loadCompM(eventObj:CEvent):void{
			orgImageSub=new MovieClip();
			mc.addChild(orgImageSub);
			orgImageSub.name="orgImageSub";
			mc["orgImageSub"]=orgImageSub;
			
			pmImageSub=new MovieClip();
			mc.addChild(pmImageSub);
			pmImageSub.name="pmImageSub";
			mc["pmImageSub"]=pmImageSub;
			
			
			orgImage=new MovieClip();
			mc.addChild(orgImage);
			orgImage.name="orgImage";
			mc["orgImage"]=orgImage;
			
			pmImage=new MovieClip();
			mc.addChild(pmImage);
			pmImage.name="pmImage";
			mc["pmImage"]=pmImage;
			
			popup=new MovieClip();
			mc.addChild(popup);
			popup.name="popup";
			mc["popup"]=popup;
			
			popupPola=new MovieClip();
			mc.addChild(popupPola);
			popupPola.name="popupPola";
			mc["popupPola"]=popupPola;
		
			
			
			srcSetup=new Object();
			srcSetup = model.srcSetup;
			
			//横のマス目数
			blockInRow = srcSetup.rowX;//96;
			
			//縦のマス目数
			blockInRow2 = srcSetup.rowY;//68;
			
			//マス目ひとつの縦横ピクセル
			blockWidth = srcSetup.pithw;
			blockHeight = srcSetup.pithw;
			blockWidth2 = srcSetup.pithw;
			blockHeight2 = srcSetup.pithw;
			
			//拡大時の縦横ピクセル
			enlargedBlockWidth = srcSetup.maxWidth;//2400;
			enlargedBlockHeight = srcSetup.maxHeight;//1700;
			
			//通常時の縦横ピクセル
			normalWidth = (srcSetup.normalWidth != "0") ? srcSetup.normalWidth : srcSetup.maxWidth*(srcSetup.normalHeight/srcSetup.maxHeight);//2400;
			normalHeight = (srcSetup.normalHeight != "0") ? srcSetup.normalHeight : srcSetup.maxHeight*(srcSetup.normalWidth/srcSetup.maxWidth);//1700;
			
			blockWidthn = blockWidth*(normalHeight/srcSetup.maxHeight);
			blockHeightn = blockHeight*(normalWidth/srcSetup.maxWidth);
			
			var b = model.frontImage;
			mc.pmImage.addChild(b);
			var c = model.rearImage;
			c.smoothing = false;
			mc.orgImage.addChild(c);
			
			
			
			
			
			args.mc2.aa.width = orgImage.width;
			args.mc2.aa.height = orgImage.height;
			//args.mc2.aa.addChild(b);
			args.mc2.aa.alpha=0;
			args.mc2.width = Math.floor(normalWidth);
			args.mc2.height = Math.floor(normalHeight);

			
			model.simgW0 =normalWidth;
			model.simgH0 =normalHeight;
			
			commentDbArray = model.commentDbArraySet;
			
			checkUpdateData();
			checkRequestLine();

			//修正(北海道新幹線案件より)
			dispatchEvent(new CEvent("loadComp2",{}));
		}
		private function rollOverEvent(event:Event){
			var btn:MovieClip = event.target as MovieClip;
		}
		
		private function setRndPopup():void {
			
			//if(rndPopupList.length < 3){
				if(rndPopupList.length < model.srcData("maxRand")){
				//trace("RND:"+rndPopupList);
				//3より小さければ
				var a;
				a = Math.floor(Math.random() * commentDbArray.length);
				for (var i=0;i<rndPopupList.length;i++){
					if(rndPopupList[i].num == a){
						a = Math.floor(Math.random() * commentDbArray.length);
					}
				}
				
				var st = {};
				st = commentDbArray[a];
				st.rnd=1;
				rndPopupList.push(st);
				//trace("==="+st.id);
				dispatchEvent(new CEvent("zoomIn",st));
				
				Tweener.removeTweens(rndPopupTimer);
				Tweener.addTween(rndPopupTimer,{time:2,delay:0,onComplete:setRndPopup});
			}else{
				Tweener.removeTweens(rndPopupTimer);
				Tweener.addTween(rndPopupTimer,{time:5,delay:0,onComplete:setRndPopup});
			}
			
		}

		private function lineLoadedM(e:CEvent){
			if(model.newLineData.length > 0){
				var st = {};
				st = model.newLineDataShift();
				//model.dumper(st);
				trace("==="+st.id+"/"+st.num);
				dispatchEvent(new CEvent("zoomInPola",st));

				//aaa
			}else{
				Tweener.addTween(tweenDelayObjR2,{time:4,delay:0,onComplete:checkLine});
			}
			//
		}

		private function checkLine():void {
			var args = {};
			args.fline = fline ? true:false;
			Tweener.removeTweens(tweenDelayObjR2);
			dispatchEvent(new CEvent("checkLine",args));
			fline = false;
		}

		private function requestLinePopupClosedM(eventObj:CEvent):void {
			//aaa
			requestLineLoadedM(new CEvent(""));
		}

		private function checkRequestLine():void {
			var args = {};
			trace("fRequestLine:"+fRequestLine);
			args.fRequestLine = fRequestLine ? true:false;
			Tweener.removeTweens(tweenDelayObjR3);
			dispatchEvent(new CEvent("checkRequestLine",args));
			fRequestLine = false;
		}


		private function requestLineLoadedM(e:CEvent){
			if(model.newRequestLineData.length > 0){
				trace("LINE:"+model.newRequestLineData);
				var st = {};
				st = model.newRequestLineDataShift();
				//model.dumper(st);
				trace("==="+st.id+"/"+st.num+"/"+st.b2);
				dispatchEvent(new CEvent("zoomInRequestPopup",st));

				//aaa
			}else{
				Tweener.addTween(tweenDelayObjR3,{time:4,delay:0,onComplete:checkRequestLine});
			}
		}

		private function checkUpdateData():void {
			Tweener.removeTweens(tweenDelayObjR);
			dispatchEvent(new CEvent("checkUpdateData",args));
			//setCheckUpdateTimer();
		}
		private function completeUpdateRequestDataM(evt:*){
			
		}
		private function completeUpdateDataM(eventObj:CEvent):void {
			if(eventObj.args.num != 0 && model.newNmCmt.length ==0){model.newNmCmt=eventObj.args.nmSet;displayNewImage();
			}else if(eventObj.args.num != 0 && model.newNmCmt.length !=0){model.newNmCmtConcat(eventObj.args.nmSet);displayNewImage();
			}else{	model.newNmCmtConcat(eventObj.args.nmSet);}
			trace("COMPLETE:"+model.newNmCmt);
			(model.newNmCmt.length != 0)? doUpdate():noUpdate();
		}
		private function noUpdate(){
			Tweener.removeTweens(tweenDelayObjR);
			trace("noUpdate");
			//Tweener.addTween(tweenDelayObjR,{time:1,delay:0,onComplete:checkUpdateData});
			Tweener.addTween(tweenDelayObjR,{time:3,delay:0,onComplete:checkUpdateData});
		}
		private function doUpdate(){
			trace("doUpdate:"+model.newNmCmt);
			
			var st = {};
			st = model.newNmCmtShift;
			st.rnd=0;
			trace("==="+st.id);
			dispatchEvent(new CEvent("zoomInPola",st));
		}
		
		private function zoomInM(eventObj:CEvent):void{
			var args = eventObj.args;
			
			var a:int = args.num;
			a--;
			
			var i:int = a%blockInRow;
			var j:int = Math.floor(a/blockInRow);
			
			var i2 = i*blockWidth;
			var j2 = j*blockHeight;
			
			var cs;
			cs =((enlargedBlockHeight/2) > j2)? "b":"t";
			cs +=((enlargedBlockWidth/2) > i2)? "r":"l";
			
			var bdata2:BitmapData=new BitmapData(blockWidth*2,blockHeight*2,false,0x000000);
			var bdata=model.frontImage;
			
			bdata2.copyPixels(bdata.bitmapData,new Rectangle(0+i2-blockWidth*0.5,0+j2-(blockHeight/2),blockWidth*2,blockHeight*2),new Point(0,0));
			var b:Bitmap = new Bitmap(bdata2);
			b.smoothing=true;
			b.width=model.srcData("blockViewSize")*1.5;
			b.height=model.srcData("blockViewSize")*1.5;
			
			var zz = new zoomPopup2();
			
			mc.popup.addChild(zz);
			
			zz.x=i2;
			zz.y=j2;
			zz.y +=((enlargedBlockHeight/2) > j2)? blockHeight*1:0;
			zz.x +=((enlargedBlockWidth/2) > i2)? 0:blockWidth*-1;
			zz.x = (i2 == 0)? zz.x+blockWidth:zz.x+blockWidth;
			
			
			args.xx0= zz.x;
			args.yy0= zz.y;
			
			args.cs=cs;
			
			args.blockHeight=blockHeight;
			args.blockWidth=blockWidth;
			args.xx=((enlargedBlockWidth/2) > i2)? blockWidth+blockWidth:blockWidth+blockWidth;
			args.yy=((enlargedBlockHeight/2) > j2)? blockHeight*-1:0;
			
			
			
			var mm = new PopupWindow2(zz,model,args);
			mm.addBackImage(b);
		}
		
		private function zoomInPolaM(eventObj:CEvent):void{
			var argsc = eventObj.args;
			
			var a:int = argsc.num;
			a--;
			
			var i:int = a%blockInRow;
			var j:int = Math.floor(a/blockInRow);
			
			var i2 = i*blockWidth;
			var j2 = j*blockHeight;
			
			var zz = new zoomPopup3();
			//zz.x = (normalWidth/2)-(zz.width/2)+150;
			//zz.y = (normalHeight/2)-(zz.height/2);
			//mc.popupPola.addChild(zz);
			
			args.mc2.addChild(zz);
			
			
			argsc.blockHeight=blockHeight;
			argsc.blockWidth=blockWidth;
			argsc.numx=a;
			argsc.xx=i2;//((enlargedBlockWidth/2) > i2)? blockWidth+blockWidth:blockWidth+blockWidth;
			argsc.yy=j2;//((enlargedBlockHeight/2) > j2)? blockHeight*-1:0;
			trace("POLA::::"+"blockHeight"+blockHeight+":blockWidth"+""+blockWidth+":args.xx"+argsc.xx+":args.yy"+argsc.yy+":a="+a+":i="+i+":j="+j);
			var mm = new PopupWindow3(zz,model,argsc);
		}

		private function zoomInRequestPopupPolaM(eventObj:CEvent):void{
			//num:更新数　コレがあればこの関数動く
			var args = eventObj.args;
			model.allRequestLineData.push(args);
			
			var a:int = args.num;
			a--;
			
			var i:int = a%blockInRow;
			var j:int = Math.floor(a/blockInRow);
			
			var i2 = i*blockWidth;
			var j2 = j*blockHeight;
			
			//zoomPopupCXのリンケージをランダムで取得
			var r;
			r = Math.floor(Math.random() * 4)+1;
			var ClassReference = getDefinitionByName("zoomPopupC"+r) as Class;
			var zz = new ClassReference();

			//拡大表示のイチ設定
			zz.x = (normalWidth/2)-(zz.width/2)+10;
			zz.y = (normalHeight/2)-(zz.height/2)+70;
			zz.scaleX=1.11;
			zz.scaleY=1.11;
			mc.popupPola.addChild(zz);
			
			
			args.blockHeight=blockHeight;
			args.blockWidth=blockWidth;
			args.numx=a;
			args.xx=i2;//((enlargedBlockWidth/2) > i2)? blockWidth+blockWidth:blockWidth+blockWidth;
			args.yy=j2;//((enlargedBlockHeight/2) > j2)? blockHeight*-1:0;
			args.delayTime=10;
			var mm = new RequestPopup(zz,model,args);
		}
		
		private function popupClosedM(eventObj:CEvent):void {
			if(eventObj.args.rnd == 0){
				(model.newNmCmt.length != 0)? doUpdate():noUpdate();
			}else{
				var a=rndPopupList.shift();
				//a.remove();
				setRndPopup();
			}
		}
		
		private function displayNewImage():void{
			
			var b = model.frontImageSub;
			mc.pmImageSub.addChild(b);
			
			var c = model.rearImageSub;
			mc.orgImageSub.addChild(c);
			
			Tweener.addTween(mc.pmImage,{alpha:0,time:3,delay:0,onComplete:displayNewImage2});
			Tweener.addTween(mc.orgImage,{alpha:0,time:3,delay:0});
		}
		
		private function displayNewImage2():void {
			Tweener.removeTweens(mc.pmImage);
			Tweener.removeTweens(mc.orgImage);
			
			removeChildAll(mc.pmImage);
			removeChildAll(mc.orgImage);
			
			var b = model.frontImageSub;
			mc.pmImage.addChild(b);
			
			var c = model.rearImageSub;
			mc.orgImage.addChild(c);
			
			mc.pmImage.alpha=1;
			mc.orgImage.alpha=1;
			
			removeChildAll(mc.pmImageSub);
			removeChildAll(mc.pmImageSub);
			
		}
		
		override public function fadeIN(_startTime:Number):void{
			if(vObj!=null){
				vObj.stop();
			}
			
			//mc.visible = true;
			//mc.alpha =1;
						
			mc.visible = true;
			mc.alpha = 0;
			
			mc.width = Math.floor(normalWidth);
			mc.height = Math.floor(normalHeight);
			//mc.pmImage.width = Math.floor(normalWidth);
			//mc.pmImage.height = Math.floor(normalHeight);
			//mc.sImg.alpha = 1;
			//mc.bImg.alpha = 1;
			setRndPopup();
			vObj=new Timer(_startTime,0);
			vObj.addEventListener(TimerEvent.TIMER, fadeINM);
			vObj.start();
		}
		
		override protected function fadeINM(_timerDispatch):void{
			vObj.stop();
			if(args.eases==undefined){
				args.eases = "easeInOutQuart";
			}
			if(args.startTime==undefined){
				args.startTime = 1;
			}
			if(args.delayTime==undefined){
				args.delayTime = 0;
			}
			Tweener.addTween([mc],{
							 alpha:1,
							 transition:args.eases,
							 time:1,
							 delay:args.delayTime
							 });
		}
		
		function fadeOUT():void {
			Tweener.addTween(mc,{
							 alpha:0,
							 transition:"easeInOutQuart",
							 time:1
							 });
		}
	}
}