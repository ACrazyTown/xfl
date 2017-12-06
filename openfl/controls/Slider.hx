package openfl.controls;

import openfl.core.UIComponent;
import openfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import xfl.XFL;
import xfl.dom.DOMTimeline;

/**
 * Slider
 */
class Slider extends UIComponent {

    public var direction: String;
    public var maximum(default,set) : Float = 100.0;
    public var minimum(default,set) : Float = 0.0;
    public var value(default,set) : Float = 0.0;
    public var snapInterval : Float = 1.0;
    public var liveDragging : Bool = false;
    public var tickInterval: Float = 0.0;

    private var state: String = "up";

    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreLocked: Bool = false)
    {
        super(xfl, timeline, parametersAreLocked);
        addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
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
            case MouseEvent.MOUSE_DOWN:
                stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
                stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
                newState = "down";
            default:
                trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
        }
        setState(newState);
    }

    private function onMouseEventMove(event: MouseEvent) : Void {
        if (disabled == true) {
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
            state = "up";
            return;
        }
        switch(event.type) {
            case MouseEvent.MOUSE_UP:
                stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
                state = "up";
            case MouseEvent.MOUSE_MOVE:
                var localPoint: Point = getXFLDisplayObject("SliderTrack_skin").globalToLocal(new Point(event.stageX, event.stageY));
                value = minimum + ((localPoint.x / getXFLDisplayObject("SliderTrack_skin").width) * (maximum - minimum));
                dispatchEvent(new Event(Event.CHANGE));
            default:
                trace("onMouseEventMove(): unsupported mouse event type '" + event.type + "'");
        }
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
