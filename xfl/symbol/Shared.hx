package xfl.symbol;

import xfl.XFL;
import xfl.dom.DOMFrame;
import xfl.dom.DOMBitmapInstance;
import xfl.dom.DOMComponentInstance;
import xfl.dom.DOMDynamicText;
import xfl.dom.DOMStaticText;
import xfl.dom.DOMLayer;
import xfl.dom.DOMShape;
import xfl.dom.DOMRectangle;
import xfl.dom.DOMTimeline;
import xfl.dom.DOMSymbolInstance;
import xfl.geom.Matrix;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.FrameLabel;
import openfl.display.XFLMovieClip;

/**
 * Shared between Sprite and MovieClip
 */
class Shared {

    public static function init(layers: Array<DOMLayer>, timeline: DOMTimeline, labels: Array<FrameLabel>): Int {
        var totalFrames: Int = 0;
		if (timeline != null) {
			for (layer in timeline.layers) {
				for (frame in layer.frames) {
					var pushLabel: Bool = frame.name != null;
					if (pushLabel == true) {
						for (label in labels) {
							if (label.name == frame.name) {
								pushLabel = false;
								break;
							}
						}
					}
					if (pushLabel == true) {
						labels.push(new FrameLabel(frame.name, frame.index));
					}
				}
			}
			for (layer in timeline.layers) {
				if (layer.layerType != "guide" && layer.frames.length > 0) {
					layers.push(layer);
					for (frame in layer.frames) {
						if (frame.index + frame.duration > totalFrames) {
							totalFrames = frame.index + frame.duration;
						}
					}
				}
			}
		}
		layers.reverse();
		/*
		for (layer in layers) {
			for (frame in layer.frames) {
				frame.elements.reverse();
			}
		}
		*/
        return totalFrames;
    }

	public static function flatten(container: DisplayObjectContainer): Void {
		/*
		var bounds = container.getBounds(container);
		var bitmapData = null;
		if (bounds.width > 0 && bounds.height > 0) {
			bitmapData = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0x00000000);
			var matrix = new Matrix();
			matrix.translate(-bounds.left, -bounds.top);
			bitmapData.draw(container, matrix);
		}
		for (i in 0...container.numChildren) {
			var child = container.getChildAt (0);
			if (Std.is(child, MovieClip)) {
				untyped child.stop ();
			}
			container.removeChildAt(0);
		}
		if (bounds.width > 0 && bounds.height > 0) {
			var bitmap = new Bitmap(bitmapData);
			bitmap.smoothing = true;
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			container.addChild(bitmap);
		}
		*/
	}

    public static function createFrames(xfl: XFL, container: DisplayObjectContainer, layers: Array<DOMLayer>): Void {
		var currentLayer: Int = 0;
		for (layer in layers) {
			// TODO: a.drewke, handle hit area correctly
			if (layer.name != null && 
				(layer.name == "HitArea" || layer.name == "hitbox")) continue;
			for (i in 0...layer.frames.length) {
				var frame: DOMFrame = layer.frames[i];
				var frameAnonymousObjectId : Int = 0;
				if (frame.tweenType == null || frame.tweenType == "") {
					for (element in frame.elements) {
						if (Std.is(element, DOMSymbolInstance)) {
							var symbol: DisplayObject = container.getChildByName(cast(element, DOMSymbolInstance).name);
							if (symbol != null) {
								trace("createFrames(): movie clip with name '" + symbol.name + "' already exists");
								continue;
							}
							symbol = Symbols.createSymbol(xfl, cast element);
							if (symbol != null) {
								symbol.visible = false;
								container.addChild(symbol);
							}
						} else 
						if (Std.is(element, DOMBitmapInstance)) {
							var bitmap: Bitmap = Symbols.createBitmap(xfl, cast element);
							if (bitmap != null) {
								bitmap.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
								bitmap.visible = false;
								container.addChild(bitmap);
							}
						} else 
						if (Std.is(element, DOMComponentInstance)) {
							var name: String = cast(element, DOMComponentInstance).name;
							var component: DisplayObject = container.getChildByName(name);
							if (component != null) {
								trace("createFrames(): component with name '" + component.name + "' already exists");
								continue;
							}
							component = Symbols.createComponent(xfl, cast element);
							if (component != null) {
								component.name = component.name;
								component.visible = false;
								container.addChild(component);
							}
						} else 
						if (Std.is(element, DOMShape)) {
							var shape: Shape = Symbols.createShape(xfl, cast element);
							shape.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
							shape.visible = false;
							container.addChild(shape);
						} else 
						if (Std.is(element, DOMRectangle)) {
							var rectangle: Rectangle = Symbols.createRectangle(xfl, cast element);
							rectangle.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
							rectangle.visible = false;
							container.addChild(rectangle);
						} else 
						if (Std.is(element, DOMDynamicText)) {
							var text: DisplayObject = container.getChildByName(cast(element, DOMDynamicText).name);
							if (text != null) {
								trace("createFrames(): dynamic text with name '" + text.name + "' already exists");
								continue;
							}
							text = Symbols.createDynamicText(cast element);
							if (text != null) {
								text.visible = false;
								container.addChild(text);
							}
						} else 
						if (Std.is(element, DOMStaticText)) {
							var text = Symbols.createStaticText(cast element);
							if (text != null) {
								text.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
								text.visible = false;
								container.addChild(text);
							}
						} else {
							trace("createFrames(): Unhandled frame element of type '" + Type.getClassName(Type.getClass(element)) + '"');
						}
					}
				} else 
				if (frame.tweenType == "motion") {
					trace("Tween with type 'motion' not supported.");
				} else 
				if (frame.tweenType == "motion object") {
					trace("Tween with type 'motion object' not supported.");
				}
			}
			currentLayer++;
		}
    }

