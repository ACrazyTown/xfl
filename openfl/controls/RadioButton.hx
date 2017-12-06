package openfl.controls;

import com.slipshift.engine.helpers.Utils;
import xfl.XFL;
import xfl.dom.DOMTimeline;
import openfl.core.UIComponent;
import openfl.display.XFLSprite;
import openfl.text.TextField;
import openfl.events.MouseEvent;

/**
 * Radio button
 */
class RadioButton extends UIComponent {

    private static var groups: Map<String, Array<RadioButton>> = new Map<String, Array<RadioButton>>();

    public var groupName(get, set): String;
    public var label(get, set): String;
    public var labelPlacement(get, set): String;

    public var selected(get, set): Bool;

    private var _groupName: String;
    private var _label: String;
    private var _labelPlacement: String;

    private var _selected: Bool;
    private var state: String;

    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreLocked: Bool = false)
    {
        // TODO: clean up group and its radiobuttons if removed
        super(xfl, timeline, parametersAreLocked);
        _selected = false;
        state = "up";

        getXFLMovieClip("RadioButton_upIcon").visible = false;
        getXFLMovieClip("RadioButton_upIcon").mouseChildren = false;
        getXFLMovieClip("RadioButton_overIcon").visible = false;
        getXFLMovieClip("RadioButton_overIcon").mouseChildren = false;
        getXFLMovieClip("RadioButton_downIcon").visible = false;
        getXFLMovieClip("RadioButton_downIcon").mouseChildren = false;
        getXFLMovieClip("RadioButton_selectedUpIcon").visible = false;
        getXFLMovieClip("RadioButton_selectedUpIcon").mouseChildren = false;
        getXFLMovieClip("RadioButton_selectedOverIcon").visible = false;
        getXFLMovieClip("RadioButton_selectedOverIcon").mouseChildren = false;
        getXFLMovieClip("RadioButton_selectedDownIcon").visible = false;
        getXFLMovieClip("RadioButton_selectedDownIcon").mouseChildren = false;
        getXFLMovieClip("RadioButton_selectedDisabledIcon").visible = false;

        getXFLMovieClip("RadioButton_upIcon").addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        getXFLMovieClip("RadioButton_upIcon").addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        getXFLMovieClip("RadioButton_upIcon").addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        getXFLMovieClip("RadioButton_overIcon").addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        getXFLMovieClip("RadioButton_overIcon").addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        getXFLMovieClip("RadioButton_overIcon").addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        getXFLMovieClip("RadioButton_downIcon").addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        getXFLMovieClip("RadioButton_downIcon").addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        getXFLMovieClip("RadioButton_downIcon").addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedUpIcon").addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedUpIcon").addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedUpIcon").addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedOverIcon").addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedOverIcon").addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedOverIcon").addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedDownIcon").addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedDownIcon").addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        getXFLMovieClip("RadioButton_selectedDownIcon").addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);

        layoutChildren();

        setState(state);
    }

    private function get_groupName(): String {
        return _groupName;
    }

    private function set_groupName(_groupName: String): String {
        var group: Array<RadioButton> = groups.get(this._groupName);
        if (group != null) group.remove(this);
        this._groupName = _groupName;
        var group: Array<RadioButton> = groups.get(this._groupName);
        if (group == null) {
            groups.set(this._groupName, [this]);
        } else {
            group.push(this);
        }
        return this._groupName;
    }

    private function get_label(): String {
        return _label;
    }

    private function set_label(_label: String): String {
        return this._label = _label;
    }

    private function get_labelPlacement(): String {
        return this._labelPlacement;
    }

    private function set_labelPlacement(_labelPlacement: String): String {
        return this._labelPlacement = _labelPlacement;
    }

    private function setState(newState: String): Void {
        getXFLMovieClip("RadioButton_" + (_selected == true?"selected" + state.charAt(0).toUpperCase() + state.substr(1).toLowerCase():state) + "Icon").visible = false;
        state = newState;
        getXFLMovieClip("RadioButton_" + (_selected == true?"selected" + state.charAt(0).toUpperCase() + state.substr(1).toLowerCase():state) + "Icon").visible = true;
    }

    private function get_selected(): Bool {
        return _selected;
    }

    private function set_selected(selected: Bool): Bool {
        var group: Array<RadioButton> = groups.get(this._groupName);
        if (group != null) {
            for (radioButton in group) {
                if (radioButton == this) continue;
                radioButton.selected = false;
            }
        }
        getXFLMovieClip("RadioButton_" + (_selected == true?"selected" + state.charAt(0).toUpperCase() + state.substr(1).toLowerCase():state) + "Icon").visible = false;
        _selected = selected;
        getXFLMovieClip("RadioButton_" + (_selected == true?"selected" + state.charAt(0).toUpperCase() + state.substr(1).toLowerCase():state) + "Icon").visible = true;
        return _selected;
    }

    private function onMouseEvent(event: MouseEvent): Void {
        switch(event.type) {
            case MouseEvent.MOUSE_OVER:
                setState("over");
            case MouseEvent.MOUSE_UP:
                var group: Array<RadioButton> = groups.get(this._groupName);
                if (group != null) {
                    for (radioButton in group) {
                        if (radioButton == this) continue;
                        radioButton.selected = false;
                    }
                }
                getXFLMovieClip("RadioButton_" + (_selected == true?"selected" + state.charAt(0).toUpperCase() + state.substr(1).toLowerCase():state) + "Icon").visible = false;
                _selected = true;
                getXFLMovieClip("RadioButton_" + (_selected == true?"selected" + state.charAt(0).toUpperCase() + state.substr(1).toLowerCase():state) + "Icon").visible = true;
            case MouseEvent.MOUSE_DOWN:
                setState("down");
            default:
                trace("onScrollArrowMouseEvent(): unsupported mouse event type '" + event.type + "'");
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
