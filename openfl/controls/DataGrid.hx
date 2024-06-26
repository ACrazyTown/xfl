package openfl.controls;

import openfl.containers.BaseScrollPane;
import openfl.controls.dataGridClasses.HeaderRenderer;
import openfl.controls.dataGridClasses.DataGridColumn;
import openfl.controls.listClasses.CellRenderer;
import openfl.controls.listClasses.ICellRenderer;
import openfl.controls.listClasses.ListData;
import openfl.core.UIComponent;
import openfl.data.DataProvider;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.events.ListEvent;
import openfl.text.TextFormat;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;

/**
 * Data grid
 */
class DataGrid extends BaseScrollPane
{
	public var columns:Array<DataGridColumn>;
	
	public var sortableColumns:Bool;
	public var resizableColumns:Bool;
	
	public var dataProvider(get, set):DataProvider;
	public var rowHeight(default, set):Float;
	
	private var _dataProvider:DataProvider;
	private var _headerDisplayObjects:Array<DisplayObjectContainer>;
	private var _dataDisplayObjects:Array<DisplayObjectContainer>;
	private var _mouseOverDisplayObjects:DisplayObjectContainer;
	private var _scrollPaneSource:Sprite;
	
	/**
	 * Public constructor
	**/
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments /* != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.DataGrid")*/);
		_headerDisplayObjects = new Array<DisplayObjectContainer>();
		_dataDisplayObjects = new Array<DisplayObjectContainer>();
		_mouseOverDisplayObjects = null;
		columns = new Array<DataGridColumn>();
		_width = 0;
		_height = 0;
		x = 0;
		y = 0;
		width = 0;
		height = 0;
		rowHeight = 0.0;
		mouseChildren = true;
		_scrollPaneSource = new Sprite();
		source = _scrollPaneSource;
		draw();
		update();
	}
	
	/**
	 * Add column
	 * @param arg0 - name
	 */
	public function addColumn(dataField:String):Void
	{
		var column:DataGridColumn = new DataGridColumn();
		column.dataField = dataField;
		column.headerText = dataField;
		columns.push(column);
		draw();
		update();
	}
	
	public function getCellRendererAt(row:Int, column:Int):ICellRenderer
	{
		return cast(_dataDisplayObjects[row].getChildAt(column), ICellRenderer);
	}
	
	public function getItemAt(rowIdx:Int):Dynamic
	{
		return dataProvider.getItemAt(rowIdx);
	}
	
	private function get_dataProvider():DataProvider
	{
		return _dataProvider;
	}
	
	private function set_dataProvider(dataProvider:DataProvider):DataProvider
	{
		_dataProvider = dataProvider;
		setColumnWidth(_width);
		draw();
		update();
		return _dataProvider;
	}
	
	override private function draw()
	{
		disposeChildren();
		var headerRenderer:Class<Dynamic> = getStyle("headerRenderer") != null ? cast(getStyle("headerRenderer"), Class<Dynamic>) : null;
		var cellRenderer:Class<Dynamic> = getStyle("cellRenderer") != null ? cast(getStyle("cellRenderer"), Class<Dynamic>) : null;
		for (column in columns)
		{
			column.headerRenderer = headerRenderer;
			column.cellRenderer = cellRenderer;
		}
		if (headerRenderer == null || cellRenderer == null)
			return;
		var _x:Float = 0.0;
		var columnIdx:Int = 0;
		var headerTextFormat:TextFormat = getStyle("headerTextFormat") != null ? cast(getStyle("headerTextFormat"), TextFormat) : null;
		var headerRow:DisplayObjectContainer = new DisplayObjectContainer();
		headerRow.x = 0.0;
		headerRow.y = 0.0;
		for (column in columns)
		{
			var headerRenderer:HeaderRenderer = Type.createInstance(column.headerRenderer, []);
			headerRenderer.name = "datagrid.header." + columnIdx;
			headerRenderer.column = columnIdx++;
			if (headerTextFormat != null)
				headerRenderer.setStyle("textFormat", headerTextFormat);
			headerRenderer.label = StringTools.ltrim(StringTools.rtrim(column.headerText));
			headerRenderer.x = _x;
			headerRenderer.y = 0.0;
			headerRenderer.setSize(column.width, headerRenderer.textField.height);
			headerRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			headerRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			headerRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			headerRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			headerRow.addChild(headerRenderer);
			_x += column.width;
		}
		_headerDisplayObjects.push(headerRow);
		addChild(headerRow);
		if (_dataProvider != null)
		{
			var textFormat:TextFormat = getStyle("textFormat") != null ? cast(getStyle("textFormat"), TextFormat) : null;
			for (i in 0..._dataProvider.length)
			{
				_x = 0;
				var rowData:Dynamic = _dataProvider.getItemAt(i);
				var columnIdx = 0;
				var dataRow:DisplayObjectContainer = new DisplayObjectContainer();
				for (column in columns)
				{
					var cellRenderer:CellRenderer = Type.createInstance(column.cellRenderer, []);
					var listData:ListData = new ListData(columnIdx, null, i + 1, null, this, i);
					cellRenderer.name = "datagrid.cell." + columnIdx + "," + i;
					if (textFormat != null)
						cellRenderer.setStyle("textFormat", textFormat);
					cellRenderer.label = StringTools.ltrim(StringTools.rtrim(column.itemToLabel(rowData)));
					cellRenderer.x = _x;
					cellRenderer.y = 0.0;
					var cellHeight:Float = cellRenderer.textField.height;
					if (cellHeight > rowHeight)
						rowHeight = cellHeight;
					if (cellHeight < rowHeight)
						cellHeight = rowHeight;
					cellRenderer.setSize(column.width, cellHeight);
					cellRenderer.data = rowData;
					cellRenderer.listData = listData;
					cellRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.CLICK, onMouseEventClick);
					_x += column.width;
					columnIdx++;
					dataRow.addChild(cellRenderer);
				}
				_scrollPaneSource.addChild(dataRow);
				_dataDisplayObjects.push(dataRow);
			}
		}
		_scrollPaneSource.y = alignDisplayObjects(_headerDisplayObjects);
		alignDisplayObjects(_dataDisplayObjects);
		update();
		if (verticalScrollBar.visible == true)
		{
			realignDisplayObjectsWidth(_headerDisplayObjects, verticalScrollBar.width);
			realignDisplayObjectsWidth(_dataDisplayObjects, verticalScrollBar.width);
		}
	}
	
	private function alignDisplayObjects(displayObjects:Array<DisplayObjectContainer>, verticalScrollBarSize:Float = 0.0):Float
	{
		var _y:Float = 0.0;
		if (displayObjects.length > 0)
		{
			for (i in 0...Std.int(displayObjects.length))
			{
				var cellHeight:Float = 0.0;
				for (j in 0...columns.length)
				{
					var cell:DisplayObject = displayObjects[i].getChildAt(j);
					if (Std.isOfType(cell, HeaderRenderer))
					{
						cast(cell, HeaderRenderer).init();
						cast(cell, HeaderRenderer).validateNow();
					}
					else
					{
						cast(cell, CellRenderer).init();
						cast(cell, CellRenderer).validateNow();
					}
					if (cell.height > cellHeight)
						cellHeight = cell.height;
				}
				if (rowHeight > cellHeight)
					cellHeight = rowHeight;
				var _x:Float = 0.0;
				for (j in 0...columns.length)
				{
					var cell:DisplayObject = displayObjects[i].getChildAt(j);
					if (Std.isOfType(cell, HeaderRenderer))
					{
						cast(cell, HeaderRenderer).setSize(columns[j].width, cellHeight);
					}
					else
					{
						cast(cell, CellRenderer).setSize(columns[j].width, cellHeight);
					}
					cell.x = _x;
					cell.height = cellHeight;
					cell.width -= verticalScrollBarSize / columns.length;
					_x += cell.width;
				}
				displayObjects[i].y = _y;
				_y += cellHeight;
			}
		}
		return _y;
	}
	
	private function realignDisplayObjectsWidth(displayObjects:Array<DisplayObjectContainer>, verticalScrollBarSize:Float = 0.0):Void
	{
		if (displayObjects.length > 0)
		{
			for (i in 0...displayObjects.length)
			{
				var _x:Float = 0.0;
				for (j in 0...columns.length)
				{
					var cell:DisplayObject = displayObjects[i].getChildAt(j);
					cell.x = _x;
					cell.width -= verticalScrollBarSize / columns.length;
					_x += cell.width;
				}
			}
		}
	}
	
	private function set_rowHeight(rowHeight:Float):Float
	{
		this.rowHeight = rowHeight;
		draw();
		update();
		return rowHeight;
	}
	
	private function setColumnWidth(_width:Float):Void
	{
		if (_width <= 0)
			return;
		var columnsWithoutWidth:Int = 0;
		var columnsWidth:Float = 0;
		for (column in columns)
		{
			if (column.width != -1)
			{
				columnsWidth += column.width;
			}
			else
			{
				columnsWithoutWidth++;
			}
		}
		var columnsWidthLeft:Float = _width - columnsWidth;
		for (column in columns)
		{
			if (column.width == -1)
			{
				column.width = columnsWidthLeft / columnsWithoutWidth;
			}
			else
			{
				column.width *= _width / columnsWidth;
			}
		}
		draw();
		update();
	}
	
	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
		setColumnWidth(width);
		draw();
		update();
	}
	
	private function onMouseEvent(event:MouseEvent):Void
	{
		if (Std.isOfType(event.target, HeaderRenderer) == true)
		{
			var mouseHeaderRenderer:HeaderRenderer = cast(event.target, HeaderRenderer);
			for (columnIdx in 0...columns.length)
			{
				var headerRenderer:DisplayObject = _headerDisplayObjects[0].getChildAt(columnIdx);
				if (headerRenderer != null)
				{
					cast(headerRenderer, HeaderRenderer).setMouseState(event.type.charAt("mouse".length)
						.toLowerCase() + event.type.substr("mouse".length + 1));
				}
			}
		}
		
		// un mouse over last mouse over cells
		if (_mouseOverDisplayObjects != null)
		{
			for (columnIdx in 0...columns.length)
			{
				var cellRenderer:DisplayObject = _mouseOverDisplayObjects.getChildAt(columnIdx);
				if (cellRenderer != null)
				{
					cast(cellRenderer, CellRenderer).setMouseState("out");
				}
			}
			_mouseOverDisplayObjects = null;
		}
		
		// find mouse cell renderer down up the hierarchy
		var mouseCellRendererCandidate:DisplayObject = event.target;
		while (mouseCellRendererCandidate != null && Std.isOfType(mouseCellRendererCandidate, CellRenderer) == false)
			mouseCellRendererCandidate = mouseCellRendererCandidate.parent;
		var mouseCellRenderer:CellRenderer = mouseCellRendererCandidate != null ? cast(mouseCellRendererCandidate, CellRenderer) : null;
		if (mouseCellRenderer != null)
		{
			var displayObjectIndex:Int = mouseCellRenderer.listData.index - 1;
			for (columnIdx in 0...columns.length)
			{
				var cellRenderer:DisplayObject = displayObjectIndex < _dataDisplayObjects.length ? _dataDisplayObjects[displayObjectIndex].getChildAt(columnIdx) : null;
				if (cellRenderer != null)
				{
					cast(cellRenderer, CellRenderer).setMouseState(event.type.charAt("mouse".length).toLowerCase() + event.type.substr("mouse".length + 1));
				}
			}
			_mouseOverDisplayObjects = _dataDisplayObjects[displayObjectIndex];
		}
	}
	
	private function onMouseEventClick(event:MouseEvent):Void
	{
		if (Std.isOfType(cast(event.target, DisplayObject), CellRenderer) == true)
		{
			var cell:CellRenderer = cast(event.target, CellRenderer);
			var listData:ListData = cell.listData;
			dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, false, listData.column, listData.row, listData.index, cell.data));
		}
	}
	
	private function disposeChildren():Void
	{
		for (rowDisplayObjects in _headerDisplayObjects)
		{
			for (i in 0...rowDisplayObjects.numChildren)
			{
				var rowDisplayObject:DisplayObject = rowDisplayObjects.getChildAt(i);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			}
			removeChild(rowDisplayObjects);
		}
		_headerDisplayObjects.splice(0, _headerDisplayObjects.length);
		for (rowDisplayObjects in _dataDisplayObjects)
		{
			for (i in 0...rowDisplayObjects.numChildren)
			{
				var rowDisplayObject:DisplayObject = rowDisplayObjects.getChildAt(i);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				rowDisplayObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
				rowDisplayObject.removeEventListener(MouseEvent.CLICK, onMouseEventClick);
			}
			_scrollPaneSource.removeChild(rowDisplayObjects);
		}
		_dataDisplayObjects.splice(0, _dataDisplayObjects.length);
	}
	
	override public function dispose():Void
	{
		disposeChildren();
		super.dispose();
	}
}
