package haxe;
class MethodUtil
{
	/**
	* Gets the number of arguments a method has.
	* Trickery is done for platorms that don't support the '.length' property.
	*
	* Tested: html5, flash, android, neko
	*
	* @param method : Dynamic - function to analyse
	*
	* @return Int - number of arguments
	**/
	public static function numArgs(method : Dynamic) : Int
	{
		#if android
		var str : String = Std.string(method);
		if(str.indexOf("#function") == 0)
			return Std.parseInt(str.substr(9));
		#elseif neko
		var str : String = Std.string(method);
		if(str.indexOf("#function:") == 0)
			return Std.parseInt(str.substr(10));
		#else
			// Works on html5 and flash. Other targets untested.
			return method.length;
		#end
		return 0;
	}
}
