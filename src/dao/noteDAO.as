package dao
{
	import flash.data.SQLStatement;
	
	import model.note;
	
	import mx.collections.ArrayCollection;
	
	public class noteDAO
	{
		public function getItem(id:int):note
		{
			var sql:String = "SELECT id, time, content FROM notelist WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result && result.length == 1)
				return processRow(result[0]);
			else
				return null;
				
		}

		

		public function findByName(searchKey:String):ArrayCollection
		{
			
			
			 var sql:String = "SELECT * FROM notelist WHERE content  LIKE '%"+searchKey+"%' ORDER BY id desc ";
			 var stmt:SQLStatement = new SQLStatement();
			 stmt.sqlConnection = DatabaseHelper.sqlConnection;
			 stmt.text = sql;
//			 stmt.parameters[0] = searchKey;
			 stmt.execute();
			 var result:Array = stmt.getResult().data;
			 if (result)
			 {
				 var list:ArrayCollection = new ArrayCollection();
				 for (var i:int=0; i<result.length; i++)
				 {
					 list.addItem(processRow(result[i]));	
				 }
				 return list;
			 }
			 else
			 {
				 return null;
			 }
		}
		
		public function getMaxID():int{
			var sql:String = "SELECT max(id) maxid FROM notelist ";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			
			stmt.execute();
			var result:Array = stmt.getResult().data;
			
			return result[0].maxid;
		}

		public function create(_note:note):void
		{
			trace(_note.content);
			
			var sql:String = 
				"INSERT INTO notelist (id, time, content) " +
				"VALUES (?,?,?)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = _note.id;
			stmt.parameters[1] = _note.time;
			stmt.parameters[2] = _note.content;
			
			stmt.execute();
			_note.loaded = true;
		}
		
		public function update(_note:note):void{
			
			var sql:String = 
				"UPDATE notelist set time=? , content=? where id=? ";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = _note.time;
			stmt.parameters[1] = _note.content;
			stmt.parameters[2] = _note.id;
			
			stmt.execute();
			_note.loaded = true;
		}
		
		public function deleteNote(id:int):void{
			var sql:String = 
				"delete from notelist where id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
		}
		
		protected function processRow(o:Object):note
		{
			var _note:note = new note();
			_note.id = o.id;
			_note.time = o.time == null ? "" : o.time;
			_note.content = o.content == null ? "" : o.content;
			
			_note.loaded = true;
			return _note;
		}

		
	}
}