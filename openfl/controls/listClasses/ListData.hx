package openfl.controls.listClasses;

import openfl.core.UIComponent;

/**
 * List data
 */
class ListData
{
	public var column(get, never):Int;
	public var icon(get, never):String;
	public var index(get, never):Int;
	public var label(get, never):String;
	public var owner(get, never):UIComponent;
	public var row(get, never):Int;
	
	private var _column:Int;
	private var _icon:String;
	private var _index:Int;
	private var _label:String;
	private var _owner:UIComponent;
	private var _row:Int;
	
	/**
	 * Public constructor
	**/
	public function new(column:Int, icon:String, index:Int, label:String, owner:UIComponent, row:Int)
	{
		_column = column;
		_icon = icon;
		_index = index;
		_label = label;
		_owner = owner;
		_row = row;
	}
	
	public function get_column():Int
	{
		return _column;
	}
	
	public function get_icon():String
	{
		return _icon;
	}
	
	public function get_index():Int
	{
		return _index;
	}
	
	public function get_label():String
	{
		return _label;
	}
	
	public function get_owner():UIComponent
	{
		return _owner;
	}
	
	public function get_row():Int
	{
		return _row;
	}
}
