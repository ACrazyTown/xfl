package openfl.display;

import openfl.controls.Slider;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.text.TextField;

/**
 * XFL element
 */
interface XFLElement {

    // display object container
    public function addChild (child:DisplayObject):DisplayObject;

    // XFL elements
    public function getXFLElementUntyped(name: String) : Dynamic;
    public function getXFLElement(name: String) : XFLElement;
    public function getXFLMovieClip(name: String) : XFLMovieClip;
    public function getXFLSprite(name: String) : XFLSprite;
    public function getXFLDisplayObject(name: String) : DisplayObject;
    public function getXFLDisplayObjectContainer(name: String) : DisplayObjectContainer;
    public function getXFLTextField(name: String) : TextField;
    public function getXFLSlider(name: String) : Slider;

    // values
    public function addValue(key: String, value: String): Void;
    public function getValue(key: String) : String;

}
