package xfl.dom;

import openfl.geom.Matrix;
import openfl.geom.Point;
import haxe.xml.Access;

class DOMComponentInstance
{
	public var name:String;
	public var libraryItemName:String;
	public var matrix:Matrix;
	public var transformationPoint:Point;
	public var variables:Map<String, DOMComponentInstanceVariable>;
	
	public function new()
	{
		variables = new Map<String, DOMComponentInstanceVariable>();
	}
	
	public static function parse(xml:Access):DOMComponentInstance
	{
		var componentInstance:DOMComponentInstance = new DOMComponentInstance();
		componentInstance.name = xml.has.name == true ? xml.att.name : null;
		componentInstance.libraryItemName = xml.att.libraryItemName;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "transformationPoint":
					componentInstance.transformationPoint = xfl.geom.Point.parse(element.elements.next());
				case "matrix":
					componentInstance.matrix = xfl.geom.Matrix.parse(element.elements.next());
				case "parametersAsXML":
					var propertyElementXML:Access = new Access(Xml.parse(element.innerData));
					for (propertyElement in propertyElementXML.elements)
					{
						if (propertyElement.name == "property")
						{
							var inspectableElement = propertyElement.node.Inspectable;
							var componentInstanceVariable:DOMComponentInstanceVariable = DOMComponentInstanceVariable.parse(inspectableElement);
							componentInstance.variables.set(componentInstanceVariable.variable, componentInstanceVariable);
						}
					}
			}
		}
		return componentInstance;
	}
}
