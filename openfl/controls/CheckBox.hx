package openfl.controls;

import xfl.XFL;
import xfl.dom.DOMTimeline;
import openfl.controls.LabelButton;
import openfl.display.XFLSprite;
import openfl.text.TextField;
import openfl.events.MouseEvent;

/**
 * CheckBox button
 */
class CheckBox extends LabelButton {

    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreLocked: Bool = false)
    {
        // TODO: clean up group and its radiobuttons if removed
        super(xfl, timeline, parametersAreLocked);
        _selected = false;
        toggle = true;

        setStyle("upIcon", getXFLMovieClip("CheckBox_upIcon"));
        setStyle("overIcon", getXFLMovieClip("CheckBox_overIcon"));
        setStyle("downIcon", getXFLMovieClip("CheckBox_downIcon"));
        setStyle("selectedUpIcon", getXFLMovieClip("CheckBox_selectedUpIcon"));
        setStyle("selectedOverIcon", getXFLMovieClip("CheckBox_selectedOverIcon"));
        setStyle("selectedDownIcon", getXFLMovieClip("CheckBox_selectedDownIcon"));
        setStyle("selectedDisabledIcon", getXFLMovieClip("CheckBox_selectedDisabledIcon"));

        getXFLMovieClip("CheckBox_upIcon").visible = false;
        getXFLMovieClip("CheckBox_overIcon").visible = false;
        getXFLMovieClip("CheckBox_downIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedUpIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedOverIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedDownIcon").visible = false;
        getXFLMovieClip("CheckBox_selectedDisabledIcon").visible = false;

        layoutChildren();

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
