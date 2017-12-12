package openfl.controls;

import com.slipshift.engine.helpers.Utils;
import xfl.XFL;
import xfl.XFLAssets;
import openfl.core.UIComponent;

/**
 * List
 */
class List extends UIComponent {

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.List"));
        trace("aaa:");
        Utils.dumpDisplayObject(this);
        layoutChildren();
    }

    override public function setSize(_width: Float, _height: Float): Void {
        super.setSize(_width, _height);
        layoutChildren();
    }

    private function layoutChildren() {
    }

}
