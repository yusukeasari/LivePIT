import jp.pitcom.*;
import flash.display.*;
import ws.fossette.PIT.*;

this.contextMenu = new ContextMenu();   
//this.contextMenu.hideBuiltInItems()  
stage.scaleMode = StageScaleMode.SHOW_ALL;
stage.align = "";

var model0:Object = new Model(stage,root);
//var soundeffects = new SoundEffects(model0);
var oload = new LoadViewBClass(root,stage,loader,model0,{setupJson:'setup_local.json'});
var reload = new ReLoadViewBClass(root,stage,loader,model0,
							  		{}
								);

									
/*
*テロップ
*/
//var telop = new Telop(telopMc,model0,{})

var pms = new PhotoMosaicStage(photoMosaicStage_mc,model0,{mc2:photoMosaicStage_mc2});
var twimc = new TwitterWidget(twitterWidget_mc,model0,{ptgt:bgtgtht2,ptgt2:bgtgtht,z3bg:photoMosaicStage_mc2bg});
//var twimc2 = new MiniTimeline(miniTwitterWidget_mc,model0,{});
//var line = new RequestLine(root,stage,loader,model0,{});

//var cam:ExpoCamera = new ExpoCamera(camera_mc,model0,{});
//cam.fadeIN(1);
stop();
