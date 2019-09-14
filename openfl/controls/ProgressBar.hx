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
 * Progress Bar
 */
class ProgressBar extends UIComponent {

    public var direction: String;
    public var maximum(default,set) : Float = 100.0;
    public var minimum(default,set) : Float = 0.0;
    public var value(get,set) : Float;

    private var _value: Float = 0.0;

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.ProgessBar"));
        getXFLDisplayObject("ProgressBar_trackSkin").x = 0.0;
        getXFLDisplayObject("ProgressBar_trackSkin").y = 0.0;
        getXFLDisplayObject("ProgressBar_trackSkin").width = width;
        getXFLDisplayObject("ProgressBar_trackSkin").visible = true;
        getXFLDisplayObject("ProgressBar_barSkin").x = (getXFLDisplayObject("ProgressBar_trackSkin").width - getXFLDisplayObject("ProgressBar_barSkin").width) / 2.0;
        getXFLDisplayObject("ProgressBar_barSkin").y = (getXFLDisplayObject("ProgressBar_trackSkin").height - getXFLDisplayObject("ProgressBar_barSkin").height) / 2.0;
        getXFLDisplayObject("ProgressBar_barSkin").width = 0.0;
        getXFLDisplayObject("ProgressBar_barSkin").visible = true;
        getXFLDisplayObject("ProgressBar_indeterminateSkin").x = 1.0;
        getXFLDisplayObject("ProgressBar_indeterminateSkin").y = 1.0;
        getXFLDisplayObject("ProgressBar_indeterminateSkin").width = 0.0;
        getXFLDisplayObject("ProgressBar_indeterminateSkin").height = getXFLDisplayObject("ProgressBar_trackSkin").height - 2.0;
        getXFLDisplayObject("ProgressBar_indeterminateSkin").visible = true;
        updateBar();
    }

    override public function setSize(_width: Float, _height: Float) {
        super.setSize(_width, _height);
        getXFLDisplayObject("ProgressBar_trackSkin").width = width;
        updateBar();
    }

    private function updateBar() {
        var barRange: Float = maximum - minimum;
        var barWidth: Float = (barRange < 0.00001?0.0:((value - minimum) / barRange) * getXFLDisplayObject("ProgressBar_trackSkin").width);
        if (barWidth < 0.00001) {
            getXFLDisplayObject("ProgressBar_barSkin").width = 0.0;
        } else {
            getXFLDisplayObject("ProgressBar_barSkin").width = 
                getXFLDisplayObject("ProgressBar_barSkin").scale9Grid != null && barWidth < getXFLDisplayObject("ProgressBar_barSkin").scale9Grid.left?
                getXFLDisplayObject("ProgressBar_barSkin").scale9Grid.left:
                barWidth;
        }
        getXFLDisplayObject("ProgressBar_indeterminateSkin").width = barWidth - 2.0;
    }

    private function set_minimum(newValue: Float): Float {
        minimum = newValue;
        if (minimum > maximum) {
            minimum = maximum;
        }
        if (value < minimum) {
            setValueInternal(minimum);
        }
        return minimum;
    }

    private function set_maximum(newValue: Float): Float {
        maximum = newValue;
        if (maximum < minimum) {
            maximum = minimum;
        }
        if (value > maximum) {
            setValueInternal(maximum);
        }
        return maximum;
    }

    private function setValueInternal(newValue: Float): Void {
        _value = newValue;
        if (_value < minimum) {
            _value = minimum;
        }
        if (_value > maximum) {
            _value = maximum;
        }
        if (Math.abs(newValue - value) > 0.01) {
            // progres has changed
        }
        updateBar();
    }

    private function get_value(): Float {
        return _value;
    }

    private function set_value(newValue: Float): Float {
        setValueInternal(newValue);
        return value;
    }

}
