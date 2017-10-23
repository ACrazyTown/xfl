package openfl.controls.dataGridClasses;

import com.slipshift.engine.helpers.Utils;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;

/**
 *  Public constructor
 */
class HeaderRenderer extends LabelButton {

    public var column: Int;

    private var styleName: String;
    private var styles: Map<String, Dynamic>;

    /**
     * Public constructor
     **/
    public function new()
    {
        super();
        styleName = "upSkin";
        column = -1;
        styles = new Map<String, DisplayObject>();
    }

    public function init() {
        drawLayout();
        drawBackground();
    }

    public function setStyle(key: String, style: Dynamic) {
        styles.set(key, style);
        setMouseState("mouseUp");
    }

    private function drawLayout() : Void
    {
    }
    
    private function drawBackground() : Void
    {
    }

    public static function getStyleDefinition() : Dynamic
    {
        return null;
    }

    public function setMouseState(mouseState: String): Void {
        var style: DisplayObject = null;
        style = styles.get(styleName);
        if (style != null) removeChild(style);
        switch(mouseState) {
            case MouseEvent.MOUSE_OVER:
                styleName = "overSkin";
            case MouseEvent.MOUSE_OUT:
                styleName = "upSkin";
            case MouseEvent.MOUSE_DOWN:
                styleName = "downSkin";
            case MouseEvent.MOUSE_UP:
                styleName = "upSkin";
        }
        style = styles.get(styleName);
        if (style != null) {
            style.x = 0;
            style.y = 0;
            style.width = width;
            style.height = height;
            style.visible = true;
            addChildAt(style, 0);
        }
    }

}
