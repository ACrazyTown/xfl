package openfl.controls;

import xfl.XFL;
import xfl.XFLAssets;
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

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.ComboBox"));
    }

    public function move(x: Int, y: Int): Void {
    }

}
