#tag Class
Protected Class Logger
	#tag Method, Flags = &h0
		Sub Close()
		  
		  If logFile <> Nil Then logFile.Close
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(logFolder As FolderItem, appName As String = "HaemAppLogFile")
		  Var d As DateTime = DateTime.Now
		  var Now as String  = d.ToString
		  logPath = logFolder.Child(appName + "_log_" + now + ".txt")
		  logFile = TextOutputStream.Create(logPath)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(message As String, level As String = "INFO", userID As String = "", sessionID As String = "")
		  Var d As DateTime = DateTime.Now
		  var timestamp as String  = d.ToString
		  
		  Var entry As String = "[" + timestamp + "] [" + level + "]"
		  
		  If userID <> "" Then entry = entry + " [User: " + userID + "]"
		  If sessionID <> "" Then entry = entry + " [Session: " + sessionID + "]"
		  
		  entry = entry + " " + message
		  
		  // Output to console
		  System.DebugLog(entry)
		  
		  // Write to file
		  If logFile <> Nil Then
		    logFile.WriteLine(entry)
		    logFile.Flush
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private logFile As TextOutputStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private logPath As FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="logFile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
