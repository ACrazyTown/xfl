package openfl.controls;

import xfl.XFL;
import xfl.XFLAssets;
import openfl.core.UIComponent;
import openfl.controls.SelectableList;

/**
 * List
 */
class List extends SelectableList {

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.List"));
    }

}
