#tag Module
Protected Module ClinicalInterpreter
	#tag Method, Flags = &h0
		Function GenerateOverallAssessment(results As CalculationResults) As String
		  Var assessment As String = ""
		  Var findings() As String
		  
		  ' Analyze cardiac function
		  If results.CardiacIndex < 2.2 And results.SystemicVascularResistance > 2600 Then
		    findings.Add("CARDIOGENIC SHOCK pattern")
		  ElseIf results.CardiacIndex > 4.0 And results.SystemicVascularResistance < 1200 Then
		    findings.Add("HYPERDYNAMIC CIRCULATION pattern")
		  End If
		  
		  ' Analyze for sepsis indicators
		  If results.CardiacIndex > 3.5 And results.SystemicVascularResistance < 1000 And results.ExtractionRatio < 22 Then
		    findings.Add("EARLY SEPSIS pattern")
		  ElseIf results.CardiacIndex < 2.5 And results.SystemicVascularResistance < 1000 Then
		    findings.Add("LATE SEPSIS/SEPTIC SHOCK pattern")
		  End If
		  
		  ' Analyze oxygen transport
		  If results.OxygenDelivery > 600 And results.ExtractionRatio < 20 Then
		    findings.Add("OXYGEN EXTRACTION DEFICIT")
		  ElseIf results.OxygenDelivery < 400 Then
		    findings.Add("OXYGEN DELIVERY DEFICIT")
		  End If
		  
		  ' Compile assessment
		  If findings.Count > 0 Then
		    assessment = "CLINICAL PATTERN: " + String.FromArray(findings, " + ")
		  Else
		    assessment = "HEMODYNAMICS WITHIN NORMAL LIMITS"
		  End If
		  
		  Return assessment
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTreatmentSuggestions(results As CalculationResults) As String()
		  Var suggestions() As String
		  
		  ' Low cardiac index suggestions
		  If results.CardiacIndex < 2.2 Then
		    If results.SystemicVascularResistance > 2600 Then
		      suggestions.Add("Consider inotropic support (dobutamine)")
		      suggestions.Add("Evaluate for mechanical circulatory support")
		    Else
		      suggestions.Add("Consider fluid challenge if preload low")
		      suggestions.Add("Consider vasopressors (norepinephrine)")
		    End If
		  End If
		  
		  ' High cardiac index with low SVR
		  If results.CardiacIndex > 4.0 And results.SystemicVascularResistance < 1000 Then
		    suggestions.Add("Consider vasopressor therapy (norepinephrine)")
		    suggestions.Add("Investigate septic source")
		    suggestions.Add("Consider stress dose steroids")
		  End If
		  
		  ' Poor oxygen extraction
		  If results.ExtractionRatio < 20 Then
		    suggestions.Add("Investigate cellular oxygen utilization")
		    suggestions.Add("Consider metabolic causes (sepsis, cyanide)")
		  End If
		  
		  ' Low oxygen delivery
		  If results.OxygenDelivery < 400 Then
		    suggestions.Add("Optimize cardiac output")
		    suggestions.Add("Consider blood transfusion if Hgb low")
		    suggestions.Add("Optimize oxygen saturation")
		  End If
		  
		  Return suggestions
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InterpretCardiacIndex(ci As Double) As String
		  If ci < 2.2 Then
		    Return "LOW - Suggests cardiogenic shock or severe heart failure"
		  ElseIf ci > 4.0 Then
		    Return "HIGH - Suggests hyperdynamic circulation (sepsis, hyperthyroidism)"
		  Else
		    Return "Normal CI"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InterpretMixedVenousSat(mvSat As Double) As String
		  If mvSat < 60 Then
		    Return "LOW - Severe oxygen delivery deficit or high consumption"
		  ElseIf mvSat > 80 Then
		    Return "HIGH - Impaired oxygen extraction (sepsis) or high cardiac output"
		  Else
		    Return "Normal O2 delivery"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InterpretOxygenExtraction(extraction As Double) As String
		  If extraction < 20 Then
		    Return "LOW - Impaired cellular oxygen utilization (sepsis, cyanide poisoning)"
		  ElseIf extraction > 35 Then
		    Return "HIGH - Compensated oxygen delivery deficit"
		  Else
		    Return "Normal O2 Usage"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InterpretSVR(svr As Double) As String
		  If svr < 800 Then
		    Return "VERY LOW - Distributive shock (sepsis, anaphylaxis, neurogenic)"
		  ElseIf svr < 1200 Then
		    Return "LOW - Mild vasodilation"
		  ElseIf svr > 2600 Then
		    Return "HIGH - Vasoconstriction (cardiogenic shock, hypothermia)"
		  Else
		    Return "Normal SVR"
		  End If
		End Function
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
