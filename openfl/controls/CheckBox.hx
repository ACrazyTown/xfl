package openfl.controls;

import com.slipshift.engine.helpers.Utils;
import openfl.core.UIComponent;
import openfl.display.XFLSprite;
import openfl.text.TextField;
import xfl.XFL;
import xfl.dom.DOMTimeline;

/**
 * Check box
 */
class CheckBox extends UIComponent {

    public var label: String;
    public var textField: TextField;
    public var selected: Bool;

    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreLocked: Bool = false)
    {
        super(xfl, timeline, parametersAreLocked);
        trace("CheckBox::new()");
        Utils.dumpDisplayObject(this);
    }

}
