#tag Class
Protected Class OxygenTransportData
	#tag Property, Flags = &h0
		ArterialPCO2 As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ArterialPH As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ArterialPO2 As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		CoreTemperature As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Haemoglobin As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		InspiredOxygen As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VenousPCO2 As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VenousPH As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VenousPO2 As Double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name=Autolog.lv_Name
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
			Name="Haemoglobin"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArterialPCO2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArterialPH"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArterialPO2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CoreTemperature"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InspiredOxygen"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VenousPCO2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VenousPH"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VenousPO2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
