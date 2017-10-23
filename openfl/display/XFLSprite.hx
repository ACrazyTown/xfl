package openfl.display;

import xfl.XFL;
import xfl.dom.DOMTimeline;
import xfl.symbol.Sprite;
import openfl.controls.Slider;
import openfl.display.XFLElement;
import openfl.text.TextField;

/**
 * XFL XFLSprite
 */
class XFLSprite implements XFLElement extends Sprite {

	private var xflImplementation: XFLImplementation;

    /**
     * Public constructor
     **/
	public function new(xfl: XFL = null, timeline: DOMTimeline = null) {
		super(xfl, timeline);
        xflImplementation = new XFLImplementation(this);
    }

	public function getXFLElementUntyped(name: String) : Dynamic {
		return xflImplementation.getXFLElementUntyped(name);
	}

	public function getXFLElement(name: String) : XFLElement {
		return xflImplementation.getXFLElement(name);
	}

    public function getXFLMovieClip(name: String) : XFLMovieClip {
		return xflImplementation.getXFLMovieClip(name);
	}

    public function getXFLSprite(name: String) : XFLSprite {
		return xflImplementation.getXFLSprite(name);
	}

    public function getXFLDisplayObject(name: String) : DisplayObject {
		return xflImplementation.getXFLDisplayObject(name);
	}

    public function getXFLDisplayObjectContainer(name: String) : DisplayObjectContainer {
		return xflImplementation.getXFLDisplayObjectContainer(name);
	}

    public function getXFLTextField(name: String) : TextField {
		return xflImplementation.getXFLTextField(name);
	}

    public function getXFLSlider(name: String) : Slider {
		return xflImplementation.getXFLSlider(name);
	}

	public function addValue(key: String, value: String) : Void {
		 xflImplementation.addValue(key, value);
	}

	public function getValue(key: String) : String {
		return xflImplementation.getValue(key);
	}

}
