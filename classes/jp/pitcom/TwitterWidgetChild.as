package jp.pitcom{
	import flash.display.MovieClip;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
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
	import flash.text.AntiAliasType;

	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.MatrixShortcuts;
	
	public class TwitterWidgetChild extends ViewBClass{
		private var model:Object;
		private var tcmc:MovieClip;
		private var dataObj:Object;
		private var EVENT_1:String = "";
		private var EVENT_2:String = "onSearchForID";
		private var EVENT_3:String = "onTimelineLoaded";
		private var ILoader1:Loader;
		private var linfo:LoaderInfo;
		private var colorList:Array=['0xCC0033','0x993399','0x0066CC','0x006600','0xFF6600','0xFFFF00','0x66CCFF','0xFF3399','0x999999','0x66CC00'];
		
		private var defPos:Number;
		

		private var aaaa:Object={deg:0,rad:0,rad:2,rad3:0,
			//     1    2    3    4    5    6    7    8     9    10   11   12   13   14    15
			/*xx:[ 140, 390, 640, 890, 170, 420, 670, 920, 150, 400, 650, 900, 1020, 1020, 1020],
			yy:[ 350, 350, 350, 350, 600, 600, 600, 600, 850, 850, 850, 850, 1300, 1300, 1300]*/
	
			xx:[ 120, 320, 520, 720, 120, 320, 520, 720, 720, 800, 670, 920, 1020, 1020, 1020],
			yy:[ 380, 380, 380, 380, 580, 580, 580, 580, 780, 1300, 850, 850, 1300, 1300, 1300]
			};

		public function TwitterWidgetChild(_mc:MovieClip,_element:Object,_model:Object,_defPos){
			model=_model;
			dataObj = _element;
			defPos=_defPos;
			tcmc = new TwitterWidgetChild_mc();
		

			
			/*
			tcmc.x = aaaa.xx[defPos]+Math.random()*20-10;
			tcmc.y = aaaa.yy[defPos]+Math.random()*20-10;
*/
			tcmc.x =-600;
			tcmc.y =-600;
			
			
			MatrixShortcuts.init();
			CurveModifiers.init();
			
			var n=dataObj.id.substr(dataObj.id.length-1,1);
			var co=colorList[n];
			
		/*	var colorTransform:ColorTransform = tcmc["newBadge"]["newBadge"]["base"].transform.colorTransform;
			colorTransform.color = co;
			tcmc["newBadge"]["newBadge"]["base"].transform.colorTransform = colorTransform;
			*/
			tcmc.newBadge.visible=false;
			//if(dataObj.b1 == '' && dataObj.b2 == ''){ tcmc.strBg.visible=false; }
			
			/*@@@@2015
			tcmc.strBg.visible=false;
			trace("String:"+String(dataObj.b1).length+"/"+String(dataObj.b2).length);
			if(String(dataObj.b1).length+String(dataObj.b2).length != 0){
				
				tcmc.strBg.visible=true;
				tcmc.nameText.text = dataObj.b1;
				tcmc.messageText.text =dataObj.b2;
			}*/
			
			tcmc = _mc.timelineChild.addChild(tcmc);
			model.setEvent(this,"actionEnd");
			super(tcmc);
			
			onStartLoad();
			
			

		addEventListener(Event.ENTER_FRAME,enterframe);
//@@@@
		}
		public function playNewBadge():void{
			Tweener.removeTweens(tcmc.newBadge);
			tcmc.newBadge.visible=true;
			tcmc.newBadge.gotoAndPlay("start");
		}
		
		public function onStartLoad(){
			model.setEvent(this,EVENT_3);
			
			imageLoad();
		}
		
		function imageLoad():void{
			ILoader1 = new Loader();
			
			linfo = ILoader1.contentLoaderInfo;

			linfo.addEventListener(Event.OPEN,imageLInfoOpen);		
			linfo.addEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			linfo.addEventListener(Event.INIT,imageLInfoInit);
			linfo.addEventListener(Event.COMPLETE,imageLInfoComp);
			linfo.addEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			var nowDate:Date = new Date();
			var ureq:URLRequest;
			if(model.srcData("isOnline") == true){
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+dataObj.img+'.jpg?'+Math.floor(Math.random()*1000));
			}else{
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+dataObj.img+'.jpg');
			}
			//trace(model.srcData("swfData")+model.srcData("blockImg")+dataObj.img+'.jpg');
			ILoader1.load(ureq);
		}

		private function searchButtonReleaseM(event:CEvent){
			
		}
		
		public function set defaultPositionX(x:Number){
			mc.x = x;
		}
		public function get defaultPositionX(){
			return mc.x;
		}
		public function set defaultPositionY(y:Number){
			tcmc.y = y;
		}
		public function get defaultPositionY(){
			return mc.y;
		}
		
		public function get defaultWidth(){
			return mc.width;
		}
		public function get defaultHeight(){
			return tcmc.height;
		}
		
		function imageLInfoOpen(event:Event){
		}
		function imageLInfoProgress(event:ProgressEvent){
		}
		function imageLInfoInit(event:Event){
		}
		
		function imageLInfoComp (event:Event){
			ILoader1.width=174;
			ILoader1.height=174;
			ILoader1.x -= ILoader1.width/2;
			ILoader1.y -= ILoader1.height/2;
			
			tcmc.imgLoad.addChild(ILoader1);
			
			dispatchEvent(new CEvent(EVENT_3,args));
			model.removeEvent(this,EVENT_3);
			

			/*
			if(model.srcData("timeline") == 'v'){
				mc.y = defY-20;
				
			}else{
				mc.x = defX-20;
			}*/
			fadeIN(1);
		}
		override public function fadeIN(_startTime:Number):void{
			
			Tweener.removeTweens(mc);
			Tweener.addTween(mc,{
							 time:0,
							 delay:0
							 });
			Tweener.addTween(mc,{_autoAlpha:0,time:0});

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
				args.delayTime = 1.4;
			}
			Tweener.removeTweens(mc);
			

