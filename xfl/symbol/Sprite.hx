package xfl.symbol;

import xfl.dom.DOMLayer;
import xfl.dom.DOMTimeline;
import xfl.XFL;
import openfl.display.DisplayObject;
import openfl.display.FrameLabel;

class Sprite extends xfl.display.Sprite {

	public var children: Array<DisplayObject>;

	public var xflSymbolArguments: XFLSymbolArguments;

	public function new(xflSymbolArguments: XFLSymbolArguments = null) {
		super();
		this.xflSymbolArguments = xflSymbolArguments != null?xflSymbolArguments:new XFLSymbolArguments(null, null, false);
		var labels: Array<FrameLabel> = [];
		var layers: Array<DOMLayer> = [];
		children = [];
		Shared.init(layers, this.xflSymbolArguments.timeline, labels);
		Shared.createFrames(this.xflSymbolArguments.xfl, this, layers, children);
		Shared.enableFrame(this.xflSymbolArguments.xfl, this, layers, this.xflSymbolArguments.timeline != null?this.xflSymbolArguments.timeline.currentFrame:1);
	}

	public function flatten(): Void {
		Shared.flatten(this);
	}

}
