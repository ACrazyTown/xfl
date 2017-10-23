package xfl.symbol;

import xfl.dom.DOMLayer;
import xfl.dom.DOMTimeline;
import xfl.XFL;
import openfl.display.FrameLabel;

class Sprite extends xfl.display.Sprite {

	private static var clips: Array <MovieClip>;

	public function new(xfl: XFL, timeline: DOMTimeline) {
		super();
		clips = new Array<MovieClip>();
		var labels: Array<FrameLabel> = new Array<FrameLabel>();
		var layers: Array<DOMLayer> = new Array<DOMLayer>();
		Shared.init(layers, timeline, labels);
		Shared.createFrames(xfl, this, layers);
		Shared.enableFrame(xfl, this, layers, timeline != null?timeline.currentFrame:1);
	}

	public function flatten(): Void {
		Shared.flatten(this);
	}

}
