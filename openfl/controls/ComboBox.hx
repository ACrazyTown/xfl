package openfl.controls;

import xfl.XFL;
import xfl.dom.DOMTimeline;
import openfl.core.UIComponent;
import openfl.data.DataProvider;
import openfl.display.XFLSprite;

/**
 * Combo box grid
 */
class ComboBox extends UIComponent {

    public var selectedIndex: Int;
    public var dataProvider: DataProvider;
    public var selectedItem: Dynamic;

    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreLocked: Bool = false)
    {
        super(xfl, timeline, parametersAreLocked);
    }

    public function move(x: Int, y: Int): Void {
    }

}
