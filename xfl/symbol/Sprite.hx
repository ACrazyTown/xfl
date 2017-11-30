package xfl.symbol;

import xfl.dom.DOMLayer;
import xfl.dom.DOMTimeline;
import xfl.XFL;
import openfl.display.DisplayObject;
import openfl.display.FrameLabel;

class Sprite extends xfl.display.Sprite {

	public var children: Array<DisplayObject>;

	public var parametersAreLocked: Bool;

	private static var clips: Array <MovieClip>;

	public function new(xfl: XFL, timeline: DOMTimeline, parametersAreLocked: Bool = false) {
		super();
		this.parametersAreLocked = parametersAreLocked;
		clips = new Array<MovieClip>();
		var labels: Array<FrameLabel> = [];
		var layers: Array<DOMLayer> = [];
		children = [];
		Shared.init(layers, timeline, labels);
		Shared.createFrames(xfl, this, layers, children);
		Shared.enableFrame(xfl, this, layers, timeline != null?timeline.currentFrame:1);
	}

	public function flatten(): Void {
		Shared.flatten(this);
	}

}
