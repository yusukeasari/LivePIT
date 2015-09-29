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
		
		private var htnum2:uint = 100;
		private var htnum:uint = 500;
		private var htcvsr:Rectangle = new Rectangle(0, 0,1920,1080);		
		
		private var htbitmapsize:Array;
		private var htbitmapsize2:Array;
		private var htbitmapsize3:Array;
		private var htbitmapsize4:Array;
		

		private var htbitmapsize5:Array;
		
		private var htbitmap:Array;
		private var htbitmap2:Array;
		private var htbitmap3:Array;
		private var htbitmap4:Array;
		
		private var htbitmap5:Array;
		
		private var htbitmapN:Array=new Array();
		private var htbitmapsizeN:Array=new Array();
        private var htlist:Vector.<HeartMcSMT2> = new Vector.<HeartMcSMT2>();
        private var htlist2:Vector.<HeartMcSMT2> = new Vector.<HeartMcSMT2>();
		private var bgbg2:BitmapData;
		private var bgbg:BitmapData;
		private var bgbgdmy:Sprite = new Sprite();
		private var bgbg2aF:Boolean =false;
		private var bgbg2aB:uint =1;
		private var bgbg2aB2:uint =1;
		private var bgbg2aBvx:Number =0;
		private var bgbg2aBvy:Number =0;
		
		private var bgsetn:Object=new Object();
		
		function TwitterWidget(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			model = _model;
			model.setEvent(this,"miniTimelineAdd");
			//model.setEvent(this,EVENT_1);

			model.addEventListener("loadComp2M",init);
		}

		private function init(e:*){
			//model.addEventListener("newDataSetOKM",xmlLInfoComplete);
			xmlLInfoComplete({});
			
			model.addEventListener("zoomIn2M",zoomInM);
			model.addEventListener("actionEndM",actionEndM);
			//model.dumper(model.commentDbArraySet);
			model.addEventListener("PopupWindow3_fadeinM",PopupWindow3_fadeinM);			
			
			//pobj = new PatLine5McSMT(args.ptgt2,{});			
			
			bgbg = new BitmapData(1920,1080,true,0x00000000);
			args.ptgt.addChild(new Bitmap(bgbg));
			
			
			bgbg2 = new BitmapData(1920,1080,true,0x00000000);
			args.ptgt2.addChild(new Bitmap(bgbg2));
			
			Tweener.addTween(args.z3bg, {_autoAlpha:0,time:0});
			Tweener.addTween(args.z3bg.msk1, {x:-960,time:0});
			bgsetn.bg1=new Object();
			bgsetn.bg2=new Object();
			bgsetn.bg3=new Object();
			
			bgsetn.bg2.defx = args.z3bg.bg2.x;
			bgsetn.bg2.defy = args.z3bg.bg2.y;
			
			bgsetn.bg3.defx = args.z3bg.bg3.x;
			bgsetn.bg3.defy = args.z3bg.bg3.y;
			
			
			bgsetn.bg1.defx = args.z3bg.bg1.x;

			
			bgsetn.tit1=new Object();
			bgsetn.tit2=new Object();
			
			bgsetn.tit1.defx = args.z3bg.tit1.tit.x;
			bgsetn.tit2.defx = args.z3bg.tit2.tit.x;

			setdefxy();
			
			/*args.z3bg.bgset.cacheAsBitmap = true;
			args.z3bg.msk1.cacheAsBitmap = true;
			args.z3bg.bgset.mask = args.z3bg.msk1;
			*/

			htbitmap = new Array();
			htbitmap2 = new Array();
			htbitmap3 = new Array();
			htbitmap4 = new Array();
			htbitmapsize = new Array();
			htbitmapsize2 = new Array();
			htbitmapsize3 = new Array();
			htbitmapsize4 = new Array();
			var ht0:MovieClip = new BgSnow();
			var ht1:MovieClip = new BgSnow2();
			ht0.filters = [new GlowFilter(0xffffff00, 0.2, 10, 10, 4, 3 )];
			ht1.filters = [new GlowFilter(0xffffff00, 0.2, 10, 10, 4, 3 )];
			var rect:Rectangle = ht0.getBounds(this);
			var rect2:Rectangle = ht1.getBounds(this);
			var size:Number = Math.sqrt(rect.right*rect.right+rect.bottom*rect.bottom)+30;
			var size2:Number = Math.sqrt(rect2.right*rect2.right+rect2.bottom*rect2.bottom)+30;
			
			for (var s:uint=2;s<=15;s++){
				htbitmap[s] = new Vector.<BitmapData>();
				htbitmapsize[s] = new Vector.<Rectangle>();
				var scale:Number = s/10;
				var cc:ColorTransform = new ColorTransform();
				//cc.color = Math.random()*0x333333|0xFF0000;
				cc.color = 0xffffff;
				cc.alphaMultiplier =Math.random()*0.3;
				for (var i:uint=0; i < 360; i++ ) {
					var bmd:BitmapData = new BitmapData(size2*2*scale*1+1,size2*2*scale*1+1,true,0);
					var m:Matrix = new Matrix();
					m.scale(scale*1,scale*1);
					m.rotate(i*0.01744444444/*Math.PI/180*/);
					m.tx = size2 * scale*1;
					m.ty = size2 * scale*1;
					
					bmd.draw(ht1, m, cc, BlendMode.ADD, null, true);
					//bmd.draw(ht0,m);
					
					htbitmap[s].push(bmd);
					htbitmapsize[s].push(new Rectangle(0, 0, size2*2*scale*1+1, size2*2*scale*1+1));
				}
			}

			for (s=2;s<=15;s++){
				htbitmap2[s] = new Vector.<BitmapData>();
				htbitmapsize2[s] = new Vector.<Rectangle>();
				scale = s/10;
				cc = new ColorTransform();
				cc.color = Math.random()*0x222222|0x007b58;//Math.random()*0x333333|0xFF0000;
				cc.alphaMultiplier =Math.random()*0.3+0.5;
				for (i=0; i < 360; i++ ) {
					bmd = new BitmapData(size*2*scale+1,size*2*scale+1,true,0);
					m = new Matrix();
					m.scale(scale,scale);
					m.rotate(i*0.01744444444/*Math.PI/180*/);
					m.tx = size * scale;
					m.ty = size * scale;					
					bmd.draw(ht0, m, cc, BlendMode.ADD, null, true);
					//bmd.draw(ht0,m);
					
					htbitmap2[s].push(bmd);
					htbitmapsize2[s].push(new Rectangle(0, 0, size*2*scale+1, size*2*scale+1));
				}
			}
			for (s=2;s<=15;s++){
				htbitmap3[s] = new Vector.<BitmapData>();
				htbitmapsize3[s] = new Vector.<Rectangle>();
				scale = s/10;
				cc = new ColorTransform();
				cc.color = Math.random()*0x222222|0x70529e;//Math.random()*0x333333|0x00FF00;
				cc.alphaMultiplier =Math.random()*0.3+0.5;
				for (i=0; i < 360; i++ ) {
					bmd = new BitmapData(size*2*scale+1,size*2*scale+1,true,0);
					m = new Matrix();
					m.scale(scale,scale);
					m.rotate(i*0.01744444444/*Math.PI/180*/);
					m.tx = size * scale;
					m.ty = size * scale;					
					bmd.draw(ht0, m, cc, BlendMode.ADD, null, true);
					//bmd.draw(ht0,m);
					
					htbitmap3[s].push(bmd);
					htbitmapsize3[s].push(new Rectangle(0, 0, size*2*scale+1, size*2*scale+1));
				}
			}
			for (s=2;s<=15;s++){
				htbitmap4[s] = new Vector.<BitmapData>();
				htbitmapsize4[s] = new Vector.<Rectangle>();
				scale = s/10;
				cc = new ColorTransform();
				cc.color = Math.random()*0x222222|0xea6b9b;//Math.random()*0x333333|0x0000FF;
				cc.alphaMultiplier =Math.random()*0.3+0.5;
				for (i=0; i < 360; i++ ) {
					bmd = new BitmapData(size*2*scale+1,size*2*scale+1,true,0);
					m = new Matrix();
					m.scale(scale,scale);
					m.rotate(i*0.01744444444/*Math.PI/180*/);
					m.tx = size * scale;
					m.ty = size * scale;					
					bmd.draw(ht0, m, cc, BlendMode.ADD, null, true);
					//bmd.draw(ht0,m);
					
					htbitmap4[s].push(bmd);
					htbitmapsize4[s].push(new Rectangle(0, 0, size*2*scale+1, size*2*scale+1));
				}
			}
			
			
			/*var sp = new Sprite();
			args.ptgt.addChild(sp);
			sp.mouseChildren = false;
			sp.mouseEnabled = false;*/
			
			
			args.ptgt.mouseChildren = false;
			args.ptgt.mouseEnabled = false;
			
			

			args.ptgt2.mouseChildren = false;
			args.ptgt2.mouseEnabled = false;

			
			for (i=0;i<htnum2;i++){
				
				htlist.push(new HeartMcSMT2(Math.random()*1900,Math.random()*1000,i));
				
			}	
			
			for (i=0;i<htnum;i++){
				
//				htlist.push(new HeartMcSMT2(Math.random()*1900,Math.random()*1000,i/*,htbitmap*/));
				
				htlist2.push(new HeartMcSMT2(Math.random()*1900,Math.random()*1000,i/*,htbitmap*/));
				//htlist3.push(new HeartMcSMT2(Math.random()*1900,Math.random()*1000,i/*,htbitmap*/));
				//sp.addChild(htlist[i]);
				
				
				//var _rotation = Math.round( 1 % 360 )
				
				//htlist[i]._bmp0= htbitmap[htlist[i].sc][_rotation];
			}			

			addEventListener(Event.ENTER_FRAME,bgsnowmove);
			
			/*args.ptgt.scaleX =5;
			args.ptgt.scaleY =5;*/
		}

		private function setdefxy(){
			args.z3bg.bg2.y = bgsetn.bg2.defy-args.z3bg.bg2.height;
			args.z3bg.bg3.y = bgsetn.bg3.defy+args.z3bg.bg3.height;			
			args.z3bg.tit1.tit.x = bgsetn.tit1.defx+1000;
			args.z3bg.tit2.tit.x = bgsetn.tit2.defx+1000;
			args.z3bg.bg1.x = bgsetn.bg1.defx+100;
			
			Tweener.addTween(args.z3bg.tit1, {_Blur_blurX:30,time:0});
			Tweener.addTween(args.z3bg.tit2, {_Blur_blurX:30,time:0});
			
			Tweener.addTween(args.z3bg.bg1.bg, {_brightness:2,time:0});
			Tweener.addTween(args.z3bg.bg1, {_autoAlpha:0,time:0,delay:0});
			
			
			
			
			
		}
		private function setdefxy2(){
			args.z3bg.bg2.x = bgsetn.bg2.defx-args.z3bg.bg2.width;
			args.z3bg.bg3.x = bgsetn.bg3.defx+args.z3bg.bg3.width;			
			args.z3bg.tit1.tit.x = bgsetn.tit1.defx;
			args.z3bg.tit2.tit.x = bgsetn.tit2.defx;
		}
		
		//private function xmlLInfoComplete(event:Event) {
		private function xmlLInfoComplete(event:*) {	
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
				
				
				/*bgbgdmy.x =3;
				bgbgdmy.y= 2000;

				for (var i:uint=0;i<htnum;i++){
					
					htlist2[i].x =Math.random()*1900;
					htlist2[i].y =1080;
					
				}
				bgbg2aF=true;
				bgbg2.fillRect(htcvsr, 0x00000000);
				Tweener.removeTweens(bgbgdmy);
				Tweener.removeTweens(args.ptgt2);
				Tweener.addTween(args.ptgt2, {_autoAlpha:1,time:0});

				
				//Tweener.addTween(bgbgdmy, {x:200, y:200,_bezier:{x: 1000, y: 300},time:2,delay:0, transition: "easeOutSine"});
				Tweener.addTween(bgbgdmy, {x:5,time:1,delay:2, transition: "easeOutExpo",onComplete:zoomInM2});
				Tweener.addTween(args.ptgt2, {_autoAlpha:0,time:1,delay:2, transition: "easeOutSine"});*/

				//var newObject = twitterData2.shift();
				//model.dumper(mc);
				var newChild = new TwitterWidgetChild(mc,element,model,0);
				TLList.unshift(newChild);
				
				action();
			}
		}
		private function PopupWindow3_fadeinM(e):void{
				var i:uint;
				var mmm = Math.random()*10;
				if(mmm>5){
					bgbg2aB=2;
					//bgbg2aBvx=htlist2[i].vx/1
				}else{
					bgbg2aB=1;
				}
				mmm = Math.random()*3;
				if(mmm>2){
					htbitmapN=htbitmap4;
					htbitmapsizeN=htbitmapsize4;
				}else if(mmm>1){
					htbitmapN=htbitmap3;
					htbitmapsizeN=htbitmapsize3;
				}else{
					htbitmapN=htbitmap2;
					htbitmapsizeN=htbitmapsize2;
				}
				

				
				bgcovin();
				
	
				bgbgdmy.y= 3;
				switch(bgbg2aB){
					case 1:
						bgbgdmy.x =3;
						for (i=0;i<htnum;i++){
						
							/*htlist2[i].x =Math.random()*1900;
							htlist2[i].y =0;*/
							htlist2[i].x =-100;
							htlist2[i].y =Math.random()*1900/*Math.random()*600+300*/;
							
						
						}
						
					
						Tweener.removeTweens(args.z3bg.msk1);
						Tweener.addTween(args.z3bg.msk1, {x:-960,time:0});
					break;
					case 2:
						bgbgdmy.x =3;
						for (i=0;i<htnum;i++){
						
							/*htlist2[i].x =Math.random()*1900;
							htlist2[i].y =1080;*/
							htlist2[i].x =2000;
							htlist2[i].y =Math.random()*1900/*Math.random()*600+300*/;
							


							
						}
						
						Tweener.removeTweens(args.z3bg.msk1);
							Tweener.addTween(args.z3bg.msk1, {x:2880,time:0});
					break;
				}
				

				
				
				bgbg2aF=true;
				bgbg2.fillRect(htcvsr, 0x00000000);
				
				/*
				Tweener.removeTweens(args.z3bg);
				Tweener.addTween(args.z3bg, {_autoAlpha:0,scaleY:0,time:0});
				*/
				Tweener.removeTweens(args.z3bg);
				Tweener.addTween(args.z3bg, {_autoAlpha:1/*,x:2000,y:-700,rotation:Math.random()*360,_scale:0.5*/,time:0});
				
				
				
				
				Tweener.removeTweens(bgbgdmy);
				Tweener.removeTweens(args.ptgt2);
				
				Tweener.addTween(args.ptgt2, {_autoAlpha:1,time:0});
				
				//Tweener.addTween(args.z3bg, {_autoAlpha:1,scaleY:1,time:1,delay:1, transition: "easeOutBack",onComplete:zoomInM2b});
				
				/*Tweener.addTween(args.z3bg, {x:960,y:540,time:1,delay:1, transition: "easeOutSine"});
				Tweener.addTween(args.z3bg, {_scale:1,rotation:0,time:1,delay:1, transition: "easeOutSine"});*/
				Tweener.addTween(args.z3bg.msk1, {x:960,time:1,delay:1, transition: "easeOutExpo",onComplete:zoomInM2b});

				
				//Tweener.addTween(bgbgdmy, {x:200, y:200,_bezier:{x: 1000, y: 300},time:2,delay:0, transition: "easeOutSine"});
				Tweener.addTween(bgbgdmy, {x:4,y:3,time:3,delay:3, transition: "easeOutExpo",onComplete:zoomInM2});
				Tweener.addTween(args.ptgt2, {_autoAlpha:0,time:1,delay:3, transition: "easeOutSine"});
		}
		private function bgcovin(){
			
			var aa = Math.random()*2;
			args.z3bg.bg3.bga.visible=false;
			args.z3bg.bg3.bgb.visible=false;
			
			if(aa>1){
				args.z3bg.bg3.bga.visible=true;
			}else{
				args.z3bg.bg3.bgb.visible=true;
			}	
			
			Tweener.removeTweens(args.z3bg.bg2);
			Tweener.removeTweens(args.z3bg.bg3);

			Tweener.addTween(args.z3bg.bg2, {x: bgsetn.bg2.defx,y: bgsetn.bg2.defy,time:1,delay:1.2, transition: "easeOutExpo"});
			
			Tweener.addTween(args.z3bg.bg3, {x: bgsetn.bg3.defx,y: bgsetn.bg3.defy,time:1,delay:1.2, transition: "easeOutExpo"});
			
			Tweener.removeTweens(args.z3bg.bg1);
			Tweener.addTween(args.z3bg.bg1, {_autoAlpha:2,x: bgsetn.bg1.defx,time:1,delay:2, transition: "easeOutSine"});
			
			Tweener.removeTweens(args.z3bg.bg1.bg);
			Tweener.addTween(args.z3bg.bg1.bg, {_brightness:0,time:0.6,delay:2, transition: "easeOutSine"});
			
			Tweener.removeTweens(args.z3bg.tit1.tit);
			Tweener.addTween(args.z3bg.tit1.tit, {x:0,time:1,delay:2, transition: "easeOutExpo"});
			
			Tweener.removeTweens(args.z3bg.tit2.tit);
			Tweener.addTween(args.z3bg.tit2.tit, {x:0,time:1,delay:2.2, transition: "easeOutExpo"});
			
			Tweener.removeTweens(args.z3bg.tit1);
			Tweener.addTween(args.z3bg.tit1, {_Blur_blurX:0,time:1,delay:2.3, transition: "easeOutSine"});
			
			Tweener.removeTweens(args.z3bg.tit2);
			Tweener.addTween(args.z3bg.tit2, {_Blur_blurX:0,time:1,delay:2.3, transition: "easeOutSine"});
			

		}
		private function zoomInM2b():void{
			//Tweener.addTween(args.z3bg, {_autoAlpha:0,scaleY:0,time:1,delay:3, transition: "easeOutExpo"});
			/*Tweener.addTween(args.z3bg, {_autoAlpha:0,x:1200,y:-700,_scale:0.5,rotation:Math.random()*360,time:1,delay:3, transition: "easeOutSine"});*/
			Tweener.addTween(args.z3bg, {_autoAlpha:0,time:1,delay:3, transition: "easeOutSine"});

		}
		private function zoomInM2():void{
			bgbg2aF=false;
			Tweener.removeTweens(bgbgdmy);
			Tweener.removeTweens(args.ptgt2);
			Tweener.removeTweens(args.z3bg);
			Tweener.removeTweens(args.z3bg.msk1);
			
			setdefxy();

		}
		private function action():void{
			if(!actionFlag){
				
				dispatchEvent(new CEvent("miniTimelineAdd",TLList[TLList.length-1].mine()));

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
			
			

			bgbg.lock();
			
			bgbg.fillRect(htcvsr, 0x00000000);
			
			//bgbg2.colorTransform(htcvsr, new ColorTransform(0.9, 0.9, 0.9));
			//bgbg.colorTransform(htcvsr, new ColorTransform(1, 1, 1, 0.9));
			
			
			for (var i:uint=0;i<htnum2;i++){
				htlist[i].x -=htlist[i].vx/5;//(0.02*i+1)+0.3;
				htlist[i].y -=htlist[i].vy/6;//(0.02*i+1)+0.3;
				
				//htlist[i].x -=htlist[i].vx/0.8;//(0.02*i+1)+0.3;
				//htlist[i].y +=htlist[i].vy/0.7;//(0.02*i+1)+0.3;
				htlist[i].rot++;	
				
				var rot = Math.round( htlist[i].rot % 360 );
				
				
				bgbg.copyPixels(htbitmap[htlist[i].sc][rot], htbitmapsize[htlist[i].sc][rot],new Point(htlist[i].x,htlist[i].y), null, null, true);
				
				//htlist[i].bitmapData =  htbitmap[2][_rotation];
				//htlist[i]._bmp0= htbitmap[htlist[i].sc][rot];
			
				if (htlist[i].y<0||htlist[i].x>1900) {
					htlist[i].x = Math.random()*1900;
					htlist[i].y = 1100;
				}
				
			}

			bgbg.unlock();
			
			//var i:uint;
			//var rot;
			
			if(bgbg2aF){
				bgbg2.lock();	
				bgbg2.fillRect(htcvsr, 0x00000000);
				//bgbg2.colorTransform(htcvsr, new ColorTransform(0.9, 0.9, 0.9));
				//bgbg2.colorTransform(htcvsr, new ColorTransform(1, 1, 1, 0.9));
				
				switch(bgbg2aB){
					case 1:
						for (i=0;i<htnum;i++){
							
							htlist2[i].x +=htlist2[i].vx*bgbgdmy.y/0.6;//(0.02*i+1)+0.3;
							htlist2[i].y -=(0.02*i+1)+0.3;
							htlist2[i].rot++;			
							rot = Math.round( htlist2[i].rot % 360 );
							bgbg2.copyPixels(htbitmapN[htlist2[i].sc][rot], htbitmapsizeN[htlist2[i].sc][rot],new Point(htlist2[i].x,htlist2[i].y), null, null, true);

						}
					break;
					case 2:
						for (i=0;i<htnum;i++){
							
							htlist2[i].x -=htlist2[i].vx*bgbgdmy.y/0.6;//(0.02*i+1)+0.3;
							htlist2[i].y -=(0.02*i+1)+0.3;
							htlist2[i].rot++;			
							rot = Math.round( htlist2[i].rot % 360 );
		
							bgbg2.copyPixels(htbitmap2[htlist2[i].sc][rot], htbitmapsize2[htlist2[i].sc][rot],new Point(htlist2[i].x,htlist2[i].y), null, null, true);
	
						}
					break;

				}
				bgbg2.unlock();
			}

		}
	}
}
