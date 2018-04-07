package openfl.controls;

import openfl.core.UIComponent;
import openfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;
import xfl.dom.DOMTimeline;

/**
 * Slider
 */
class Slider extends UIComponent {

    public var direction: String;
    public var maximum(default,set) : Float = 100.0;
    public var minimum(default,set) : Float = 0.0;
    public var value(get,set) : Float;
    public var snapInterval(default, set) : Float = 1.0;
    public var liveDragging : Bool = false;
    public var tickInterval: Float = 0.0;

    private var state: String = "up";
    private var _value: Float = 0.0;

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.Slider"));
        if (disabled == false) {
            addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
        }
        getXFLDisplayObject("SliderTrack_skin").x = 0.0;
        getXFLDisplayObject("SliderTrack_skin").y = 0.0;
        getXFLDisplayObject("SliderTrack_skin").width = width;
        getXFLDisplayObject("SliderTrack_skin").visible = true;
        getXFLDisplayObject("SliderTrack_disabledSkin").x = 0.0;
        getXFLDisplayObject("SliderTrack_disabledSkin").y = 0.0;
        getXFLDisplayObject("SliderTrack_disabledSkin").width = width;
        getXFLDisplayObject("SliderTrack_disabledSkin").visible = false;
        getXFLDisplayObject("SliderTick_skin").x = 0.0;
        getXFLDisplayObject("SliderTick_skin").y = 0.0;
        getXFLDisplayObject("SliderThumb_upSkin").x = 0.0;
        getXFLDisplayObject("SliderThumb_upSkin").y = 0.0;
        getXFLDisplayObject("SliderThumb_overSkin").x = 0.0;
        getXFLDisplayObject("SliderThumb_overSkin").y = 0.0;
        getXFLDisplayObject("SliderThumb_downSkin").x = 0.0;
        getXFLDisplayObject("SliderThumb_downSkin").y = 0.0;
        getXFLDisplayObject("SliderThumb_disabledSkin").x = 0.0;
        getXFLDisplayObject("SliderThumb_disabledSkin").y = 0.0;
        setState(disabled == true?"disabled":"up");
    }

    override public function set_disabled(_disabled: Bool): Bool {
        if (disabled == false) {
            removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
            if (stage != null) stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
            if (stage != null) stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
        }
        if (_disabled == false) {
            addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
            setState("up");
        } else {
            setState("disabled");
        }
        return super.disabled = _disabled;
    }

    override public function setSize(_width: Float, _height: Float) {
        super.setSize(_width, _height);
        getXFLDisplayObject("SliderTrack_skin").width = width;
        getXFLDisplayObject("SliderTrack_disabledSkin").width = width;
    }

    private function setState(state: String) {
        getXFLDisplayObject("SliderThumb_" + this.state + "Skin").visible = false;
        this.state = state;
        var sliderRange: Float = maximum - minimum;
        getXFLDisplayObject("SliderThumb_" + this.state + "Skin").x = getXFLDisplayObject("SliderTrack_skin").x + (sliderRange < 0.00001?0.0:((value - minimum) / sliderRange) * getXFLDisplayObject("SliderTrack_skin").width);
        getXFLDisplayObject("SliderThumb_" + this.state + "Skin").visible = true;
        getXFLDisplayObject("SliderTick_skin").x = getXFLDisplayObject("SliderTrack_skin").x + (((value - minimum) / (maximum - minimum)) * getXFLDisplayObject("SliderTrack_skin").width);
    }

    private function onMouseEvent(event: MouseEvent) : Void {
        var newState: String = "up";
        switch(event.type) {
            case MouseEvent.MOUSE_OVER:
                newState = "over";
            case MouseEvent.MOUSE_DOWN:
                stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
                stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
                newState = "down";
            case MouseEvent.MOUSE_OUT:
                newState = "up";
            default:
                trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
        }
        setState(newState);
    }

    private function onMouseEventMove(event: MouseEvent) : Void {
        switch(event.type) {
            case MouseEvent.MOUSE_UP:
                stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
                setState("up");
            case MouseEvent.MOUSE_MOVE:
                var mouseLocalX: Float = getXFLDisplayObject("SliderTrack_skin").globalToLocal(new Point(event.stageX, event.stageY)).x * getXFLDisplayObject("SliderTrack_skin").scaleX;
                setValueInternal(minimum + ((mouseLocalX / getXFLDisplayObject("SliderTrack_skin").width) * (maximum - minimum)), true);
            default:
                trace("onMouseEventMove(): unsupported mouse event type '" + event.type + "'");
        }
    }

    private function set_minimum(newValue: Float): Float {
        minimum = newValue;
        if (minimum > maximum) {
            minimum = maximum;
        }
        if (value < minimum) {
            setValueInternal(minimum, true);
        }
        return minimum;
    }

    private function set_maximum(newValue: Float): Float {
        maximum = newValue;
        if (maximum < minimum) {
            maximum = minimum;
        }
        if (value > maximum) {
            setValueInternal(maximum, true);
        }
        return maximum;
    }

    private function setValueInternal(newValue: Float, dispatchChangeEvent: Bool): Void {
        _value = Std.int(newValue + (snapInterval / 2.0) * (1.0 / snapInterval)) / snapInterval;
        if (_value < minimum) {
            _value = minimum;
        }
        if (_value > maximum) {
            _value = maximum;
        }
        if (Math.abs(newValue - value) > 0.01 && dispatchChangeEvent == true) {
            dispatchEvent(new Event(Event.CHANGE));
        }
        setState(state);
    }

    private function get_value(): Float {
        return _value;
    }

    private function set_value(newValue: Float): Float {
        setValueInternal(newValue, true);
        return value;
    }

    private function set_snapInterval(newValue: Float): Float {
        if (newValue < 0.001) {
            trace("set_snapInterval(): invalid value: " + newValue);
        } else {
            snapInterval = newValue;
            setState(state);
        }
        return snapInterval;
    }

}
