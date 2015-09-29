package jp.pitcom{
	import flash.media.Sound;
	import flash.events.*;
	import jp.pitcom.*;
	import flash.utils.getDefinitionByName;
	
	import flash.external.ExternalInterface;
	
	public class SoundEffects extends SuperModel{
		private var model:Object;		
		private var args:Object;
		private var soundSet:Object;

		public function SoundEffects(_model:Object){
			super();
			
			model = _model;
			
			soundSet = new Object();
			
			model.addEventListener("onSoundEffectsM",onSoundEffects);
			setup();
		}
		
		private function setup():void {
			
		}
		
		private function onSoundEffects(eventObj:CEvent):void {
			
			trace('SN:'+eventObj.args.sn);
			//model.removeEventListener("onSoundEffectsM",onSoundEffects);
			var sn = eventObj.args.sn;
			
			if(soundSet[sn] != null){
				soundSet[sn].play();
			}else{
				var ClassReference:Class = getDefinitionByName(sn) as Class;
				soundSet[sn] = new ClassReference();
				soundSet[sn].play();
			}
		}
		
	}
}