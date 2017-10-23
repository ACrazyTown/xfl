package openfl.controls;

import xfl.XFL;
import xfl.dom.DOMTimeline;
import openfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;

/**
 * Slider
 */
class Slider extends XFLMovieClip {

    public var direction: String;
    public var maximum(default,set) : Float = 100.0;
    public var minimum(default,set) : Float = 0.0;
    public var value(default,set) : Float = 0.0;
    public var snapInterval : Float = 1.0;
    public var liveDragging : Bool = false;
    public var tickInterval: Float = 0.0;
    public var disabled: Bool = false;
    private var mouseDown: Bool = false;

    private var state: String = "up";

    /**
     * Public constructor
     **/
    public function new(xfl: XFL = null, timeline: DOMTimeline = null)
    {
        super(xfl, timeline);
        gotoAndStop(1);
        addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        getXFLDisplayObject("SliderTrack_skin").x = 0.0;
        getXFLDisplayObject("SliderTrack_skin").y = 0.0;
        getXFLDisplayObject("SliderTrack_skin").visible = true;
        getXFLDisplayObject("SliderTick_skin").x = 0.0;
        getXFLDisplayObject("SliderTick_skin").y = 0.0;
        getXFLDisplayObject("SliderTick_skin").visible = true;
        setState(disabled == true?"disabled":"up");
    }

    private function setState(state: String) {
        getXFLDisplayObject("SliderThumb_" + this.state + "Skin").visible = false;
        this.state = state;
        getXFLDisplayObject("SliderThumb_" + this.state + "Skin").x = getXFLDisplayObject("SliderTrack_skin").x + (((value - minimum) / (maximum - minimum)) * getXFLDisplayObject("SliderTrack_skin").width);
        getXFLDisplayObject("SliderThumb_" + this.state + "Skin").y = 0.0;
        getXFLDisplayObject("SliderThumb_" + this.state + "Skin").visible = true;
    }

    private function onMouseEvent(event: MouseEvent) : Void {
        if (disabled == true && state != "disabled") {
            setState("disabled");
            return;
        }
        var newState: String = "up";
        switch(event.type) {
            case MouseEvent.MOUSE_OVER:
                newState = "over";
            case MouseEvent.MOUSE_UP:
                mouseDown = false;
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
                newState = "up";
            case MouseEvent.MOUSE_DOWN:
                mouseDown = true;
                stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
                newState = "down";
        }
        setState(newState);
    }

    private function onMouseEventMove(event: MouseEvent) : Void {
        if (disabled == true) {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
            state = "up";
            return;
        }
        state = "down";
        var localPoint = getXFLDisplayObject("SliderTrack_skin").globalToLocal(new Point(event.stageX, event.stageY));
        value = minimum + ((localPoint.x / getXFLDisplayObject("SliderTrack_skin").width) * (maximum - minimum));
        dispatchEvent(new Event(Event.CHANGE));
    }

    private function set_minimum(newValue: Float): Float {
        minimum = newValue;
        if (value < minimum) {
            value = minimum;
            dispatchEvent(new Event(Event.CHANGE));
        }
        return minimum;
    }

    private function set_maximum(newValue: Float): Float {
        maximum = newValue;
        if (value > maximum) {
            value = maximum;
            dispatchEvent(new Event(Event.CHANGE));
        }
        return maximum;
    }

    private function set_value(newValue: Float): Float {
        var clampedValue = false;
        if (newValue < minimum) {
            newValue = minimum;
            clampedValue = true;
        }
        if (newValue > maximum) {
            newValue = maximum;
            clampedValue = true;
        }
        value = newValue;
        if (clampedValue == true) {
            dispatchEvent(new Event(Event.CHANGE));
        }
        setState(state);
        return value;
    }

}
