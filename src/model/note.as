package model
{
	import dao.noteDAO;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class note
	{
		public var loaded:Boolean = false;
		
		public var id:int;
		public var time:String;
		public var content:String;
		
	 
		
		
	}
}