package openfl.controls;

import xfl.XFLSymbolArguments;
import xfl.XFLAssets;
import xfl.dom.DOMTimeline;
import openfl.controls.LabelButton;
import openfl.display.XFLSprite;
import openfl.text.TextField;
import openfl.events.MouseEvent;

/**
 * CheckBox button
 */
class CheckBox extends LabelButton {

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.CheckBox"));

        _selected = false;
        toggle = true;

        var maxWidth: Float = 0;
        var maxHeight: Float = 0;
        if (getXFLMovieClip("CheckBox_upIcon").width > maxWidth) maxWidth = getXFLMovieClip("CheckBox_upIcon").width;
        if (getXFLMovieClip("CheckBox_overIcon").width > maxWidth) maxWidth = getXFLMovieClip("CheckBox_overIcon").width;
        if (getXFLMovieClip("CheckBox_downIcon").width > maxWidth) maxWidth = getXFLMovieClip("CheckBox_downIcon").width;
        if (getXFLMovieClip("CheckBox_disabledIcon").width > maxWidth) maxWidth = getXFLMovieClip("CheckBox_disabledIcon").width;
        if (getXFLMovieClip("CheckBox_selectedUpIcon").width > maxWidth) maxWidth = getXFLMovieClip("CheckBox_selectedUpIcon").width;
        if (getXFLMovieClip("CheckBox_selectedDownIcon").width > maxWidth) maxWidth = getXFLMovieClip("CheckBox_selectedDownIcon").width;
        if (getXFLMovieClip("CheckBox_selectedDisabledIcon").width > maxWidth) maxWidth = getXFLMovieClip("CheckBox_selectedDisabledIcon").width;

        if (getXFLMovieClip("CheckBox_upIcon").height > maxHeight) maxHeight = getXFLMovieClip("CheckBox_upIcon").height;
        if (getXFLMovieClip("CheckBox_overIcon").height > maxHeight) maxHeight = getXFLMovieClip("CheckBox_overIcon").height;
        if (getXFLMovieClip("CheckBox_downIcon").height > maxHeight) maxHeight = getXFLMovieClip("CheckBox_downIcon").height;
        if (getXFLMovieClip("CheckBox_disabledIcon").height > maxHeight) maxHeight = getXFLMovieClip("CheckBox_disabledIcon").height;
        if (getXFLMovieClip("CheckBox_selectedUpIcon").height > maxHeight) maxHeight = getXFLMovieClip("CheckBox_selectedUpIcon").height;
        if (getXFLMovieClip("CheckBox_selectedDownIcon").height > maxHeight) maxHeight = getXFLMovieClip("CheckBox_selectedDownIcon").height;
        if (getXFLMovieClip("CheckBox_selectedDisabledIcon").height > maxHeight) maxHeight = getXFLMovieClip("CheckBox_selectedDisabledIcon").height;

        setStyle("upIcon", getXFLMovieClip("CheckBox_upIcon"));
        setStyle("overIcon", getXFLMovieClip("CheckBox_overIcon"));
        setStyle("downIcon", getXFLMovieClip("CheckBox_downIcon"));
        setStyle("disabledIcon", getXFLMovieClip("CheckBox_disabledIcon"));
        setStyle("selectedUpIcon", getXFLMovieClip("CheckBox_selectedUpIcon"));
        setStyle("selectedOverIcon", getXFLMovieClip("CheckBox_selectedOverIcon"));
        setStyle("selectedDownIcon", getXFLMovieClip("CheckBox_selectedDownIcon"));
        setStyle("selectedDisabledIcon", getXFLMovieClip("CheckBox_selectedDisabledIcon"));

        getXFLMovieClip("CheckBox_upIcon").visible = false;
        getXFLMovieClip("CheckBox_overIcon").visible = false;
        getXFLMovieClip("CheckBox_downIcon").visible = false;
        getXFLMovieClip("CheckBox_disabledIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedUpIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedOverIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedDownIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedDisabledIcon").visible = false;

        setSize(maxWidth, maxHeight);

        setMouseState("up");
    }

    override public function setSize(_width: Float, _height: Float): Void {
        super.setSize(_width, _height);
        layoutChildren();
    }

    private function layoutChildren() {
        getXFLMovieClip("CheckBox_upIcon").x = 0.0;
        getXFLMovieClip("CheckBox_upIcon").y = (height - getXFLMovieClip("CheckBox_upIcon").height) / 2;
        getXFLMovieClip("CheckBox_overIcon").x = 0.0;
        getXFLMovieClip("CheckBox_overIcon").y = (height - getXFLMovieClip("CheckBox_overIcon").height) / 2;
        getXFLMovieClip("CheckBox_downIcon").x = 0.0;
        getXFLMovieClip("CheckBox_downIcon").y = (height - getXFLMovieClip("CheckBox_downIcon").height) / 2;
        getXFLMovieClip("CheckBox_disabledIcon").x = 0.0;
        getXFLMovieClip("CheckBox_disabledIcon").y = (height - getXFLMovieClip("CheckBox_disabledIcon").height) / 2;
        getXFLMovieClip("CheckBox_selectedUpIcon").x = 0.0;
        getXFLMovieClip("CheckBox_selectedUpIcon").y = (height - getXFLMovieClip("CheckBox_selectedUpIcon").height) / 2;
        getXFLMovieClip("CheckBox_selectedOverIcon").x = 0.0;
        getXFLMovieClip("CheckBox_selectedOverIcon").y = (height - getXFLMovieClip("CheckBox_selectedOverIcon").height) / 2;
        getXFLMovieClip("CheckBox_selectedDownIcon").x = 0.0;
        getXFLMovieClip("CheckBox_selectedDownIcon").y = (height - getXFLMovieClip("CheckBox_selectedDownIcon").height) / 2;
        getXFLMovieClip("CheckBox_selectedDisabledIcon").x = 0.0; 
        getXFLMovieClip("CheckBox_selectedDisabledIcon").y = (height - getXFLMovieClip("CheckBox_selectedDisabledIcon").height) / 2;
    }

}
