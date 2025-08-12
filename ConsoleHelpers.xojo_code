#tag Module
Protected Module ConsoleHelpers
	#tag Method, Flags = &h0
		Function AskDouble(prompt As String) As Double
		  Do
		    stdout.Write(prompt + ": ")
		    Var Input As String = stdin.ReadLine
		    
		    Try
		      Return Val(Input)
		    Catch
		      stdout.WriteLine("Please enter a valid number. ")
		    End Try
		  Loop
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AskText(prompt As String) As String
		  
		  If prompt <> "" Then
		    stdout.Write(prompt + ": ")
		  End If
		  Return stdin.ReadLine
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AskYesNo(prompt As String) As Boolean
		  Do
		    stdout.Write(prompt + " (Y/N): ")
		    Var Input As String = stdin.ReadLine.Uppercase
		    
		    Select Case Input
		    Case "Y", "YES"
		      Return True
		    Case "N", "NO"
		      Return False
		    Case Else
		      stdout.WriteLine("Please enter Y or N. ")
		    End Select
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PauseForNext()
		  
		  stdout.WriteLine("")
		  stdout.Write("Press <RETURN> to continue... ")
		  Var dummy As String = stdin.ReadLine
		  
		End Sub
	#tag EndMethod


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
	#tag EndViewBehavior
End Module
#tag EndModule
