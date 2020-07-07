package openfl.controls.listClasses;

import openfl.display.DisplayObject;
import openfl.display.XFLMovieClip;
import openfl.events.MouseEvent;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;

/**
 * Cell Renderer
 */
class CellRenderer extends LabelButton implements ICellRenderer {
	public var listData(get, set):ListData;

	private var _listData:ListData;

	public var data(get, set):Dynamic;

	private var _data:Dynamic;

	/**
	 * Public constructor
	**/
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null) {
		super(name,
			xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.listClasses.CellRenderer"));
		setStyle("upSkin", getXFLElementUntyped("CellRenderer_upSkin"));
		setStyle("disabledSkin", getXFLElementUntyped("CellRenderer_disabledSkin"));
		setStyle("downSkin", getXFLElementUntyped("CellRenderer_downSkin"));
		setStyle("overSkin", getXFLElementUntyped("CellRenderer_overSkin"));
		setStyle("selectedUpSkin", getXFLElementUntyped("CellRenderer_selectedUpSkin"));
		setStyle("selectedDisabledUpSkin", getXFLElementUntyped("CellRenderer_selectedDisabledSkin"));
		setStyle("selectedDownSkin", getXFLElementUntyped("CellRenderer_selectedDownSkin"));
		setStyle("selectedOverSkin", getXFLElementUntyped("CellRenderer_selectedOverSkin"));
	}

	public function init() {
		drawLayout();
		drawBackground();
	}

	public static function createColorSkin(color:Int):XFLMovieClip {
		var skin:XFLMovieClip = new XFLMovieClip();
		skin.graphics.beginFill(color);
		skin.graphics.drawRect(0, 0, 500, 200);
		skin.graphics.endFill();
		return skin;
	}

	private function drawLayout():Void {}

	private function drawBackground():Void {}

	private function get_listData():ListData {
		return _listData;
	}

	private function set_listData(listData:ListData):ListData {
		_listData = listData;
		if (listData.label != null)
			label = listData.label;
		return _listData;
	}

	private function get_data():Dynamic {
		return _data;
	}

	private function set_data(data:Dynamic):Dynamic {
		_data = data;
		return _data;
	}

	public static function getStyleDefinition():Dynamic {
		return null;
	}
}
