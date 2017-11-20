package openfl.display;

import openfl.controls.Slider;
import openfl.controls.TextArea;
import openfl.events.Event;
import openfl.text.TextField;

class XFLImplementation {

    private var container: Sprite;
	private var values: Map<String, String>;
	private var tweens: Array<Dynamic>;

    public function new(container: Sprite) {
        this.container = container;
	    values = new Map<String, String>();
	    tweens = new Array<Dynamic>();
    }

	public function getXFLElementUntyped(name: String) : Dynamic {
		var fullName: String = "";
		var parentDisplayObjectContainer: DisplayObjectContainer = container.parent;
		while (parentDisplayObjectContainer != null) {
			fullName = parentDisplayObjectContainer.name + "." + fullName;
			parentDisplayObjectContainer = parentDisplayObjectContainer.parent;
		}
		var element : Dynamic = container.getChildByName(name);
		if (element == null) {
			trace("Getting XFL element: '" + fullName + name + "', NOT found!");
		}
		return element;
	}

	public function getXFLElement(name: String) : XFLElement {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, XFLElement);
		return null;
	}

    public function getXFLMovieClip(name: String) : XFLMovieClip {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, XFLMovieClip);
		return null;
	}

    public function getXFLSprite(name: String) : XFLSprite {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, XFLSprite);
		return null;
	}

    public function getXFLDisplayObject(name: String) : DisplayObject {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, DisplayObject);
		return null;
	}

    public function getXFLDisplayObjectContainer(name: String) : DisplayObjectContainer {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, DisplayObjectContainer);
		return null;
	}

    public function getXFLTextField(name: String) : TextField {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, TextField);
		return null;
	}

    public function getXFLTextArea(name: String) : TextField {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, TextArea);
		return null;
	}

    public function getXFLSlider(name: String) : Slider {
		var element: Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, Slider);
		return null;
	}

	public function addValue(key: String, value: String) : Void {
		values[key] = value;
	}

	public function getValue(key: String) : String {
		return values[key];
	}

}
