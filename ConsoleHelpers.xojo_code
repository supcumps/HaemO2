#tag Module
Protected Module ConsoleHelpers
	#tag Method, Flags = &h0
		Function AskDouble(prompt As String) As Double
		  //Function AskDouble(prompt As String) As Double
		  Do
		    stdout.Write(prompt + ": ")
		    stdout.Flush
		    
		    Var rawInput As String = stdin.ReadLine
		    
		    // Debug the raw input character by character
		    '''System.DebugLog("=== Character Analysis ===")
		    '''System.DebugLog("Input length: " + rawInput.Length.ToString)
		    For i As Integer = 1 To rawInput.Length
		      Var char As String = rawInput.Mid(i, 1)
		      Var ascii As Integer = char.Asc
		      ''System.DebugLog("Char " + i.ToString + ": '" + char + "' (ASCII: " + ascii.ToString + ")")
		    Next
		    '''System.DebugLog("=== End Analysis ===")
		    
		    // Remove any control characters (CR, LF, etc.)
		    Var cleanInput As String = ""
		    For i As Integer = 1 To rawInput.Length
		      Var char As String = rawInput.Mid(i, 1)
		      Var ascii As Integer = char.Asc
		      If ascii >= 32 And ascii <= 126 Then  // Printable ASCII characters
		        cleanInput = cleanInput + char
		      End If
		    Next
		    
		    ''System.DebugLog("After removing control chars: '" + cleanInput + "'")
		    
		    If cleanInput <> "" Then
		      Try
		        Var result As Double = cleanInput.ToDouble
		        Return result
		      Catch e As RuntimeException
		        stdout.WriteLine("Please enter a valid number.")
		      End Try
		    Else
		      stdout.WriteLine("Please enter a valid number.")
		    End If
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AskText(prompt As String) As String
		  // Function AskText(prompt As String) As String
		  Do
		    // Clear any pending input first
		    stdout.WriteLine("")  // Ensure we're on a new line
		    stdout.Write(prompt + ": ")
		    stdout.Flush
		    
		    // Read the input
		    Var rawInput As String = stdin.ReadLine
		    
		    // Remove any control characters that might be causing issues
		    Var cleanedInput As String = ""
		    For i As Integer = 1 To rawInput.Length
		      Var char As String = rawInput.Mid(i, 1)
		      Var ascii As Integer = char.Asc
		      // Only keep printable characters (space to tilde)
		      If ascii >= 32 And ascii <= 126 Then
		        cleanedInput = cleanedInput + char
		      End If
		    Next
		    
		    cleanedInput = cleanedInput.Trim
		    
		    'System.DebugLog("Raw: '" + rawInput + "' Cleaned: '" + cleanedInput + "'")
		    
		    If cleanedInput <> "" Then
		      Return cleanedInput
		    Else
		      stdout.WriteLine("Please enter some text.")
		    End If
		  Loop
		  
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
		      Case "Y", "Yes"
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
		Function CleanInput(rawInput As String) As String
		  // Private Function CleanInput(Input As String) As String
		  Var result As String = Input.Trim
		  Var cleaned As String = ""
		  
		  // Use 1-based indexing for Xojo strings
		  For i As Integer = 1 To result.Length
		    Var char As String = result.Mid(i, 1)
		    If (char >= "0" And char <= "9") Or char = "." Or char = "-" Then
		      cleaned = cleaned + char
		    End If
		  Next
		  
		  Return cleaned
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearLine()
		  // Clear current line
		  
		  stdout.Write(Chr(27) + "[2K")
		  stdout.Flush
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearScreen()
		  // Clear entire screen
		  stdout.Write(Chr(27) + "[2J")
		  stdout.Flush
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearToEnd()
		  // Clear from cursor to end of screen
		  stdout.Write(Chr(27) + "[0J")
		  stdout.Flush
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GoToTop()
		   // Move cursor to top-left (1,1)
		  stdout.Write(Chr(27) + "[H")
		  stdout.Flush
		  
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
		  'System.DebugLog Chr(27) + "[8;" + Str(rows) + ";" + Str(cols) + "t"
		  stdout.Write( Chr(27) + "[8;" + Str(rows) + ";" + Str(cols) + "t")
		  stdout.Flush
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
		  'System.DebugLog kLightBlue + kClearScreen + kHomeCursor + kWhiteText
		  stdout.Write(kLightBlue + kClearScreen + kHomeCursor + kWhiteText)
		  
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