/*
			Tweener.addTween(mc,{x:defX,y:defY, transition:"easeOutBack",time:0.5,delay:args.delayTime});
			if(defPos != 0){

				if(model.srcData("timeline") == 'v'){
					defPos = mc.height*defPos;
					Tweener.addTween(mc,{_autoAlpha:1,y:defPos, transition:"easeInOutSine",time:0.5,delay:args.delayTime});
				}else{
					defPos = mc.width*defPos;
					Tweener.addTween(mc,{_autoAlpha:1,x:defPos, transition:"easeInOutSine",time:0.5,delay:args.delayTime});
				}
			}else{
				defPos=1;
				Tweener.addTween(mc,{_autoAlpha:1, transition:"easeInOutSine",time:0.5,delay:args.delayTime});
				Tweener.addTween(tcmc.newBadge,{time:0.5,delay:args.delayTime,onComplete:playNewBadge});
				
			}
*/

var tr = Math.random()*100-50;

Tweener.addTween(tcmc,{_scale:2.5,rotationY:tr,rotationX:tr,_autoAlpha:0,time:0});


Tweener.addTween(tcmc,{rotationY:0,rotationX:0,time:1.5,delay:0+defPos*0.1,transition:'easeOutSine'});
Tweener.addTween(tcmc,{x:aaaa.xx[defPos],y:aaaa.yy[defPos],time:1.5,delay:0+defPos*0.1,transition:'easeOutSine'});
	//Tweener.addTween(tcmc,{x:aaaa.xx[defPos]+Math.random()*20-10,y:aaaa.yy[defPos]+Math.random()*20-10,time:1.5,delay:0+defPos*0.1,transition:'easeOutBack'});
Tweener.addTween(tcmc,{_scale:1,time:1.5,delay:0+defPos*0.1,transition:'easeOutBack'});
Tweener.addTween(tcmc,{_autoAlpha:1,time:1.5,delay:0+defPos*0.1,transition:'easeOutSine'});