	public static function disableFrames(xfl: XFL, container: DisplayObjectContainer, layers: Array<DOMLayer>, currentFrame: Int) {
		var currentLayer: Int = 0;
		for (layer in layers) {
			for (frameIdx in 0...layer.frames.length) {
				var frameAnonymousObjectId : Int = 0;
				var frame: DOMFrame = layer.frames[frameIdx];
				if (currentFrame - 1 >= frame.index && currentFrame - 1 < frame.index + frame.duration) {
					if (frame.tweenType == null || frame.tweenType == "") {
						for (element in frame.elements) {
							if (Std.is(element, DOMSymbolInstance)) {
								var movieClip: DisplayObject = container.getChildByName(cast(element, DOMSymbolInstance).name);
								if (movieClip != null && layer.visible == true) {
									movieClip.visible = false;
								}
							} else 
							if (Std.is(element, DOMBitmapInstance)) {
								var bitmap: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (bitmap != null && layer.visible == true) {
									bitmap.visible = false;
								}
							} else 
							if (Std.is(element, DOMComponentInstance)) {
								var component: DisplayObject = container.getChildByName(cast(element, DOMComponentInstance).name);
								if (component != null && layer.visible == true) {
									component.visible = false;
								}
							} else 
							if (Std.is(element, DOMShape)) {
								var shape: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (shape != null && layer.visible == true) {
									shape.visible = false;
								}
							} else 
							if (Std.is(element, DOMRectangle)) {
								var rectangle: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (rectangle != null && layer.visible == true) {
									rectangle.visible = false;
								}
							} else 
							if (Std.is(element, DOMDynamicText)) {
								var text: DisplayObject = container.getChildByName(cast(element, DOMDynamicText).name);
								if (text != null && layer.visible == true) {
									text.visible = false;
								}
							} else 
							if (Std.is(element, DOMStaticText)) {
								var text: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (text != null && layer.visible == true) {
									text.visible  = false;
								}
							} else {
								trace("disableFrames(): Unhandled frame element of type '" + Type.getClassName(Type.getClass(element)) + '"');
							}
						}
					} else 
					if (frame.tweenType == "motion") {
						trace("Tween with type 'motion' not supported.");
					} else 
					if (frame.tweenType == "motion object") {
						trace("Tween with type 'motion object' not supported.");
					}
				}
			}
			currentLayer++;
		}
	}

    public static function enableFrame(xfl: XFL, container: DisplayObjectContainer, layers: Array<DOMLayer>, currentFrame: Int): Void {
		var currentLayer: Int = 0;
		for (layer in layers) {
			for (frameIdx in 0...layer.frames.length) {
				var frameAnonymousObjectId : Int = 0;
				var frame: DOMFrame = layer.frames[frameIdx];
				if (currentFrame - 1 >= frame.index && currentFrame - 1 < frame.index + frame.duration) {
					if (frame.tweenType == null || frame.tweenType == "") {
						for (element in frame.elements) {
							if (Std.is(element, DOMSymbolInstance)) {
								var movieClip: DisplayObject = container.getChildByName(cast(element, DOMSymbolInstance).name);
								if (movieClip != null && layer.visible == true) {
									movieClip.visible = true;
								}
							} else 
							if (Std.is(element, DOMBitmapInstance)) {
								var bitmap: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (bitmap != null && layer.visible == true) {
									bitmap.visible = true;
								}
							} else 
							if (Std.is(element, DOMComponentInstance)) {
								var component: DisplayObject = container.getChildByName(cast(element, DOMComponentInstance).name);
								if (component != null && layer.visible == true) {
									component.visible = true;
								}
							} else 
							if (Std.is(element, DOMShape)) {
								var shape: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (shape != null && layer.visible == true) {
									shape.visible = true;
								}
							} else 
							if (Std.is(element, DOMRectangle)) {
								var rectangle: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (rectangle != null && layer.visible == true) {
									rectangle.visible = true;
								}
							} else 
							if (Std.is(element, DOMDynamicText)) {
								var text: DisplayObject = container.getChildByName(cast(element, DOMDynamicText).name);
								if (text != null && layer.visible == true) {
									text.visible = true;
								}
							} else 
							if (Std.is(element, DOMStaticText)) {
								var text: DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++));
								if (text != null && layer.visible == true) {
									text.visible = true;
								}
							}  else {
								trace("enableFrame(): Unhandled frame element of type '" + Type.getClassName(Type.getClass(element)) + '"');
							}
						}
					} else 
					if (frame.tweenType == "motion") {
						trace("Tween with type 'motion' not supported.");
					} else 
					if (frame.tweenType == "motion object") {
						trace("Tween with type 'motion object' not supported.");
					}
				}
			}
			currentLayer++;
		}
    }

    public static function removeFrames(parent: DisplayObjectContainer) {
        for (i in 0...parent.numChildren) {
            var child: DisplayObject = parent.getChildAt(0);
            if (Std.is(child, MovieClip)) {
                cast(child, MovieClip).stop();
            } else 
            if (Std.is(child, XFLMovieClip)) {
                cast(child, XFLMovieClip).stop();
            }
            parent.removeChildAt(0);
        }
    }
}