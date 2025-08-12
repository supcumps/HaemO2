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
		  //Function AskYesNo(prompt As String) As Boolean
		  While True
		    stdout.Write(prompt + " (Y/N): ")
		    stdout.Flush
		    
		    Var Input As String = stdin.ReadLine
		    
		    '// Debug: Show exactly what was received
		    'stdout.WriteLine("DEBUG: Input length=" + Str(Input.Length))
		    'For i As Integer = 0 To Input.Length - 1
		    'stdout.WriteLine("DEBUG: Char " + Str(i) + " = '" + Input.Mid(i, 1) + "' ASCII=" + Str(Asc(Input.Mid(i, 1))))
		    'Next
		    
		    If Input <> "" Then
		      Input = Input.Trim.Uppercase
		      'stdout.WriteLine("DEBUG: Clean input = '" + Input + "'")
		      
		      Select Case Input
		      Case "Y", "YES"
		        Return True
		      Case "N", "NO"
		        Return False
		      Case Else
		        stdout.WriteLine("Please enter Y or N.")
		      End Select
		    End If
		  Wend
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearScreen()
		  
		  ' In console applications, we can clear by printing blank lines
		  For i As Integer = 1 To 50
		    stdout.WriteLine("")
		  Next
		  System.DebugLog  Chr(27) + "[H"    // Move cursor to home (0,0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PauseForNext()
		  
		  stdout.WriteLine("")
		  stdout.Write("Press <RETURN> to continue... ")
		  Var dummy As String = stdin.ReadLine
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResizeTerminal(cols As Integer, rows As Integer)
		  
		  // Use ANSI escape sequence to resize terminal window
		  System.DebugLog Chr(27) + "[8;" + Str(rows) + ";" + Str(cols) + "t"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setScreenColours()
		  
		  
		  var  kLightBlue As String = Chr(27) + "[104m"  // Bright blue background
		  var kCyan As String = Chr(27) + "[106m"       // Cyan background (light blue-ish)
		  var kClearScreen As String = Chr(27) + "[2J"  // Clear screen
		  var kHomeCursor As String = Chr(27) + "[H"    // Move cursor to home (0,0)
		  var kWhiteText As String = Chr(27) + "[97m"   // Bright white text
		  
		  // Set up the entire screen with light blue background
		  System.DebugLog kLightBlue + kClearScreen + kHomeCursor + kWhiteText
		  
		  
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
