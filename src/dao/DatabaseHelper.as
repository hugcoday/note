package dao
{
	import events.DataChangeEvent;
	import events.SyncEvent;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import model.note;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	



	[Event(name="success", type="events.SyncEvent")]
	[Event(name="failure", type="events.SyncEvent")]
	public class DatabaseHelper extends EventDispatcher
	{
		public static var sqlConnection:SQLConnection;
		
		
		
		public static function openDatabase(file:File):void
		{
			var newDB:Boolean = true;
			if (file.exists)
				newDB = false;
			sqlConnection = new SQLConnection();
			sqlConnection.open(file);
			///sqlConnection.addEventListener(SQLEvent.OPEN,function dd (evt:SQLEvent):void{StaticDispatcher.dispatchEvent(new Event("isOpened"));});
			trace("addevent");

			if (newDB)
			{
				createDatabase();
				populateDatabase();
			}

		}
		
		
		
		protected static function createDatabase():void
		{
			var sql:String = 
				"CREATE TABLE IF NOT EXISTS notelist ( "+
				"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"time VARCHAR(50), " +
				"content VARCHAR(5000)) ";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();			
		}
		
		protected static function populateDatabase():void
		{
			var file:File = File.applicationDirectory.resolvePath("assets/notelist.xml");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var xml:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			var _noteDAO:noteDAO = new noteDAO();
			for each (var emp:XML in xml.note)
			{
				var _note:note = new note();
				_note.id = emp.id;
				_note.time = emp.time;
				_note.content = emp.content;
				
				
				_noteDAO.create(_note);
			}
		}

		public function synchronize(url:String):void
		{
			var srv:HTTPService = new HTTPService();
			srv.url = url;
			var token:AsyncToken = srv.send();
			token.url = url;
			token.addResponder(new AsyncResponder(resultHandler, faultHandler));
		}
		
		protected function resultHandler(event:ResultEvent, token:Object):void
		{
			deleteData();
			
			var notes:ArrayCollection = event.result.list.note as ArrayCollection;
			if (notes == null || notes.length < 1)
			{
				dispatchEvent(new SyncEvent(SyncEvent.FAILURE, "Invalid XML document"));
			}
			var _noteDAO:noteDAO = new noteDAO();
			for (var i:int; i<notes.length; i++)
			{
				var _note:note = new note();
				var emp:Object = notes.getItemAt(i);
				_note.id = emp.id;
				_note.time = emp.time;
				_note.content = emp.content;
				
				 
				_noteDAO.create(_note);				
			}
			dispatchEvent(new SyncEvent(SyncEvent.SUCCESS, notes.length));
		}
		
		protected function deleteData():void
		{
			var sql:String = "DELETE FROM notelist";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();					
		}
		
		protected function faultHandler(event:FaultEvent, token:Object):void
		{
			dispatchEvent(new SyncEvent(SyncEvent.FAILURE, "Error loading XML file: " + event.token.url + ". Make sure the file is acessible."));
		}
		
		
		
		
	}
}