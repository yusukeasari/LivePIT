package ws.fossette.PIT{
	import ws.fossette.PIT.*;
	import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;

import flash.utils.ByteArray;

class ParticleManager extends Sprite
{
	public var particles:Vector.<Particle> = new Vector.<Particle>;
	public var sfmt:Sfmt;
	public var stageRect:Rectangle;
	public var bitmapData:BitmapData;
	public var container:BitmapData;
	public var emitter:Point;
	private var ct:ColorTransform;
	
	public function ParticleManager
	(
	sfmt:Sfmt, 
	stageRect:Rectangle, 
	bitmapData:BitmapData, 
	container:BitmapData, 
	emitter:Point
	):void
	{
		this.sfmt = sfmt;
		this.stageRect = stageRect;
		this.bitmapData = bitmapData;
		this.container = container;
		this.emitter = emitter;
		
		ct = new ColorTransform(1, 1, 1, 0.9);
		if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, enterFrame);
	}
	
	public function getParticleNum():int
	{
		return particles.length;
	}
	
	private function enterFrame(e:Event):void
	{
		var l:int = particles.length;
		
		container.lock();
		clearContainer();
		
		for (var i:int = 0; i < l; i++)
		{
			particles[i].update();
			putParticle(particles[i]);
		}
		
		container.unlock();
	}
	
	private function clearContainer():void
	{
		container.fillRect(container.rect, 0x00000000);
		//container.colorTransform(container.rect, ct);
	}
	
	private function putParticle(particle:Particle):void
	{
		container.copyPixels
		(
		bitmapData, 
		new Rectangle(0, 0, Particle.WIDTH, Particle.HEIGHT), 
		new Point(particle.position.x + Particle.WIDTH, particle.position.y + Particle.HEIGHT), 
		null, 
		null, 
		true
		);
	}
}
}
