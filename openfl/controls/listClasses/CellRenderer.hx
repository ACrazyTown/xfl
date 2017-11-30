package openfl.controls.listClasses;

import openfl.display.DisplayObject;
import openfl.display.XFLMovieClip;
import openfl.events.MouseEvent;
import com.slipshift.engine.helpers.Utils;

/**
 * Cell Renderer
 */
class CellRenderer extends LabelButton implements ICellRenderer {

    public var listData(get, set): ListData;
    private var _listData: ListData;

    public var data(get, set): Dynamic;
    private var _data: Dynamic;

    private var styleName: String;
    private var styles: Map<String, Dynamic>;
    private var appliedStyle: Dynamic;

    /**
     * Public constructor
     **/
    public function new()
    {
        super();
        styleName = "upSkin";
        styles = new Map<String, DisplayObject>();
        appliedStyle = null;
    }

    public function init() {
        drawLayout();
        drawBackground();
    }

    override public function setStyle(key: String, style: Dynamic) : Void {
        if (Std.is(style, DisplayObject) == true) {
            var displayObject: DisplayObject = cast(style, DisplayObject);
            displayObject.x = 0.0;
            displayObject.y = 0.0;
            displayObject.width = width;
            displayObject.height = height;
        }
        styles.set(key, style);
        if (key == styleName) applyStyle(styleName);
    }

    public static function createColorSkin(color : Int) : XFLMovieClip
    {
        var skin : XFLMovieClip = new XFLMovieClip();
        skin.graphics.beginFill(color);
        skin.graphics.drawRect(0, 0, 500, 200);
        skin.graphics.endFill();
        return skin;
    }

    private function drawLayout(): Void {
    }

    private function drawBackground(): Void {
    }

    private function get_listData(): ListData {
        return _listData;
    }

    private function set_listData(listData: ListData): ListData {
        _listData = listData;
        return _listData;
    }

    private function get_data(): Dynamic {
        return _data;
    }

    private function set_data(data: Dynamic): Dynamic {
        _data = data;
        return _data;
    }

    public static function getStyleDefinition() : Dynamic
    {
        return null;
    }

    private function applyStyle(newStyleName: String) {
        if (appliedStyle != null) {
            removeChild(appliedStyle);
            appliedStyle = null;
        }
        styleName = newStyleName;
        var style: DisplayObject = cast(styles.get(styleName), DisplayObject);
        if (style != null) {
            style.x = 0;
            style.y = 0;
            style.width = width;
            style.height = height;
            style.visible = true;
            addChildAt(style, 0);
            appliedStyle = style;
        }
    }

    public function setMouseState(mouseState: String): Void {
        var newStyleName: String = null;
        switch(mouseState) {
            case MouseEvent.MOUSE_OVER:
                newStyleName = "overSkin";
            case MouseEvent.MOUSE_OUT:
                newStyleName = "upSkin";
            case MouseEvent.MOUSE_DOWN:
                newStyleName = "downSkin";
            case MouseEvent.MOUSE_UP:
                newStyleName = "upSkin";
        }
        applyStyle(newStyleName);
    }

}
