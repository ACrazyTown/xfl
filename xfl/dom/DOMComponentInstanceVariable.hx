package xfl.dom;

import haxe.xml.Access;

class DOMComponentInstanceVariable
{
	public var variable:String;
	public var defaultValue:String;
	public var type:String;
	
	public function new() {}
	
	public static function parse(xml:Access):DOMComponentInstanceVariable
	{
		var componentInstanceVariable:DOMComponentInstanceVariable = new DOMComponentInstanceVariable();
		componentInstanceVariable.variable = xml.att.variable;
		componentInstanceVariable.defaultValue = xml.att.defaultValue;
		componentInstanceVariable.type = xml.att.type;
		return componentInstanceVariable;
	}
}