if(defPos != 0){
	
}else{
	//defPos=1;
	//Tweener.addTween(tcmc.newBadge,{time:0.5,delay:args.delayTime,onComplete:playNewBadge});
}
/*
Tweener.addTween(tcmc,{
		   y:tcmc.y+20,
												x:tcmc.x+20,
												  _autoAlpha:0,
												  _Blur_blurX:0,
												  _Blur_blurY:0,
												  
												// rotation:Math.random()*80,
												_matrix_a : -0.05,
												_matrix_b : 0.9,
												_matrix_c : 0.9,
												_matrix_d : -0.9,
		  time:0,delay:0});



				Tweener.removeTweens(tcmc);
				Tweener.addTween(tcmc,{

										  _autoAlpha:1,
										  transition:"easeOutQuint",
										  time:1,
										  delay:0});
				Tweener.addTween(tcmc,{
										 y:tcmc.y+20,
										  x:tcmc.x+20,

										  transition:"easeOutSine",
										  time:1,
										  delay:0});
				Tweener.addTween(tcmc,{
										  _Blur_blurX:0,
										  _Blur_blurY:0,
										  transition:"easeInSine",
										  time:1,
										  delay:0});
				Tweener.addTween(tcmc,{

										_matrix_a : 1,
										_matrix_b : 0,
										_matrix_c : 0,
										_matrix_d : 1,
										  transition:"easeOutSine",
										  time:1,
										  delay:0});
		  
		  
*/

				args.dtI=0.2;
		}
		
		private function newBadgeRemove():void {
			Tweener.removeTweens(tcmc.newBadge);
		}
		
		function imageLInfoIOError(event:IOErrorEvent) {
			
		}
		public function moveOut0(_i){
			
			
			
/*			var tx = aaaa.xx[_i]+Math.random()*20-10;
			var ty = aaaa.yy[_i]+Math.random()*20-10;
	*/		
			var tx = aaaa.xx[_i];
			var ty = aaaa.yy[_i];
			
			var cptxy = getcptxy(new Point(tcmc.x,tcmc.y),new Point(tx,ty));
			var trot=-360;
			var trotv=0;
			/*switch(_i){
				case 0: case 1: case 2: case 3: trot = -360;break;
				case 4: case 5: case 6: case 7: trot = 360;break;
				case 8: case 9: case 10: case 11: trot = -360;break;
			}*/
			switch(_i){
				case 0: case 2: case 4: case 6: trot = -360;break;
				case 1: case 3: case 5: case 7: trot = 360;break;
				case 8: case 9: case 10: case 11: trot = -360;break;
			}
			
		//	Tweener.addTween(tcmc,{rotationY:tcmc.rotationY+trot,time:1.5,transition:'easeOutBack',delay:_i*0.05});
			Tweener.addTween(tcmc,{rotationX:tcmc.rotationX+trot,time:1.5,transition:'easeOutBack',delay:_i*0.05});
			Tweener.addTween(tcmc, {x:tx, y:ty,_bezier:[{x: cptxy.x, y: cptxy.y}], time:1.2,delay:_i*0.05, transition: "easeOutSine"});
			
			
			//tcmc.imgLoad.x = 0;
			//tcmc.imgLoad.y = 0;
			//tcmc.imgLoad.rotation = 0;
			

		}
		public function moveOut(_i){
			if(defPos != 0){
				//Tweener.addTween(tcmc.newBadge,{_autoAlpha:0,transition:"easeInOutSine",time:0.5,delay:args.delayTime,onComplete:newBadgeRemove});
			}
			
			/*
			if(model.srcData("timeline") == 'v'){
				Tweener.addTween(mc,{y:mc.height+mc.y,time:0.5,delay:1,transition:"easeinoutquad",onComplete:moveOutEnd});
			}else{
				Tweener.addTween(mc,{x:mc.width+mc.x,time:0.5,delay:1,transition:"easeinoutquad",onComplete:moveOutEnd});
			}*/
			moveOut0(_i);

		}
		public function moveOut2(_i){
			moveOut0(_i);
			Tweener.addTween(tcmc, {time:1.5,delay:_i*0.1, transition: "easeOutBack",onComplete:moveOutEnd});
		}
		private function moveOutEnd():void {
			dispatchEvent(new CEvent("actionEnd",args));
		}
		public function mine(){
			return dataObj;
		}
		function remove():void{
			trace("REMOVE!!!");
			
			//disChildAll(tcmc);
			removeChildAll(tcmc);
			
			if(ILoader1!=null){
				ILoader1.unload();
				ILoader1=null;
			}

			removeEventListener(Event.ENTER_FRAME,enterframe);
//@@@@
			linfo.removeEventListener(Event.OPEN,imageLInfoOpen);		
			linfo.removeEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			linfo.removeEventListener(Event.INIT,imageLInfoInit);
			linfo.removeEventListener(Event.COMPLETE,imageLInfoComp);
			linfo.removeEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			//vObj.removeEventListener(TimerEvent.TIMER, fadeINM);
			//tcmc.button.buttonMode=false;
			//tcmc.removeEventListener(MouseEvent.CLICK,onClick);
			//tcmc.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			//tcmc.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			
			tcmc.parent.removeChild(tcmc);
			
			model.removeEvent(this,EVENT_3);
			model.removeEvent(this,"actionEnd");
			
			model=null;
		}
		function getBytesTotal_code(_str:String):uint {
			var nCount:uint = 0;
			var nLength:int = _str.length;
			for (var i:uint = 0; i < nLength; i++) {
				var char_str:String = _str.charAt(i);
				var nCode:Number = char_str.charCodeAt(0);
				var bSingle:Boolean = (nCode < 0x7F) || (0xFF61 < nCode && nCode < 0xFF9F);
				nCount +=  bSingle ? 1 : 2;
			}
			return nCount;
		}

		private function enterframe(event:Event) {
			aaaa.rad+=0.01;
			aaaa.rad2+=Math.random()*0.2;
			aaaa.rad3+=0.02;
			aaaa.deg+=0.5;
			
			var a:Number = Math.sin(aaaa.deg* Math.PI / 180)*0.1;
			var b:Number = Math.cos(aaaa.deg* Math.PI / 180)*0.3;
			//var c:Number = Math.cos(aaaa.deg* Math.PI / 180)*0.1;
			//var d:Number = Math.cos(aaaa.rad2)*Math.random()*2.6;
			//var e:Number = Math.cos(aaaa.rad)*Math.random()*2;
			//tcmc.rotationY+=c;
//tcmc.imgLoad.x+=b;
//tcmc.cov.x =tcmc.imgLoad.x+=b;
tcmc.cov.y =tcmc.imgLoad.y+=a;
tcmc.cov.rotation =tcmc.imgLoad.rotation = -Math.sin(aaaa.rad3)*2;
		}
		private function getcptxy(start:Point, end:Point):Point {
			var cxp:Point = Point.interpolate(start,end,0.5);
			var length:Number = Point.distance(start, end) / 2;
			var p1:Point = end.subtract(start);
			var r1:Number = Math.atan2(p1.y, p1.x);
			r1 += Math.PI / 2;
			var newps:Point = Point.polar(length, r1);
			newps = newps.add(cxp);
			var newpe:Point = Point.polar(-length, r1);
			newpe = newpe.add(cxp);
			return newps;
}
//@@@@
		
	}
}
