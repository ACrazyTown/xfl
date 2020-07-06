package xfl;

import openfl.core.UIComponent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.XFLElement;
import openfl.display.XFLMovieClip;
import openfl.display.Shape;

class Utils {
	/**
	 * Completely clears a display object and its references
	 */
	public static function disposeDisplayObject(displayObject:DisplayObject, removeFromParent:Bool = false):Void {
		if (displayObject == null)
			return;
		// trace("disposeDisplayObject(): " + displayObject.name);

		// dispose UI components
		if (Std.is(displayObject, UIComponent) == true) {
			cast(displayObject, UIComponent).dispose();
		}

		// remove from parent
		if (removeFromParent == true && displayObject.parent != null) {
			displayObject.parent.removeChild(displayObject);
		}

		// unset mask, if we have any
		var displayObjectMask:DisplayObject = displayObject.mask;
		if (displayObjectMask != null) {
			displayObject.mask = null;
			// dispose if graphics
			if (Std.is(displayObjectMask, Shape) == true) {
				cast(displayObjectMask, Shape).graphics.clear();
			} else
				// and dispose if bitmap
				if (Std.is(displayObjectMask, Bitmap) == true && cast(displayObjectMask, Bitmap).bitmapData != null) {
					cast(displayObjectMask, Bitmap).bitmapData.dispose();
					cast(displayObjectMask, Bitmap).bitmapData = null;
				} else
					// dispose hierarchy if display object container
					if (Std.is(displayObjectMask, DisplayObjectContainer) == true) {
						disposeDisplayObject(displayObjectMask);
					}
		}

		// clear graphics
		if (Std.is(displayObject, Shape)) {
			cast(displayObject, Shape).graphics.clear();
		} else
			// dispose bitmap data if displayobject is bitmap
			if (Std.is(displayObject, Bitmap) && cast(displayObject, Bitmap).bitmapData != null) {
				// trace("disposeDisplayObject(): disposing bitmap data: " + child.name);
				cast(displayObject, Bitmap).bitmapData.dispose();
				cast(displayObject, Bitmap).bitmapData = null;
			} else
				// if its a display object container, dispose childs
				if (Std.is(displayObject, DisplayObjectContainer)) {
					var container:DisplayObjectContainer = cast(displayObject, DisplayObjectContainer);
					for (i in 0...container.numChildren)
						disposeDisplayObject(container.getChildAt(i), false);
					container.removeChildren();
				}
	}

	public static function dumpDisplayObjectParents(object:DisplayObject) {
		dumpDisplayObject(object, 1, 1, 0);
		var parent:DisplayObjectContainer = object.parent;
		while (parent != null) {
			dumpDisplayObject(parent, 1, 1, 0);
			parent = parent.parent;
		}
	}

	public static function dumpDisplayObject(object:DisplayObject, maxDepth:Int = 0, depth:Int = 0, indent:Int = 0) {
		if (object == null) {
			trace("dumpDisplayObject(): object == null");
			return;
		}
		var indentionString:String = "";
		for (i in 0...indent) {
			indentionString += " ";
		}
		trace(indentionString
			+ object.name
			+ ":"
			+ object.x
			+ ", "
			+ object.y
			+ ", "
			+ object.width
			+ ", "
			+ object.height
			+ ", "
			+ object.scaleX
			+ ", "
			+ object.scaleY
			+ ", "
			+ object.alpha
			+ ", "
			+ object.getBounds(null)
			+ ", "
			+ object.opaqueBackground
			+ ", "
			+ object.transform.colorTransform
			+ ", "
			+ object.transform.matrix
			+ ", "
			+ object.filters
			+ ", "
			+ (object.visible == true ? "visible" : "unvisible")
			+ ", "
			+ (object.mask != null ? "mask" : "nomask")
			+ (Std.is(object,
				DisplayObjectContainer) == true ? (cast(object, DisplayObjectContainer).mouseEnabled == true ? ", mouse enabled" : ", mouse disabled") : "")
			+ (Std.is(object,
				DisplayObjectContainer) == true ? (cast(object, DisplayObjectContainer)
					.mouseChildren == true ? ", mouse children enabled" : ", mouse children disabled") : "")
			+ (Std.is(object, Sprite) == true ? (cast(object, Sprite).buttonMode == true ? ", button mode enabled" : ", button mode disabled") : "")
			+ "("
			+ Type.getClassName(Type.getClass(object))
			+ ")");
		if ((maxDepth == 0 || depth < maxDepth) && Std.is(object, DisplayObjectContainer) == true) {
			var container:DisplayObjectContainer = cast(object, DisplayObjectContainer);
			for (i in 0...container.numChildren) {
				dumpDisplayObject(container.getChildAt(i), maxDepth, depth + 1, indent + 2);
			}
		}
	}
}
