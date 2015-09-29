package ws.fossette.PIT{
	import ws.fossette.PIT.*;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import flash.utils.ByteArray;

	class Particle
	{
		public static const WIDTH:Number = 32;
		public static const HEIGHT:Number = 32;
		private var particleManager:ParticleManager;
		public var position:Point;
		private var moveVect:Point;
		private var rect:Rectangle;
		public var liveFlag:Boolean;
		
		public function Particle(position:Point, particleManager:ParticleManager):void
		{
			this.position = position;
			this.particleManager = particleManager;
			
			particleManager.particles.push(this);
			updateMoveVect();
			rect = new Rectangle(0, 0, WIDTH, HEIGHT);
			liveFlag = true;
		}
		
		public function update():void
		{
			position = position.add(moveVect);
			rect.x = position.x;
			rect.y = position.y;
			moveVect.x = moveVect.x * 0.97;
			moveVect.y = moveVect.y * 0.97;
			if (!particleManager.stageRect.containsRect(rect))
			{
				position = particleManager.emitter;
				updateMoveVect();
			}
		}
		
		private function updateMoveVect():void
		{
			moveVect = new Point(particleManager.sfmt.nextUnif() * 2 - 1, particleManager.sfmt.nextUnif() * 2 - 1);
			moveVect.normalize(1)
			moveVect.x = moveVect.x * 10;
			moveVect.y = moveVect.y * 10;
		}
	}
}
