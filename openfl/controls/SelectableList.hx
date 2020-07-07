package openfl.controls;

import openfl.containers.BaseScrollPane;
import openfl.controls.listClasses.CellRenderer;
import openfl.controls.listClasses.ListData;
import openfl.core.UIComponent;
import openfl.data.DataProvider;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;

/**
 * Selectable list
 */
class SelectableList extends BaseScrollPane {
	public var dataProvider(get, set):DataProvider;
	public var selectable(get, set):Bool;
	public var selectedIndex(get, set):Int;

	private var _dataProvider:DataProvider;
	private var _selectable:Bool;
	private var _selectedIndex:Int;
	private var _container:Sprite;
	private var _cellRenderers:Array<CellRenderer>;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null) {
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.List"));
		removeChild(getXFLMovieClip("List_skin"));
		_cellRenderers = [];
		selectable = true;
		_selectedIndex = -1;
		selectedIndex = 0;
		_container = new Sprite();
		source = _container;
		setStyle("cellRenderer", getXFLElementUntyped("CellRenderer"));
		layoutChildren();
	}

	private function get_dataProvider():DataProvider {
		return _dataProvider;
	}

	private function set_dataProvider(dataProvider:DataProvider):DataProvider {
		_dataProvider = dataProvider;
		draw();
		return _dataProvider;
	}

	private function get_selectable():Bool {
		return _selectable;
	}

	private function set_selectable(value:Bool):Bool {
		if (value == _selectable)
			return value;
		if (value == false)
			selectedIndex = -1;
		return _selectable = value;
	}

	private function get_selectedIndex():Int {
		return _selectedIndex;
	}

	private function set_selectedIndex(value:Int):Int {
		if (_selectable == false)
			return -1;
		if (_cellRenderers.length == 0)
			return -1;
		if (_selectedIndex != -1)
			_cellRenderers[_selectedIndex].selected = false;
		_selectedIndex = value;
		if (_selectedIndex != -1)
			_cellRenderers[_selectedIndex].selected = true;
		return _selectedIndex;
	}

	override private function draw() {
		super.draw();
		for (cellRenderer in _cellRenderers) {
			cellRenderer.removeEventListener(Event.CHANGE, onCellRendererChange);
			cellRenderer.dispose();
			_container.removeChild(cellRenderer);
		}
		_cellRenderers = [];
		if (_dataProvider == null)
			return;
		var cellRendererHeight:Float = cast(cast(getStyle("cellRenderer"), UIComponent).getStyle("upSkin"), DisplayObject).getBounds(null).height;
		var cellRendererY:Float = 0.0;
		var idx:Int = 0;
		for (i in 0..._dataProvider.length) {
			var cellRenderer:CellRenderer = new CellRenderer();
			cellRenderer.toggle = true;
			cellRenderer.listData = new ListData(0, null, idx, _dataProvider.getItemAt(i).label, this, idx);
			cellRenderer.y = cellRendererY;
			cellRenderer.setSize(_width, cellRendererHeight);
			cellRenderer.addEventListener(Event.CHANGE, onCellRendererChange);
			_container.addChild(cellRenderer);
			_cellRenderers.push(cellRenderer);
			cellRendererY += cellRendererHeight;
			idx++;
		}
		selectedIndex = _selectedIndex;
		update();
	}

	override public function dispose():Void {
		super.dispose();
		for (cellRenderer in _cellRenderers) {
			cellRenderer.removeEventListener(Event.CHANGE, onCellRendererChange);
			cellRenderer.dispose();
		}
		_cellRenderers = [];
	}

	override public function setSize(_width:Float, _height:Float):Void {
		super.setSize(_width, _height);
		layoutChildren();
		update();
	}

	private function layoutChildren() {
		var cellRendererHeight:Float = cast(cast(getStyle("cellRenderer"), UIComponent).getStyle("upSkin"), DisplayObject).getBounds(null).height;
		var cellRendererY:Float = 0.0;
		for (cellRenderer in _cellRenderers) {
			cellRenderer.y = cellRendererY;
			cellRenderer.setSize(_width, cellRendererHeight);
			cellRendererY += cellRendererHeight;
		}
	}

	private function onCellRendererChange(event:Event):Void {
		if (_selectable == false)
			return;
		var cellRenderer:CellRenderer = cast event.target;
		if (cellRenderer.listData.index == _selectedIndex)
			return;
		selectedIndex = cellRenderer.listData.index;
		dispatchEvent(new Event(Event.CHANGE));
	}
}
