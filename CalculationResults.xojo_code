#tag Class
Protected Class CalculationResults
	#tag Property, Flags = &h0
		AAGradient As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		AARatio As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		AlveolarPO2 As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ArterialO2Content As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ArterialSaturation As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		AVDifference As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		CaloricNeeds As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		CardiacIndex As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		CardiacOutput As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		CoronaryPerfusionPressure As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		EndCapillaryContent As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		EndCapillarySaturation As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ExtractionRatio As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		LeftCardiacWork As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		LVSWI As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		OxygenConsumption As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		OxygenDelivery As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		PulmonaryVascularResistance As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		PulmonaryVascularResistance1 As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		RatePressureProduct As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		RightCardiacWork As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		RVSWI As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Shunt As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		StrokeIndex As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		SurfaceArea As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		SystemicVascularResistance As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VenousO2Content As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VenousSaturation As Double
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
			Name="CardiacOutput"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AAGradient"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AARatio"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AlveolarPO2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArterialO2Content"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArterialSaturation"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AVDifference"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CaloricNeeds"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CardiacIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CoronaryPerfusionPressure"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndCapillaryContent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndCapillarySaturation"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ExtractionRatio"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LeftCardiacWork"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LVSWI"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OxygenConsumption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OxygenDelivery"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PulmonaryVascularResistance"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PulmonaryVascularResistance1"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RatePressureProduct"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RightCardiacWork"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RVSWI"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Shunt"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StrokeIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SurfaceArea"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SystemicVascularResistance"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VenousO2Content"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VenousSaturation"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
