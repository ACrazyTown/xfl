package openfl.controls;

import xfl.XFL;
import xfl.dom.DOMTimeline;
import openfl.controls.LabelButton;
import openfl.display.XFLSprite;
import openfl.text.TextField;
import openfl.events.MouseEvent;

/**
 * Radio button
 */
class RadioButton extends LabelButton {

    private static var groups: Map<String, Array<RadioButton>> = new Map<String, Array<RadioButton>>();

    public var groupName(get, set): String;

    private var _groupName: String;

    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreLocked: Bool = false)
    {
        // TODO: clean up group and its radiobuttons if removed
        super(xfl, timeline, parametersAreLocked);
        _selected = false;
        toggle = true;

        setStyle("upIcon", getXFLMovieClip("RadioButton_upIcon"));
        setStyle("overIcon", getXFLMovieClip("RadioButton_overIcon"));
        setStyle("downIcon", getXFLMovieClip("RadioButton_downIcon"));
        setStyle("selectedUpIcon", getXFLMovieClip("RadioButton_selectedUpIcon"));
        setStyle("selectedOverIcon", getXFLMovieClip("RadioButton_selectedOverIcon"));
        setStyle("selectedDownIcon", getXFLMovieClip("RadioButton_selectedDownIcon"));
        setStyle("selectedDisabledIcon", getXFLMovieClip("RadioButton_selectedDisabledIcon"));

        getXFLMovieClip("RadioButton_upIcon").visible = false;
        getXFLMovieClip("RadioButton_overIcon").visible = false;
        getXFLMovieClip("RadioButton_downIcon").visible = false;
        getXFLMovieClip("RadioButton_selectedUpIcon").visible = false;
        getXFLMovieClip("RadioButton_selectedOverIcon").visible = false;
        getXFLMovieClip("RadioButton_selectedDownIcon").visible = false;
        getXFLMovieClip("RadioButton_selectedDisabledIcon").visible = false;

        layoutChildren();

        setMouseState("up");
    }

    private function get_groupName(): String {
        return _groupName;
    }

    private function set_groupName(_groupName: String): String {
        var group: Array<RadioButton> = RadioButton.groups.get(this._groupName);
        if (group != null) group.remove(this);
        this._groupName = _groupName;
        var group: Array<RadioButton> = RadioButton.groups.get(this._groupName);
        if (group == null) {
            RadioButton.groups.set(this._groupName, [this]);
        } else {
            group.push(this);
        }
        return this._groupName;
    }

    override private function set_selected(selected: Bool): Bool {
        var group: Array<RadioButton> = RadioButton.groups.get(this._groupName);
        if (group != null) {
            for (radioButton in group) {
                if (radioButton == this) continue;
                radioButton.setLabelButtonSelected(false);
            }
        }
        setLabelButtonSelected(selected);
        return _selected;
    }

    private function setLabelButtonSelected(selected: Bool): Void {
        super.selected = selected;
    }

    override private function onMouseEvent(event: MouseEvent): Void {
        switch(event.type) {
            case MouseEvent.MOUSE_OVER:
                setMouseState("over");
            case MouseEvent.MOUSE_OUT:
                setMouseState("up");
            case MouseEvent.MOUSE_UP:
                var group: Array<RadioButton> = RadioButton.groups.get(this._groupName);
                if (group != null) {
                    for (radioButton in group) {
                        if (radioButton == this) continue;
                        radioButton.selected = false;
                    }
                }
                setLabelButtonSelected(true);
                setMouseState("up");
            case MouseEvent.MOUSE_DOWN:
                setMouseState("down");
            default:
                trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
        }
    }

    override public function setSize(_width: Float, _height: Float): Void {
        super.setSize(_width, _height);
        layoutChildren();
    }

    private function layoutChildren() {
        getXFLMovieClip("RadioButton_upIcon").x = 0.0;
        getXFLMovieClip("RadioButton_upIcon").y = (height - getXFLMovieClip("RadioButton_upIcon").height) / 2;
        getXFLMovieClip("RadioButton_overIcon").x = 0.0;
        getXFLMovieClip("RadioButton_overIcon").y = (height - getXFLMovieClip("RadioButton_overIcon").height) / 2;
        getXFLMovieClip("RadioButton_downIcon").x = 0.0;
        getXFLMovieClip("RadioButton_downIcon").y = (height - getXFLMovieClip("RadioButton_downIcon").height) / 2;
        getXFLMovieClip("RadioButton_selectedUpIcon").x = 0.0;
        getXFLMovieClip("RadioButton_selectedUpIcon").y = (height - getXFLMovieClip("RadioButton_selectedUpIcon").height) / 2;
        getXFLMovieClip("RadioButton_selectedOverIcon").x = 0.0;
        getXFLMovieClip("RadioButton_selectedOverIcon").y = (height - getXFLMovieClip("RadioButton_selectedOverIcon").height) / 2;
        getXFLMovieClip("RadioButton_selectedDownIcon").x = 0.0;
        getXFLMovieClip("RadioButton_selectedDownIcon").y = (height - getXFLMovieClip("RadioButton_selectedDownIcon").height) / 2;
        getXFLMovieClip("RadioButton_selectedDisabledIcon").x = 0.0; 
        getXFLMovieClip("RadioButton_selectedDisabledIcon").y = (height - getXFLMovieClip("RadioButton_selectedDisabledIcon").height) / 2;
    }

}
