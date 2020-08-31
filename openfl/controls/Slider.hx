package openfl.controls;

import openfl.core.UIComponent;
import openfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.SliderEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;
import xfl.dom.DOMTimeline;

/**
 * Slider
 */
class Slider extends UIComponent {
	public var direction:String;
	public var maximum(default, set):Float = 100.0;
	public var minimum(default, set):Float = 0.0;
	public var value(get, set):Float;
	public var snapInterval(default, set):Float = 1.0;
	public var liveDragging:Bool = false;
	public var tickInterval:Float = 0.0;

	public static var horizontalThumbPadding:Float = 10.0; // TODO: I guess this can be taken from scale9Grid

	private var state:String = "up";
	private var _value:Float = 0.0;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null) {
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.Slider"));
		if (disabled == false) {
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		}

		setStyle("SliderTrack_skin", getXFLMovieClip("SliderTrack_skin"));
		setStyle("SliderTrack_disabledSkin", getXFLMovieClip("SliderTrack_disabledSkin"));
		setStyle("SliderTick_skin", getXFLMovieClip("SliderTick_skin"));
		setStyle("SliderThumb_upSkin", getXFLMovieClip("SliderThumb_upSkin"));
		setStyle("SliderThumb_overSkin", getXFLMovieClip("SliderThumb_overSkin"));
		setStyle("SliderThumb_downSkin", getXFLMovieClip("SliderThumb_downSkin"));
		setStyle("SliderThumb_disabledSkin", getXFLMovieClip("SliderThumb_disabledSkin"));

		cast(getStyle("SliderTrack_skin"), XFLMovieClip).mouseChildren = false;
		cast(getStyle("SliderTrack_skin"), XFLMovieClip).x = 0.0;
		cast(getStyle("SliderTrack_skin"), XFLMovieClip).y = -cast(getStyle("SliderTrack_skin"), XFLMovieClip).height / 2.0;
		cast(getStyle("SliderTrack_skin"), XFLMovieClip).width = width;
		cast(getStyle("SliderTrack_skin"), XFLMovieClip).visible = true;
		cast(getStyle("SliderTrack_disabledSkin"), XFLMovieClip).mouseChildren = false;
		cast(getStyle("SliderTrack_disabledSkin"), XFLMovieClip).x = 0.0;
		cast(getStyle("SliderTrack_disabledSkin"), XFLMovieClip).y = -cast(getStyle("SliderTrack_disabledSkin"), XFLMovieClip).height / 2.0;
		cast(getStyle("SliderTrack_disabledSkin"), XFLMovieClip).width = width;
		cast(getStyle("SliderTrack_disabledSkin"), XFLMovieClip).visible = true;
		cast(getStyle("SliderTick_skin"), XFLMovieClip).mouseChildren = false;
		cast(getStyle("SliderTick_skin"), XFLMovieClip).x = 0.0;
		cast(getStyle("SliderTick_skin"), XFLMovieClip).y = 0.0;
		cast(getStyle("SliderTick_skin"), XFLMovieClip).visible = true;
		cast(getStyle("SliderThumb_upSkin"), XFLMovieClip).visible = true;
		cast(getStyle("SliderThumb_overSkin"), XFLMovieClip).visible = true;
		cast(getStyle("SliderThumb_downSkin"), XFLMovieClip).visible = true;
		cast(getStyle("SliderThumb_disabledSkin"), XFLMovieClip).visible = true;
		addChild(getStyle("SliderTick_skin"));
		setState(disabled == true ? "disabled" : "up");
	}

	override public function setStyle(style:String, value:Dynamic):Void {
		super.setStyle(style, value);
	}

	override public function set_disabled(_disabled:Bool):Bool {
		if (disabled == false) {
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
		}
		super.disabled = _disabled;
		if (_disabled == false) {
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			setState("up");
		} else {
			setState("disabled");
		}
		return super.disabled;
	}

	override public function setSize(_width:Float, _height:Float) {
		super.setSize(_width, _height);
		cast(getStyle("SliderTrack_skin"), XFLMovieClip).width = width;
		cast(getStyle("SliderTrack_disabledSkin"), XFLMovieClip).width = width;
	}

	private function setState(state:String) {
		removeChild(getStyle("SliderTrack_skin"));
		removeChild(getStyle("SliderTrack_disabledSkin"));
		var trackSkin:XFLMovieClip = disabled == false ? getStyle("SliderTrack_skin") : getStyle("SliderTrack_disabledSkin");
		addChild(trackSkin);
		removeChild(getStyle("SliderThumb_" + this.state + "Skin"));
		this.state = state;
		var sliderRange:Float = maximum - minimum;
		addChild(getStyle("SliderThumb_" + this.state + "Skin"));
		getXFLMovieClip("SliderThumb_" + this.state + "Skin").x = horizontalThumbPadding
			+ trackSkin.x
			+ (sliderRange < 0.00001 ? 0.0 : ((value - minimum) / sliderRange) * (trackSkin.width - horizontalThumbPadding * 2.0));
		getXFLMovieClip("SliderThumb_" + this.state + "Skin").visible = true;
		getXFLMovieClip("SliderTick_skin").x = horizontalThumbPadding
			+ trackSkin.x
			+ (((value - minimum) / (maximum - minimum)) * (trackSkin.width - horizontalThumbPadding * 2.0));
		var thumbBounds:Rectangle = getXFLMovieClip("SliderThumb_" + this.state + "Skin").getBounds(null);
		getXFLMovieClip("SliderThumb_" + this.state + "Skin").y = (_height
			- getXFLMovieClip("SliderThumb_" + this.state + "Skin").height) / 2.0
			- thumbBounds.y;
	}

	private function onMouseEvent(event:MouseEvent):Void {
		if (parent == null)
			return;
		var newState:String = "up";
		switch (event.type) {
			case MouseEvent.MOUSE_OVER:
				newState = "over";
			case MouseEvent.MOUSE_DOWN:
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
				newState = "down";
			case MouseEvent.MOUSE_OUT:
				newState = "up";
			default:
				trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
		}
		setState(newState);
	}

	private function onMouseEventMove(event:MouseEvent):Void {
		if (parent == null) {
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
			return;
		}
		switch (event.type) {
			case MouseEvent.MOUSE_UP:
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
				setState("up");
				dispatchEvent(new Event(SliderEvent.THUMB_RELEASE));
			case MouseEvent.MOUSE_MOVE:
				var mouseLocalX:Float = getXFLMovieClip("SliderTrack_skin").globalToLocal(new Point(event.stageX, event.stageY))
					.x * getXFLMovieClip("SliderTrack_skin")
					.scaleX;
				setValueInternal(minimum + ((mouseLocalX / getXFLMovieClip("SliderTrack_skin").width) * (maximum - minimum)), true);
			default:
				trace("onMouseEventMove(): unsupported mouse event type '" + event.type + "'");
		}
	}

	private function set_minimum(newValue:Float):Float {
		minimum = newValue;
		if (minimum > maximum) {
			minimum = maximum;
		}
		if (value < minimum) {
			setValueInternal(minimum, true);
		}
		return minimum;
	}

	private function set_maximum(newValue:Float):Float {
		maximum = newValue;
		if (maximum < minimum) {
			maximum = minimum;
		}
		if (value > maximum) {
			setValueInternal(maximum, true);
		}
		return maximum;
	}

	private function setValueInternal(newValue:Float, dispatchChangeEvent:Bool):Void {
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

	private function get_value():Float {
		return _value;
	}

	private function set_value(newValue:Float):Float {
		setValueInternal(newValue, true);
		return value;
	}

	private function set_snapInterval(newValue:Float):Float {
		if (newValue < 0.001) {
			// trace("set_snapInterval(): invalid value: " + newValue);
		} else {
			snapInterval = newValue;
			setState(state);
		}
		return snapInterval;
	}

	override public function dispose():Void {
		if (_disabled == false) {
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
		}
	}
}
