package openfl.data;

/**
 * Data provider
 */
class DataProvider
{
	public var data:Array<Dynamic>;
	public var length(get, never):Int;
	
	public function new(data:Array<Dynamic> = null)
	{
		this.data = data != null ? data : new Array<Dynamic>();
	}
	
	public function addItem(rowData:Dynamic)
	{
		data.push(rowData);
	}
	
	public function getItemAt(rowIdx:Int):Dynamic
	{
		return data[rowIdx];
	}
	
	private function get_length():Int
	{
		return data.length;
	}
}
