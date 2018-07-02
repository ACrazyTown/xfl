package xfl.symbol;

import xfl.dom.DOMLayer;
import xfl.dom.DOMTimeline;
import xfl.XFL;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.Lib;


class MovieClip extends xfl.display.MovieClip {

	private static var clips: Array <MovieClip> = new Array <MovieClip>();

	public var children: Array<DisplayObject>;

	public var xflSymbolArguments(get, never): XFLSymbolArguments;

	private var _xflSymbolArguments: XFLSymbolArguments;
	private var lastFrame: Int;
	private var startFrame: Int;
	private var endFrame: Int;
	private var repeat: Bool;
	private var layers: Array<DOMLayer>;
	private var playing: Bool;
	private var dfInvisibleObjects: Array<DisplayObject>;
	private var dfProcessedObjects: Array<DisplayObject>;

	public function new(xflSymbolArguments: XFLSymbolArguments = null) {
		super();
		this._xflSymbolArguments = xflSymbolArguments != null?xflSymbolArguments:new XFLSymbolArguments(null, null, null, false);
		currentLabels = [];
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		lastFrame = -1;
		currentFrame = 1;
		layers = [];
		children = [];
		totalFrames = Shared.init(layers, this.xflSymbolArguments.timeline, currentLabels);
		endFrame = totalFrames;
		dfInvisibleObjects = [];
		dfProcessedObjects = [];
		Shared.createFrames(
			this.xflSymbolArguments.xfl, 
			this, 
			layers, 
			children
		);
		update();
	}

	private function get_xflSymbolArguments(): XFLSymbolArguments {
		return _xflSymbolArguments;
	}

	override private function get_currentFrameLabel(): String {
		for (label in currentLabels) {
			if (label.frame + 1 == currentFrame) {
				return label.name;
			}
		}
		return null;
	}

	private inline function applyTween(start: Float, end: Float, ratio: Float): Float {
		return start + ((end - start) * ratio);
	}

	private function enterFrame(): Void {
		// Workaround: Somehow there seem to be some clips still around whereas removed I guess which having playing enabled
		var parent: DisplayObject = this.parent;
		while(true == true) {
			if (parent == Lib.current.stage) {
				break;
			} else
			if (parent == null) {
				trace("enterFrame(): stopping and removing clip: " + name);
				stop();
				return;
			}
			parent = parent.parent;
		}
		if (currentFrame == endFrame) {
			if (repeat == false) {
				stop();
			} else {
				currentFrame = startFrame;
			}
		} else {
			currentFrame++;
		}
		update();
	}

	public override function flatten(): Void {
		Shared.flatten(this);
	}

	private function getFrame (frame: Dynamic): Int {
		if (Std.is(frame, Int)) {
			return cast frame;
		} else 
		if (Std.is (frame, String)) {
			for (label in currentLabels) {
				if (label.name == frame) {
					return label.frame + 1;
				}
			}
		}
		return 1;
	}

	public override function gotoAndPlay(frame: Dynamic, scene: String = null): Void {
		stop();
		currentFrame = getFrame(frame);
		startFrame = currentFrame;
		repeat = false;
		update();
		play();
	}

	public override function gotoAndPlayRange(startFrame: Dynamic, endFrame: Dynamic = null, repeat: Bool = true, scene: String = null): Void {
		stop();
		currentFrame = getFrame(startFrame);
		this.startFrame = currentFrame;
		this.endFrame = endFrame == null?totalFrames:getFrame(endFrame) - 1;
		this.repeat = repeat;
		update();
		play();
	}

	public override function gotoAndStop(frame: Dynamic, scene: String = null): Void {
		stop();
		startFrame = currentFrame;
		currentFrame = getFrame(frame);
		repeat = false;
		update();
	}

	public override function nextFrame(): Void {
		var next = currentFrame + 1;
		if (next > endFrame) {
			next = endFrame;
		}
		gotoAndStop(next);
	}

	public override function play(): Void {
		if (parent == null) {
			trace("play(): do not play clip without parent: " + name);
		}
		if (!playing && endFrame > currentFrame) {
			playing = true;
			clips.push(this);
		}
	}

	
	public override function prevFrame(): Void {
		var previous = currentFrame - 1;
		if (previous < 1) {
			previous = 1;
		}
		gotoAndStop(previous);
	}

	public override function stop(): Void {
		if (playing == true) {
			playing = false;
			repeat = false;
			startFrame = currentFrame;
			endFrame = totalFrames;
			clips.remove(this);
		}
	}

	public override function unflatten(): Void {
		lastFrame = -1;
		update();
	}

	private function update(): Void {
		if (currentFrame != lastFrame) {
			if (lastFrame != -1) {
				Shared.disableFrames(xflSymbolArguments.xfl, this, layers, lastFrame, dfInvisibleObjects, dfProcessedObjects);
			}
			Shared.enableFrame(xflSymbolArguments.xfl, this, layers, currentFrame, dfInvisibleObjects);
			lastFrame = currentFrame;
			dfInvisibleObjects.splice(0, dfInvisibleObjects.length);
			dfProcessedObjects.splice(0, dfProcessedObjects.length);
		}
	}

	private static function onEnterFrame(event: Event): Void {
		for (clip in clips) {
			clip.enterFrame();
		}
	}

}
