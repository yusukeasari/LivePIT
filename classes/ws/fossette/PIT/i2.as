import ws.fossette.PIT.*;

import caurina.transitions.Tweener;
import caurina.transitions.properties.CurveModifiers;
import caurina.transitions.properties.ColorShortcuts;




var world:Sprite = new Sprite();
var particleList:Vector.<ArrowMcSMT> = new Vector.<ArrowMcSMT>(100, true);

var rotArr:Vector.<BitmapData> = new Vector.<BitmapData>(120, true);
/*var dummy:Sprite = new Sprite();
dummy.graphics.beginFill(0xFFFFFF, 1);
dummy.graphics.lineStyle(1, 0x0, 1);
dummy.graphics.moveTo(2, 4);
dummy.graphics.lineTo(8, 4);
dummy.graphics.lineTo(8, 0);
dummy.graphics.lineTo(20, 7);
dummy.graphics.lineTo(8, 14);
dummy.graphics.lineTo(8, 10);
dummy.graphics.lineTo(2, 10);
dummy.graphics.lineTo(2, 4);*/

var dummy = new BgSnow();

var matrix:Matrix;
var i:int = 120;
while (i--)
{
	matrix = new Matrix();
	//matrix.translate( -dummy.width/2, -dummy.height/2);
	matrix.rotate( ( 360 / 120 * i )* Math.PI / 180);
	//matrix.translate( dummy.width/2, dummy.height/2);
	rotArr[i] = new BitmapData(dummy.width, dummy.height, true, 0x0);
	rotArr[i].draw(dummy, matrix);
	
}
trace(dummy.width);
for (i = 0; i < 100; i++) {
	var px:Number = Math.random() * 1900;
	var py:Number = Math.random() * 465;
	particleList[i] = new ArrowMcSMT(px, py);
	world.addChild(particleList[i]);
	
	
	particleList[i].rot=0;
}


ColorShortcuts.init();
	
pms.fadeIN(0);
twimc.fadeIN(0);
telop.fadeIN(0);


bgtgtht.addChild(world);

addEventListener(Event.ENTER_FRAME,bgsnowmove);

var bgsnownum:int = 0;
var bgsnowList2:Array = [];

var bgsnowList:Vector.<BgSnow> = new Vector.<BgSnow>();
var tyy;
var ty;
var tx;

for ( i = 0; i<bgsnownum; i++) {
	var snow:BgSnow = new BgSnow();
	snow.x = Math.random()*1200;
	snow.y = Math.random()*450;
	
	snow.scaleX = snow.scaleY = 1.2/(0.08*i+0.6);
	var mtx:Matrix = snow.transform.matrix;
	mtx.c = Math.random()-0.5;
	mtx.b = Math.random()-0.5;
	//snow.transform.matrix = mtx;
	bgtgtht.addChildAt(snow,0);
	bgsnowList.push(snow);
	bgsnowList[i].vx = Math.random()*6-3;
	var cc:ColorTransform = new ColorTransform();
	cc.color = Math.random()*0x333333|0xFF0000;
	bgsnowList[i].transform.colorTransform=cc;
	bgsnowList[i].alpha = Math.random()*0.5+0.2;

	
/*	
	bgsnowList2[i] =[];
	

	tx = Math.random()*(1900-snow.width)+30+(snow.width/2);
//			ty = Math.random()*(460-mc.height)+120+(mc.height/2);
	if(Math.random()>0.5){
		 ty = Math.random()*(110)+460-(snow.height/2);
		if(Math.abs(tyy-ty)<snow.height){
			ty = Math.random()*(110)+460-(snow.height/2);
			 tyy = ty;
		}else{
			 tyy = ty;
		}
	}else{
		 ty = Math.random()*(150-snow.height)+110+(snow.height/2);
		if(Math.abs(tyy-ty)<snow.height){
			ty = Math.random()*(150-snow.height)+110+(snow.height/2);
			 tyy = ty;
		}else{
			 tyy = ty;
		}
	}
	var r = 5;
	var partsize = 20;
	for(var j=0; j<20; j++)
	{
		bgsnowList2[i][j] = new ParticleUnit2( j, -5 * Math.cos( r * Math.PI/180+i*2), -5 * Math.sin( r * Math.PI/180+i*2), partsize,tx-(snow.width/2)+30,ty,{no:i,col:0xffffff} );
		bgtgtht.addChild( bgsnowList2[i][j]  );
		//PUDict[i].addEventListener( "delete", PUdelete,false,0,true );
	}*/
}

function bgsnowmove(e:Event):void {
	/*for ( i=0; i<bgsnownum; i++) {
		
		bgsnowList[i].x += bgsnowList[i].vx/(0.02*i+1)+0.3;
		bgsnowList[i].y += 1.5/(0.02*i+1);
		bgsnowList[i].rotation++;

		if (bgsnowList[i].y>1100||bgsnowList[i].x>1900) {
			bgsnowList[i].scaleX = bgsnowList[i].scaleY = 1.2/(0.08*i+0.6);
			bgsnowList[i].x = Math.random()*1200;
			bgsnowList[i].y = -50;
		}
	}*/
	
	for (var j:uint = 0; j < 100; j++) {
		var arrow:ArrowMcSMT = particleList[j];
                
		arrow.x += 3/(0.02*j+1)+0.3;
		arrow.y += 1.5/(0.02*i+1);
		
		if (arrow.y>1100||arrow.x>1900) {
			arrow.x = Math.random()*1200;
			arrow.y = -50;
		}
		arrow.rot++;
		if(arrow.rot>119){
			arrow.rot=0;
		}
		arrow.bitmapData = rotArr[arrow.rot];
	}


}







stop();