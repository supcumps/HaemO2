#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  
		  Try
		    // show the initial display screen
		    ShowIntroduction()
		    
		    Do
		      If Not RunClinicalStudy() Then Exit
		    Loop
		    
		  Catch e As RuntimeException
		    HandleError(e)
		  End Try
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub CalculateHaemodynamics(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, results As CalculationResults)
		  ' Calculate mean cardiac output
		  Var sum As Double = 0
		  For Each output As Double In outputs
		    sum = sum + output
		  Next
		  results.CardiacOutput = sum / outputs.Count
		  
		  ' Calculate surface area using DuBois formula
		  results.SurfaceArea = (haemo.Weight ^ 0.425) * (haemo.Height ^ 0.725) * 71.84 / 10000
		  
		  ' Calculate cardiac index
		  results.CardiacIndex = results.CardiacOutput / results.SurfaceArea
		  
		  ' Calculate vascular resistances
		  results.SystemicVascularResistance = 79.92 * (haemo.ArterialMean - haemo.CVPMean) / results.CardiacIndex
		  results.PulmonaryVascularResistance = 79.92 * (haemo.PulmonaryMean - haemo.PulmonaryWedge) / results.CardiacIndex
		  
		  ' Calculate stroke index
		  results.StrokeIndex = 1000 * results.CardiacIndex / haemo.HeartRate
		  
		  ' Calculate work indices
		  results.LVSWI = results.StrokeIndex * haemo.ArterialMean * 0.0144
		  results.RVSWI = results.StrokeIndex * haemo.PulmonaryMean * 0.0144
		  
		  ' Calculate cardiac work
		  results.LeftCardiacWork = results.CardiacIndex * haemo.ArterialMean * 0.0144
		  results.RightCardiacWork = results.CardiacIndex * haemo.PulmonaryMean * 0.0144
		  
		  ' Calculate rate pressure product
		  results.RatePressureProduct = haemo.ArterialSystolic * haemo.HeartRate
		  
		  ' Calculate coronary perfusion pressure
		  results.CoronaryPerfusionPressure = haemo.ArterialDiastolic - haemo.PulmonaryWedge
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CalculateOxygenSaturation(PO2 As Double, pH As Double, PCO2 As Double, temperature As Double) As Double
		  // Kelman's oxygen saturation algorithm
		  
		  ' Temperature and pH corrections
		  Var tempDiff As Double = temperature - 37
		  Var K0 As Double = 0.243 * (4 / 100) ^ 3.88
		  
		  ' Correct PO2 for temperature
		  Var correctedPO2 As Double = PO2 * Exp(tempDiff * (0.013 + 0.058 / (K0 + 1)))
		  
		  ' Calculate virtual PO2 for pH and CO2 effects
		  Var K2 As Double = (-0.024 * tempDiff + 0.4 * (pH - 7.4) + 0.06 * (Log(40) - Log(PCO2)))
		  correctedPO2 = correctedPO2 * (10 ^ K2)
		  
		  ' Kelman's saturation algorithm
		  Var L0 As Double = 99.95 - 100 / (1 + ((correctedPO2 + 7) / 33.7) ^ 3.3)
		  Var L1 As Double = -0.5 / (1 + ((correctedPO2 - 130) / 35) ^ 2)
		  Var L2 As Double = 0.45 / (1 + ((correctedPO2 - 68) / 12) ^ 6)
		  Var L3 As Double = -0.5 / (1 + ((correctedPO2 - 35) / 3) ^ 4)
		  Var L4 As Double = -0.5 / (1 + ((correctedPO2 - 15) / 4) ^ 4)
		  Var L5 As Double = 0.35 / (1 + ((correctedPO2 - 26) / 3) ^ 6)
		  Var L6 As Double = 0.2 / (1 + ((correctedPO2 - 53) / 8) ^ 4)
		  Var L7 As Double = -0.4 / (1 + ((correctedPO2 - 40) / 0.9) ^ 4)
		  Var L8 As Double = -0.2 / (1 + ((correctedPO2 - 200) / 65) ^ 8)
		  Var L9 As Double = 0.4 / (1 + ((correctedPO2 - 9) / 3) ^ 2)
		  
		  Return L0 + L1 + L2 + L3 + L4 + L5 + L6 + L7 + L8 + L9
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CalculateOxygenTransport(patient As PatientData, haemo As HaemodynamicData, oxygen As OxygenTransportData, results As CalculationResults)
		  ' Calculate oxygen transport parameters
		  // Sub CalculateOxygenTransport(patient As PatientData, haemo As HaemodynamicData, oxygen As OxygenTransportData, results As CalculationResults)
		  ' Temperature corrections
		  Var tempDiff As Double = oxygen.CoreTemperature - 37
		  
		  ' CO2 temperature corrections
		  Var arterialCO2Corrected As Double = oxygen.ArterialPCO2 * (10 ^ (0.019 * tempDiff))
		  Var venousCO2Corrected As Double = oxygen.VenousPCO2 * (10 ^ (0.019 * tempDiff))
		  
		  ' pH temperature corrections
		  Var arterialPHCorrected As Double = oxygen.ArterialPH - tempDiff * (0.0146 + 0.0065 * (oxygen.ArterialPH - 7.4))
		  Var venousPHCorrected As Double = oxygen.VenousPH - tempDiff * (0.0146 + 0.0065 * (oxygen.VenousPH - 7.4))
		  
		  ' Calculate oxygen saturations using Kelman's algorithm
		  results.ArterialSaturation = CalculateOxygenSaturation(oxygen.ArterialPO2, arterialPHCorrected, arterialCO2Corrected, oxygen.CoreTemperature)
		  results.VenousSaturation = CalculateOxygenSaturation(oxygen.VenousPO2, venousPHCorrected, venousCO2Corrected, oxygen.CoreTemperature)
		  
		  ' Calculate oxygen contents
		  results.ArterialO2Content = (oxygen.Haemoglobin * 1.39) * results.ArterialSaturation / 100 + (oxygen.ArterialPO2 * 0.0031)
		  results.VenousO2Content = (oxygen.Haemoglobin * 1.39) * results.VenousSaturation / 100 + (oxygen.VenousPO2 * 0.0031)
		  
		  ' Calculate transport parameters
		  results.AVDifference = results.ArterialO2Content - results.VenousO2Content
		  results.ExtractionRatio = 100 * results.AVDifference / results.ArterialO2Content
		  results.OxygenDelivery = results.ArterialO2Content * 10 * results.CardiacIndex
		  results.OxygenConsumption = results.CardiacIndex * results.AVDifference * 10
		  
		  ' Calculate alveolar parameters
		  Var barometricPressure As Double = 760
		  Var FiO2 As Double = oxygen.InspiredOxygen / 100
		  results.AlveolarPO2 = FiO2 * (barometricPressure - 47) - arterialCO2Corrected / 0.8
		  
		  ' Calculate end-capillary saturation
		  results.EndCapillarySaturation = CalculateOxygenSaturation(results.AlveolarPO2, arterialPHCorrected, arterialCO2Corrected, oxygen.CoreTemperature)
		  results.EndCapillaryContent = (oxygen.Haemoglobin * 1.39) * results.EndCapillarySaturation / 100 + (results.AlveolarPO2 * 0.0031)
		  
		  ' Calculate shunt and A-a gradient
		  results.AAGradient = results.AlveolarPO2 - oxygen.ArterialPO2
		  results.AARatio = (oxygen.ArterialPO2 / results.AlveolarPO2) * 100
		  results.Shunt = (0.0031 * results.AAGradient * 100) / (0.0031 * results.AAGradient + results.AVDifference)
		  
		  ' Calculate caloric needs
		  results.CaloricNeeds = results.OxygenConsumption * 6.948 * results.SurfaceArea
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClearScreen()
		  
		  ' In console applications, we can clear by printing blank lines
		  For i As Integer = 1 To 2
		    stdout.WriteLine("")
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CollectCardiacOutputs(ByRef outputs() As Double) As Boolean
		  Do
		    ClearScreen()
		    stdout.WriteLine("CARDIAC OUTPUT MEASUREMENTS... ")
		    stdout.WriteLine("")
		    stdout.WriteLine("")
		    
		    ' Create temporary file for cardiac outputs
		    Var outputFile As TextOutputStream
		    Try
		      outputFile = TextOutputStream.Create(SpecialFolder.Temporary.Child("COUTPUT.DAT"))
		      
		      Var count As Integer = ConsoleHelpers.AskDouble("HOW MANY CARDIAC OUTPUT MEASUREMENTS ARE THERE")
		      stdout.WriteLine("")
		      
		      Redim outputs(count - 1)
		      
		      For i As Integer = 0 To count - 1
		        Var value As Double = ConsoleHelpers.AskDouble("ENTER VALUE NUMBER ")
		        outputs(i) = value
		        outputFile.WriteLine(value.ToString)
		      Next
		      
		      outputFile.Close
		      
		      If ConsoleHelpers.AskYesNo("ARE YOU HAPPY WITH THESE ENTRIES") Then Return True
		      
		    Catch e As IOException
		      stdout.WriteLine("Error writing cardiac output data: " + e.Message)
		      Return False
		    End Try
		  Loop
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CollectHaemodynamicData(data As HaemodynamicData) As Boolean
		  Do
		    ClearScreen()
		    
		    data.Height = ConsoleHelpers.AskDouble("HEIGHT (CM)")
		    data.Weight = ConsoleHelpers.AskDouble("WEIGHT (KG)")
		    data.HeartRate = ConsoleHelpers.AskDouble("HEART RATE (B/MIN)")
		    
		    stdout.WriteLine("")
		    stdout.WriteLine("N.B.  ALL PRESSURES ARE IN MMHG. ")
		    stdout.WriteLine("")
		    
		    data.ArterialSystolic = ConsoleHelpers.AskDouble("ARTERIAL B.P. - SYSTOLIC")
		    data.ArterialDiastolic = ConsoleHelpers.AskDouble("ARTERIAL B.P. - DIASTOLIC")
		    data.ArterialMean = ConsoleHelpers.AskDouble("ARTERIAL B.P. - MEAN")
		    data.PulmonaryMean = ConsoleHelpers.AskDouble("PULMONARY ARTERIAL PRESSURE - MEAN")
		    data.PulmonaryWedge = ConsoleHelpers.AskDouble("PULMONARY ARTERIAL PRESSURE - WEDGE")
		    data.CVPMean = ConsoleHelpers.AskDouble("CENTRAL VENOUS PRESSURE - MEAN")
		    
		    stdout.WriteLine("")
		    stdout.WriteLine("")
		    
		    If ConsoleHelpers.AskYesNo("ARE THE DATA CORRECT?") Then Return True
		  Loop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CollectOxygenTransportData(data As OxygenTransportData) As Boolean
		  Do
		    ClearScreen()
		    
		    data.Haemoglobin = ConsoleHelpers.AskDouble("WHAT IS THE HAEMOGLOBIN ( GM/DECILITRE )")
		    data.CoreTemperature = ConsoleHelpers.AskDouble("CORE TEMPERATURE......................... ")
		    data.InspiredOxygen = ConsoleHelpers.AskDouble("PERCENT INSPIRED OXYGEN (E.G. 60)........ ")
		    
		    stdout.WriteLine("")
		    stdout.WriteLine("ARTERIAL BLOOD GASES ")
		    stdout.WriteLine("")
		    
		    data.ArterialPH = ConsoleHelpers.AskDouble("PH....................... ")
		    data.ArterialPCO2 = ConsoleHelpers.AskDouble("PCO2..................... ")
		    data.ArterialPO2 = ConsoleHelpers.AskDouble("PO2...................... ")
		    
		    stdout.WriteLine("")
		    stdout.WriteLine("MIXED VENOUS BLOOD GASES ")
		    stdout.WriteLine("")
		    
		    data.VenousPH = ConsoleHelpers.AskDouble("PH........................ ")
		    data.VenousPCO2 = ConsoleHelpers.AskDouble("PCO2...................... ")
		    data.VenousPO2 = ConsoleHelpers.AskDouble("PO2....................... ")
		    
		    stdout.WriteLine("")
		    
		    If ConsoleHelpers.AskYesNo("ARE THE DATA CORRECT?") Then Return True
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CollectPatientData(data As PatientData) As Boolean
		  Do
		    data.Name = ConsoleHelpers.AskText("NAME (E.G. ROBERTS,JOHN....)")
		    data.MRN = ConsoleHelpers.AskText("MEDICAL RECORD NUMBER")
		    data.Date = ConsoleHelpers.AskText("DATE (E.G. 09-04-83)")
		    data.Time = ConsoleHelpers.AskText("TIME (E.G. 21:03 )")
		    
		    stdout.WriteLine("ENTER INOTROPES AND DOSE ")
		    stdout.WriteLine("(e.g. DOPAMINE 5MCG/Kg/min;DOBUTAMINE MCG/Kg/min)")
		    data.Inotropes = ConsoleHelpers.AskText("")
		    
		    stdout.WriteLine("")
		    
		    If ConsoleHelpers.AskYesNo("ARE THE DATA CORRECT?") Then Return True
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CreateDatabaseTables(db As SQLiteDatabase)
		  // Private Sub CreateDatabaseTables(db As SQLiteDatabase)
		  ' Create patients table
		  Var sql As String = _
		  "CREATE TABLE IF NOT EXISTS patients (" + _
		  "id INTEGER PRIMARY KEY AUTOINCREMENT, " + _
		  "name TEXT NOT NULL, " + _
		  "mrn TEXT, " + _
		  "study_date TEXT, " + _
		  "study_time TEXT, " + _
		  "inotropes TEXT, " + _
		  "height REAL, " + _
		  "weight REAL, " + _
		  "heart_rate REAL, " + _
		  "arterial_systolic REAL, " + _
		  "arterial_diastolic REAL, " + _
		  "arterial_mean REAL, " + _
		  "pulmonary_mean REAL, " + _
		  "pulmonary_wedge REAL, " + _
		  "cvp_mean REAL, " + _
		  "cardiac_outputs TEXT, " + _
		  "created_at DATETIME DEFAULT CURRENT_TIMESTAMP" + _
		  ")"
		  
		  db.ExecuteSQL(sql)
		  
		  ' Create results table
		  sql = _
		  "CREATE TABLE IF NOT EXISTS haemodynamic_results (" + _
		  "id INTEGER PRIMARY KEY AUTOINCREMENT, " + _
		  "patient_id INTEGER, " + _
		  "cardiac_output REAL, " + _
		  "cardiac_index REAL, " + _
		  "surface_area REAL, " + _
		  "svr REAL, " + _
		  "pvr REAL, " + _
		  "stroke_index REAL, " + _
		  "lvswi REAL, " + _
		  "rvswi REAL, " + _
		  "left_cardiac_work REAL, " + _
		  "right_cardiac_work REAL, " + _
		  "rate_pressure_product REAL, " + _
		  "coronary_perfusion_pressure REAL, " + _
		  "FOREIGN KEY (patient_id) REFERENCES patients(id)" + _
		  ")"
		  
		  db.ExecuteSQL(sql)
		  
		  ' Create oxygen transport table
		  sql = _
		  "CREATE TABLE IF NOT EXISTS oxygen_transport (" + _
		  "id INTEGER PRIMARY KEY AUTOINCREMENT, " + _
		  "patient_id INTEGER, " + _
		  "haemoglobin REAL, " + _
		  "core_temperature REAL, " + _
		  "inspired_oxygen REAL, " + _
		  "arterial_ph REAL, " + _
		  "arterial_pco2 REAL, " + _
		  "arterial_po2 REAL, " + _
		  "venous_ph REAL, " + _
		  "venous_pco2 REAL, " + _
		  "venous_po2 REAL, " + _
		  "arterial_saturation REAL, " + _
		  "venous_saturation REAL, " + _
		  "arterial_o2_content REAL, " + _
		  "venous_o2_content REAL, " + _
		  "av_difference REAL, " + _
		  "extraction_ratio REAL, " + _
		  "oxygen_delivery REAL, " + _
		  "oxygen_consumption REAL, " + _
		  "alveolar_po2 REAL, " + _
		  "aa_gradient REAL, " + _
		  "aa_ratio REAL, " + _
		  "shunt REAL, " + _
		  "caloric_needs REAL, " + _
		  "FOREIGN KEY (patient_id) REFERENCES patients(id)" + _
		  ")"
		  
		  db.ExecuteSQL(sql)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisplayClinicalInterpretation(results As CalculationResults)
		  ClearScreen()
		  
		  stdout.WriteLine("CLINICAL INTERPRETATION")
		  stdout.WriteLine("======================")
		  stdout.WriteLine("")
		  
		  stdout.WriteLine("HEMODYNAMIC ANALYSIS:")
		  stdout.WriteLine("--------------------")
		  stdout.WriteLine("Cardiac Index........." + ClinicalInterpreter.InterpretCardiacIndex(results.CardiacIndex))
		  stdout.WriteLine("Vascular Resistance..." + ClinicalInterpreter.InterpretSVR(results.SystemicVascularResistance))
		  stdout.WriteLine("")
		  
		  If results.ExtractionRatio > 0 Then ' Only if oxygen transport was measured
		    stdout.WriteLine("OXYGEN TRANSPORT ANALYSIS:")
		    stdout.WriteLine("-------------------------")
		    stdout.WriteLine("O2 Extraction........." + ClinicalInterpreter.InterpretOxygenExtraction(results.ExtractionRatio))
		    stdout.WriteLine("Mixed Venous Sat......" + ClinicalInterpreter.InterpretMixedVenousSat(results.VenousSaturation))
		    stdout.WriteLine("")
		  End If
		  
		  stdout.WriteLine("OVERALL ASSESSMENT:")
		  stdout.WriteLine("------------------")
		  stdout.WriteLine(ClinicalInterpreter.GenerateOverallAssessment(results))
		  stdout.WriteLine("")
		  
		  ' Treatment suggestions
		  Var suggestions() As String = ClinicalInterpreter.GetTreatmentSuggestions(results)
		  If suggestions.Count > 0 Then
		    stdout.WriteLine("TREATMENT CONSIDERATIONS:")
		    stdout.WriteLine("------------------------")
		    For Each suggestion As String In suggestions
		      stdout.WriteLine("• " + suggestion)
		    Next
		    stdout.WriteLine("")
		  End If
		  
		  stdout.WriteLine("*** CLINICAL CORRELATION REQUIRED ***")
		  stdout.WriteLine("These interpretations are computer-generated")
		  stdout.WriteLine("and must be correlated with clinical findings.")
		  stdout.WriteLine("")
		  
		  ConsoleHelpers.PauseForNext()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisplayOxygenTransportResults(oxygen As OxygenTransportData, results As CalculationResults)
		  ClearScreen()
		  
		  stdout.WriteLine("OXYGEN TRANSPORT STUDIES - PATIENT DATA")
		  stdout.WriteLine("---------------------------------------")
		  stdout.WriteLine("")
		  stdout.WriteLine("HAEMOGLOBIN ( GM/dL ).. " + Format(oxygen.Haemoglobin, "####.#"))
		  stdout.WriteLine("CORE TEMP.............. " + Format(oxygen.CoreTemperature, "####.#") + " Deg.C.     ")
		  stdout.WriteLine("INSPIRED OXYGEN........ " + Format(oxygen.InspiredOxygen, "###") + " %")
		  stdout.WriteLine("")
		  stdout.WriteLine("ARTERIAL BLOOD GASES           MIXED VENOUS BLOOD GASES ")
		  stdout.WriteLine("--------------------           ------------------------ ")
		  stdout.WriteLine("")
		  stdout.WriteLine("PH.................. " + Format(oxygen.ArterialPH, "####.##") + "    PH.................. " + Format(oxygen.VenousPH, "####.##"))
		  stdout.WriteLine("PCO2................ " + Format(oxygen.ArterialPCO2, "#######") + "    PCO2................ " + Format(oxygen.VenousPCO2, "#######"))
		  stdout.WriteLine("PO2................. " + Format(oxygen.ArterialPO2, "#######") + "    PO2................. " + Format(oxygen.VenousPO2, "#######"))
		  
		  ConsoleHelpers.PauseForNext()
		  ClearScreen()
		  
		  stdout.WriteLine("RESULTS")
		  stdout.WriteLine("-------")
		  stdout.WriteLine("")
		  stdout.WriteLine("A-V DO2................ " + Format(results.AVDifference, "####.##") + " (N = 4-5.5 ML/DL)")
		  stdout.WriteLine("O2 DELIVERY............ " + Format(results.OxygenDelivery, "#######") + " (N = 520-720 ML/MIN.M^2)")
		  stdout.WriteLine("O2 CONSUMPTION......... " + Format(results.OxygenConsumption, "#######") + " (N = 100-180 ML/MIN.M^2)")
		  stdout.WriteLine("O2 EXTRACTION RATIO.... " + Format(results.ExtractionRatio, "#######") + " (N = 22-30 %)")
		  stdout.WriteLine("CALORIC NEEDS..........  " + results.CaloricNeeds.ToString + " CALORIES PER DAY ")
		  stdout.WriteLine("ALVEOLAR-ARTERIAL DO2.. " + Format(results.AAGradient, "#######") + " (N = 0-100:FIO2 =1.0;0-20:FIO2 = 0.21)")
		  stdout.WriteLine("ARTERIAL-ALVEOLAR RATIO" + Format(results.AARatio, "#######") + " %")
		  stdout.WriteLine("PULMONARY SHUNT........ " + Format(results.Shunt, "#######") + " %")
		  
		  ConsoleHelpers.PauseForNext()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisplayToPrinter(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)
		  // Create and open the text file for writing
		  Var file As FolderItem 
		  file = SpecialFolder.Documents.Child("ICU_Report.txt")
		  var textFile As TextOutputStream = TextOutputStream.Create(file)
		  
		  
		  ' Header
		  textFile.WriteLine(" I.C.U. Haemodynamics and Oxygen Transport Report")
		  textFile.WriteLine("--------------------------------")
		  textFile.WriteLine("")
		  textFile.WriteLine(patient.Name + "             M.R.N. " + patient.MRN)
		  textFile.WriteLine("TIME  " + patient.Time + " HOURS")
		  textFile.WriteLine("DATE   " + patient.Date)
		  textFile.WriteLine("")
		  textFile.WriteLine("HAEMODYNAMICS AND OXYGEN TRANSPORT STUDIES")
		  textFile.WriteLine("------------------------------------------")
		  textFile.WriteLine("HAEMODYNAMICS - PATIENT DATA")
		  textFile.WriteLine("----------------------------")
		  textFile.WriteLine("")
		  
		  ' Patient data
		  textFile.WriteLine("INOTROPES " + patient.Inotropes)
		  textFile.WriteLine("HEART RATE (B/MIN).................. " + Format(haemo.HeartRate, "###"))
		  textFile.WriteLine("ARTERIAL B.P. - SYSTOLIC............ " + Format(haemo.ArterialSystolic, "###") + " MM.HG. ")
		  textFile.WriteLine("ARTERIAL B.P. - DIASTOLIC........... " + Format(haemo.ArterialDiastolic, "###") + " MM.HG. ")
		  textFile.WriteLine("ARTERIAL B.P. - MEAN................ " + Format(haemo.ArterialMean, "###") + " MM.HG. ")
		  textFile.WriteLine("PULMONARY ARTERIAL PRESSURE - MEAN.. " + Format(haemo.PulmonaryMean, "###") + " MM.HG. ")
		  textFile.WriteLine("PULMONARY ARTERIAL PRESSURE - WEDGE. " + Format(haemo.PulmonaryWedge, "###") + " MM.HG. ")
		  textFile.WriteLine("CENTRAL VENOUS PRESSURE - MEAN...... " + Format(haemo.CVPMean, "###") + " MM.HG. ")
		  textFile.WriteLine("HEIGHT (CM).... " + Format(haemo.Height, "###") + "    WEIGHT (KG)... " + Format(haemo.Weight, "###"))
		  
		  
		  ' Results
		  textFile.WriteLine("RESULTS")
		  textFile.WriteLine("-------")
		  textFile.WriteLine("")
		  textFile.WriteLine("SURFACE AREA................. " + Format(results.SurfaceArea, "####.##") + " SQ. METRES")
		  
		  stdout.Write("CARDIAC OUTPUTS MEASURED.....  ")
		  For Each output As Double In outputs
		    stdout.Write(output.ToString + ";")
		  Next
		  textFile.WriteLine("L/MIN. ")
		  
		  textFile.WriteLine("CARDIAC OUTPUT............... " + Format(results.CardiacOutput, "####.##") + " L/MIN. ")
		  textFile.WriteLine("CARDIAC INDEX................ " + Format(results.CardiacIndex, "####.##") + " (N = 2.8-3.6)")
		  textFile.WriteLine("SYSTEMIC VASCULAR RESISTANCE. " + Format(results.SystemicVascularResistance, "#######") + " (N = 1760-2600 DYNE.CM/SEC)")
		  textFile.WriteLine("PULMONARY VASCULAR RESISTANCE" + Format(results.PulmonaryVascularResistance, "#######") + " (N =  45 - 225 DYNE.CM/SEC)")
		  textFile.WriteLine("STROKE INDEX................. " + Format(results.StrokeIndex, "#######") + " (N = 30-50 ML/M^2)")
		  textFile.WriteLine("L.V.S.W.I.................... " + Format(results.LVSWI, "#######") + " (N = 44-68 G.M./BEAT.M^2)")
		  textFile.WriteLine("R.V.S.W.I.................... " + Format(results.RVSWI, "#######") + " (N =  4-8  G.M./BEAT.M^2)")
		  textFile.WriteLine("LEFT CARDIAC WORK............ " + Format(results.LeftCardiacWork, "####.##") + "(N = 3.0-4.6; D> 5.1KG.M/M^2)")
		  textFile.WriteLine("RIGHT CARDIAC WORK........... " + Format(results.RightCardiacWork, "####.##") + "(N = 0.4-0.6 KG.M./M^2)")
		  textFile.WriteLine("RATE - PRESSURE PRODUCT...... " + Format(results.RatePressureProduct, "#######"))
		  textFile.WriteLine("CORONARY PERFUSION PRESSURE.. " + Format(results.CoronaryPerfusionPressure, "#######") + " MM.HG. ")
		  
		  textFile.WriteLine("")
		  textFile.WriteLine("-------------------------------------------------")
		  textFile.WriteLine("OXYGEN TRANSPORT STUDIES - PATIENT DATA")
		  textFile.WriteLine("-------------------------------------------------")
		  textFile.WriteLine("")
		  textFile.WriteLine("HAEMOGLOBIN ( GM/dL ).. " + Format(oxygen.Haemoglobin, "####.#"))
		  textFile.WriteLine("CORE TEMP.............. " + Format(oxygen.CoreTemperature, "####.#") + " Deg.C.     ")
		  textFile.WriteLine("INSPIRED OXYGEN........ " + Format(oxygen.InspiredOxygen, "###") + " %")
		  textFile.WriteLine("")
		  textFile.WriteLine("ARTERIAL BLOOD GASES           MIXED VENOUS BLOOD GASES ")
		  textFile.WriteLine("--------------------           ------------------------ ")
		  textFile.WriteLine("")
		  textFile.WriteLine("PH.................. " + Format(oxygen.ArterialPH, "####.##") + "    PH.................. " + Format(oxygen.VenousPH, "####.##"))
		  textFile.WriteLine("PCO2................ " + Format(oxygen.ArterialPCO2, "#######") + "    PCO2................ " + Format(oxygen.VenousPCO2, "#######"))
		  textFile.WriteLine("PO2................. " + Format(oxygen.ArterialPO2, "#######") + "    PO2................. " + Format(oxygen.VenousPO2, "#######"))
		  
		  
		  textFile.WriteLine("RESULTS")
		  textFile.WriteLine("-------")
		  textFile.WriteLine("")
		  textFile.WriteLine("A-V DO2................ " + Format(results.AVDifference, "####.##") + " (N = 4-5.5 ML/DL)")
		  textFile.WriteLine("O2 DELIVERY............ " + Format(results.OxygenDelivery, "#######") + " (N = 520-720 ML/MIN.M^2)")
		  textFile.WriteLine("O2 CONSUMPTION......... " + Format(results.OxygenConsumption, "#######") + " (N = 100-180 ML/MIN.M^2)")
		  textFile.WriteLine("O2 EXTRACTION RATIO.... " + Format(results.ExtractionRatio, "#######") + " (N = 22-30 %)")
		  textFile.WriteLine("CALORIC NEEDS..........  " + results.CaloricNeeds.ToString + " CALORIES PER DAY ")
		  textFile.WriteLine("ALVEOLAR-ARTERIAL DO2.. " + Format(results.AAGradient, "#######") + " (N = 0-100:FIO2 =1.0;0-20:FIO2 = 0.21)")
		  textFile.WriteLine("ARTERIAL-ALVEOLAR RATIO" + Format(results.AARatio, "#######") + " %")
		  textFile.WriteLine("PULMONARY SHUNT........ " + Format(results.Shunt, "#######") + " %")
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisplayToScreen(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)
		  ClearScreen()
		  
		  ' Header
		  stdout.WriteLine(" I.C.U. Haemodynamics and Oxygen Transport Report")
		  stdout.WriteLine("--------------------------------")
		  stdout.WriteLine("")
		  stdout.WriteLine(patient.Name + "             M.R.N. " + patient.MRN)
		  stdout.WriteLine("TIME  " + patient.Time + " HOURS")
		  stdout.WriteLine("DATE   " + patient.Date)
		  stdout.WriteLine("")
		  stdout.WriteLine("HAEMODYNAMICS AND OXYGEN TRANSPORT STUDIES")
		  stdout.WriteLine("------------------------------------------")
		  stdout.WriteLine("HAEMODYNAMICS - PATIENT DATA")
		  stdout.WriteLine("----------------------------")
		  stdout.WriteLine("")
		  
		  ' Patient data
		  stdout.WriteLine("INOTROPES " + patient.Inotropes)
		  stdout.WriteLine("HEART RATE (B/MIN).................. " + Format(haemo.HeartRate, "###"))
		  stdout.WriteLine("ARTERIAL B.P. - SYSTOLIC............ " + Format(haemo.ArterialSystolic, "###") + " MM.HG. ")
		  stdout.WriteLine("ARTERIAL B.P. - DIASTOLIC........... " + Format(haemo.ArterialDiastolic, "###") + " MM.HG. ")
		  stdout.WriteLine("ARTERIAL B.P. - MEAN................ " + Format(haemo.ArterialMean, "###") + " MM.HG. ")
		  stdout.WriteLine("PULMONARY ARTERIAL PRESSURE - MEAN.. " + Format(haemo.PulmonaryMean, "###") + " MM.HG. ")
		  stdout.WriteLine("PULMONARY ARTERIAL PRESSURE - WEDGE. " + Format(haemo.PulmonaryWedge, "###") + " MM.HG. ")
		  stdout.WriteLine("CENTRAL VENOUS PRESSURE - MEAN...... " + Format(haemo.CVPMean, "###") + " MM.HG. ")
		  stdout.WriteLine("HEIGHT (CM).... " + Format(haemo.Height, "###") + "    WEIGHT (KG)... " + Format(haemo.Weight, "###"))
		  
		  ConsoleHelpers.PauseForNext()
		  ClearScreen()
		  
		  ' Results
		  stdout.WriteLine("RESULTS")
		  stdout.WriteLine("-------")
		  stdout.WriteLine("")
		  stdout.WriteLine("SURFACE AREA................. " + Format(results.SurfaceArea, "####.##") + " SQ. METRES")
		  
		  stdout.Write("CARDIAC OUTPUTS MEASURED.....  ")
		  For Each output As Double In outputs
		    stdout.Write(output.ToString + ";")
		  Next
		  stdout.WriteLine("L/MIN. ")
		  
		  stdout.WriteLine("CARDIAC OUTPUT............... " + Format(results.CardiacOutput, "####.##") + " L/MIN. ")
		  stdout.WriteLine("CARDIAC INDEX................ " + Format(results.CardiacIndex, "####.##") + " (N = 2.8-3.6)")
		  stdout.WriteLine("SYSTEMIC VASCULAR RESISTANCE. " + Format(results.SystemicVascularResistance, "#######") + " (N = 1760-2600 DYNE.CM/SEC)")
		  stdout.WriteLine("PULMONARY VASCULAR RESISTANCE" + Format(results.PulmonaryVascularResistance, "#######") + " (N =  45 - 225 DYNE.CM/SEC)")
		  stdout.WriteLine("STROKE INDEX................. " + Format(results.StrokeIndex, "#######") + " (N = 30-50 ML/M^2)")
		  stdout.WriteLine("L.V.S.W.I.................... " + Format(results.LVSWI, "#######") + " (N = 44-68 G.M./BEAT.M^2)")
		  stdout.WriteLine("R.V.S.W.I.................... " + Format(results.RVSWI, "#######") + " (N =  4-8  G.M./BEAT.M^2)")
		  stdout.WriteLine("LEFT CARDIAC WORK............ " + Format(results.LeftCardiacWork, "####.##") + "(N = 3.0-4.6; D> 5.1KG.M/M^2)")
		  stdout.WriteLine("RIGHT CARDIAC WORK........... " + Format(results.RightCardiacWork, "####.##") + "(N = 0.4-0.6 KG.M./M^2)")
		  stdout.WriteLine("RATE - PRESSURE PRODUCT...... " + Format(results.RatePressureProduct, "#######"))
		  stdout.WriteLine("CORONARY PERFUSION PRESSURE.. " + Format(results.CoronaryPerfusionPressure, "#######") + " MM.HG. ")
		  
		  If includeOxygen Then
		    ConsoleHelpers.PauseForNext()
		    DisplayOxygenTransportResults(oxygen, results)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getOutputChoice() As String
		  
		  ClearScreen()
		  stdout.WriteLine("DO YOU WANT THE OUTPUT TO GO TO ........<S>CREEN ")
		  stdout.WriteLine("")
		  stdout.WriteLine("                                ........<P>RINTER")
		  stdout.WriteLine("")
		  stdout.WriteLine("                                ........<D>ISK")
		  stdout.WriteLine("")
		  stdout.WriteLine("                                ........<I>NTERPRETATION")
		  stdout.WriteLine("")
		  stdout.WriteLine("")
		  stdout.WriteLine("        Enter the letter corresponding to your choice  ")
		  
		  Return ConsoleHelpers.AskText("").Lowercase
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleError(e As RuntimeException)
		  
		  ClearScreen()
		  stdout.WriteLine("")
		  stdout.WriteLine("      AN ERROR HAS OCCURRED:")
		  stdout.WriteLine("      " + e.Message)
		  stdout.WriteLine("")
		  stdout.WriteLine("      YOU WILL BE TAKEN BACK TO THE MAIN MENU")
		  stdout.WriteLine("")
		  stdout.WriteLine("      PLEASE DO NOT TRY THAT AGAIN!")
		  stdout.WriteLine("")
		  
		  ' Simple pause
		  For i As Integer = 1 To 1500
		    ' Pause
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleOutput(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)
		  
		  Do
		    Var choice As String = GetOutputChoice()
		    
		    Select Case choice
		    Case "s"
		      DisplayToScreen(patient, haemo, outputs, oxygen, results, includeOxygen)
		      Exit
		    Case "p"
		      DisplayToPrinter(patient, haemo, outputs, oxygen, results, includeOxygen)
		      Exit
		    Case "d"
		      SaveToDisk(patient, haemo, outputs, oxygen, results, includeOxygen)
		      Exit
		    Case "i"
		      DisplayClinicalInterpretation(results)
		      Exit
		    Case Else
		      ShowInvalidChoiceMessage()
		    End Select
		  Loop
		  
		  If ConsoleHelpers.AskYesNo("DO YOU WANT TO REVIEW THIS DATA?") Then
		    HandleOutput(patient, haemo, outputs, oxygen, results, includeOxygen)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InsertOxygenTransportRecord(db As SQLiteDatabase, patientID As Integer, oxygen As OxygenTransportData, results As CalculationResults)
		  // Private Sub InsertOxygenTransportRecord(db As SQLiteDatabase, patientID As Integer, oxygen As OxygenTransportData, results As CalculationResults)
		  Var sql As String = _
		  "INSERT INTO oxygen_transport (patient_id, haemoglobin, core_temperature, inspired_oxygen, " + _
		  "arterial_ph, arterial_pco2, arterial_po2, venous_ph, venous_pco2, venous_po2, " + _
		  "arterial_saturation, venous_saturation, arterial_o2_content, venous_o2_content, " + _
		  "av_difference, extraction_ratio, oxygen_delivery, oxygen_consumption, alveolar_po2, " + _
		  "aa_gradient, aa_ratio, shunt, caloric_needs) VALUES " + _
		  "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		  
		  db.ExecuteSQL(sql, patientID, oxygen.Haemoglobin, oxygen.CoreTemperature, oxygen.InspiredOxygen, _
		  oxygen.ArterialPH, oxygen.ArterialPCO2, oxygen.ArterialPO2, oxygen.VenousPH, oxygen.VenousPCO2, _
		  oxygen.VenousPO2, results.ArterialSaturation, results.VenousSaturation, results.ArterialO2Content, _
		  results.VenousO2Content, results.AVDifference, results.ExtractionRatio, results.OxygenDelivery, _
		  results.OxygenConsumption, results.AlveolarPO2, results.AAGradient, results.AARatio, _
		  results.Shunt, results.CaloricNeeds)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function InsertPatientRecord(db As SQLiteDatabase, patient As PatientData, haemo As HaemodynamicData, outputs() As Double, results As CalculationResults, includeOxygen As Boolean) As Integer
		  // Private Function InsertPatientRecord(db As SQLiteDatabase, patient As PatientData, haemo As HaemodynamicData, outputs() As Double, results As CalculationResults, includeOxygen As Boolean) As Integer
		  ' Convert cardiac outputs to comma-separated string
		  Var outputsStr As String = ""
		  For Each output As Double In outputs
		    If outputsStr <> "" Then outputsStr = outputsStr + ","
		    outputsStr = outputsStr + output.ToString
		  Next
		  
		  ' Insert patient data
		  Var sql As String = _
		  "INSERT INTO patients (name, mrn, study_date, study_time, inotropes, height, weight, " + _
		  "heart_rate, arterial_systolic, arterial_diastolic, arterial_mean, pulmonary_mean, " + _
		  "pulmonary_wedge, cvp_mean, cardiac_outputs) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		  
		  db.ExecuteSQL(sql, patient.Name, patient.MRN, patient.Date, patient.Time, patient.Inotropes, _
		  haemo.Height, haemo.Weight, haemo.HeartRate, haemo.ArterialSystolic, haemo.ArterialDiastolic, _
		  haemo.ArterialMean, haemo.PulmonaryMean, haemo.PulmonaryWedge, haemo.CVPMean, outputsStr)
		  
		  Var patientID As Integer = db.LastRowID
		  
		  ' Insert haemodynamic results
		  sql = _
		  "INSERT INTO haemodynamic_results (patient_id, cardiac_output, cardiac_index, surface_area, " + _
		  "svr, pvr, stroke_index, lvswi, rvswi, left_cardiac_work, right_cardiac_work, " + _
		  "rate_pressure_product, coronary_perfusion_pressure) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		  
		  db.ExecuteSQL(sql, patientID, results.CardiacOutput, results.CardiacIndex, results.SurfaceArea, _
		  results.SystemicVascularResistance, results.PulmonaryVascularResistance, results.StrokeIndex, _
		  results.LVSWI, results.RVSWI, results.LeftCardiacWork, results.RightCardiacWork, _
		  results.RatePressureProduct, results.CoronaryPerfusionPressure)
		  
		  Return patientID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RunClinicalStudy() As Boolean
		  
		  stdout.WriteLine("HAEMODYNAMICS")
		  stdout.WriteLine("-------------")
		  
		  ' Patient demographic data
		  Var patientData As New PatientData
		  If Not CollectPatientData(patientData) Then Return True ' User wants to restart
		  
		  ' Haemodynamic measurements
		  Var haemoData As New HaemodynamicData
		  If Not CollectHaemodynamicData(haemoData) Then Return True ' User wants to restart
		  
		  ' Cardiac output measurements
		  Var cardiacOutputs() As Double
		  If Not CollectCardiacOutputs(cardiacOutputs) Then Return True ' User wants to restart
		  
		  ' Calculate basic haemodynamic parameters
		  Var results As New CalculationResults
		  CalculateHaemodynamics(patientData, haemoData, cardiacOutputs, results)
		  
		  ' Optional oxygen transport studies
		  Var oxygenData As New OxygenTransportData
		  Var includeOxygen As Boolean = ConsoleHelpers.AskYesNo("WOULD YOU LIKE TO TEST OXYGEN TRANSPORT?")
		  
		  If includeOxygen Then
		    If Not CollectOxygenTransportData(oxygenData) Then Return True
		    CalculateOxygenTransport(patientData, haemoData, oxygenData, results)
		  End If
		  
		  ' Review data option
		  If ConsoleHelpers.AskYesNo("DO YOU WANT TO CHECK THE DATA SO FAR") Then
		    ShowDataReview(patientData, haemoData, cardiacOutputs, oxygenData, includeOxygen)
		    If ConsoleHelpers.AskYesNo("DO YOU WANT TO MAKE ANY CHANGES?") Then
		      Return True ' Restart data collection
		    End If
		  End If
		  
		  ' Output selection and display
		  HandleOutput(patientData, haemoData, cardiacOutputs, oxygenData, results, includeOxygen)
		  
		  ' Ask if user wants to continue
		  Return ConsoleHelpers.AskYesNo("DO YOU WANT TO INPUT MORE DATA?")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SaveToDisk(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)
		  //Private Sub SaveToDisk(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)
		  stdout.WriteLine("NOW PROCESSING RECORDS.......")
		  stdout.WriteLine("")
		  stdout.WriteLine("         Please be patient.")
		  
		  Try
		    ' Create or open database
		    Var dbFile As FolderItem = SpecialFolder.Documents.Child("HaemodynamicsData.sqlite")
		    Var db As SQLiteDatabase = New SQLiteDatabase
		    db.DatabaseFile = dbFile
		    
		    Try
		      db.CreateDatabase
		    Catch error As IOException
		      System.DebugLog("The database file could not be created: " + error.Message)
		      
		    Catch ex As DatabaseException
		      stdout.WriteLine("Database error: " + ex.Message)
		      
		    Catch ex As RuntimeException
		      stdout.WriteLine("Runtime error: " + ex.Message)
		      
		    End Try
		    
		    ' Create tables if they don't exist
		    CreateDatabaseTables(db)
		    
		    ' Insert patient record
		    Var patientID As Integer = InsertPatientRecord(db, patient, haemo, outputs, results, includeOxygen)
		    
		    'If includeOxygen Then
		    InsertOxygenTransportRecord(db, patientID, oxygen, results)
		    'End If
		    
		    db.Close
		    
		    stdout.WriteLine("")
		    stdout.WriteLine("Data saved successfully to: " + dbFile.NativePath)
		    stdout.WriteLine("Record ID: " + patientID.ToString)
		    
		  Catch e As DatabaseException
		    stdout.WriteLine("Database Error: " + e.Message)
		  Catch e As RuntimeException
		    stdout.WriteLine("Error saving data: " + e.Message)
		  End Try
		  
		  stdout.WriteLine("")
		  ConsoleHelpers.PauseForNext()
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ShowDataReview(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, includeOxygen As Boolean)
		  ClearScreen()
		  
		  stdout.WriteLine("NAME: " + patient.Name)
		  stdout.WriteLine("MEDICAL RECORD NUMBER: " + patient.MRN)
		  stdout.WriteLine("TIME: " + patient.Time + " HOURS   DATE: " + patient.Date)
		  stdout.WriteLine("INOTROPES: " + patient.Inotropes)
		  stdout.WriteLine("")
		  stdout.WriteLine("HEIGHT: " + haemo.Height.ToString + " cm.     WEIGHT: " + haemo.Weight.ToString + " Kg. ")
		  stdout.WriteLine("HEART RATE: " + haemo.HeartRate.ToString + " B.P.M. ")
		  stdout.WriteLine("ARTERIAL B.P.: ....SYSTOLIC: " + haemo.ArterialSystolic.ToString + " mmHg. ")
		  stdout.WriteLine("               ...DIASTOLIC: " + haemo.ArterialDiastolic.ToString + " mmHg. ")
		  stdout.WriteLine("               ........MEAN: " + haemo.ArterialMean.ToString + " mmHg. ")
		  stdout.WriteLine("P. A. PRESSURES: ......MEAN: " + haemo.PulmonaryMean.ToString + " mmHg. ")
		  stdout.WriteLine("                 .....WEDGE: " + haemo.PulmonaryWedge.ToString + " mmHg. ")
		  stdout.WriteLine("C.V.P.: ...............MEAN: " + haemo.CVPMean.ToString + " mmHg. ")
		  stdout.WriteLine("")
		  
		  stdout.Write("CARDIAC OUTPUTS MEASURED: ")
		  For Each output As Double In outputs
		    stdout.Write(output.ToString + ";")
		  Next
		  stdout.WriteLine("L/min. ")
		  
		  ConsoleHelpers.PauseForNext()
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ShowIntroduction()
		  
		  
		  stdout.WriteLine(" HAEMODYNAMICS AND OXYGEN TRANSPORT STUDIES ")
		  stdout.WriteLine("")
		  stdout.WriteLine("                         <V 3.7> 20-OCT-85")
		  stdout.WriteLine("")
		  stdout.WriteLine("                         <C>  P.H.V. CUMPSTON ")
		  stdout.WriteLine("")
		  stdout.WriteLine("                              JHLConsultants")
		  stdout.WriteLine("")
		  stdout.WriteLine("")
		  stdout.WriteLine("")
		  stdout.WriteLine("")
		  stdout.WriteLine(" PLEASE ENTER THE DATA AS REQUESTED..... ")
		  stdout.WriteLine("")
		  
		  ' Brief pause
		  For i As Integer = 1 To 1500
		    ' Pause loop
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ShowInvalidChoiceMessage()
		  
		  stdout.WriteLine("Please enter S, P, D, or I")
		  stdout.WriteLine("")
		  ConsoleHelpers.PauseForNext()
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Range of values
		Haemodynamic and Oxygen Transport Reference Values
		
		Normal Reference Ranges
		
		Basic Haemodynamic Parameters
		
		Parameter    Normal Range    Units
		Cardiac Index (CI)    2.8 - 3.6    L/min/m²
		Cardiac Output    4.0 - 8.0    L/min
		Stroke Volume Index    30 - 50    mL/m²
		Heart Rate    60 - 100    beats/min
		Mean Arterial Pressure    70 - 105    mmHg
		Central Venous Pressure    2 - 8    mmHg
		Pulmonary Artery Pressure    15 - 30/4 - 12    mmHg (systolic/diastolic)
		Pulmonary Capillary Wedge Pressure    6 - 12    mmHg
		Vascular Resistance
		Parameter    Normal Range    Units
		Systemic Vascular Resistance (SVR)    1760 - 2600    dyne·s/cm⁵
		Pulmonary Vascular Resistance (PVR)    45 - 225    dyne·s/cm⁵
		Cardiac Work Indices
		Parameter    Normal Range    Units
		Left Ventricular Stroke Work Index (LVSWI)    44 - 68    g·m/beat/m²
		Right Ventricular Stroke Work Index (RVSWI)    4 - 8    g·m/beat/m²
		Left Cardiac Work Index    3.0 - 4.6    kg·m/min/m²
		Right Cardiac Work Index    0.4 - 0.6    kg·m/min/m²
		Oxygen Transport Parameters
		Parameter    Normal Range    Units
		Oxygen Delivery (DO₂I)    520 - 720    mL/min/m²
		Oxygen Consumption (VO₂I)    100 - 180    mL/min/m²
		Arteriovenous O₂ Content Difference    4.0 - 5.5    mL/dL
		Oxygen Extraction Ratio    22 - 30    %
		Arterial Oxygen Saturation    > 95    %
		Mixed Venous Oxygen Saturation    65 - 75    %
		Alveolar-Arterial O₂ Gradient    < 20 (room air), < 100 (100% O₂)    mmHg
		Pulmonary Shunt    < 5    %
		
		Sepsis/Septic Shock Values
		
		Early Sepsis (Hyperdynamic Phase)
		Parameter    Typical Values    Direction
		Cardiac Index    4.0 - 6.0+    ↑ Increased
		Heart Rate    100 - 140+    ↑ Increased
		Mean Arterial Pressure    65 - 90    ↓ Decreased
		Central Venous Pressure    Variable    ↑/↓ Variable
		Systemic Vascular Resistance    800 - 1200    ↓ Decreased
		Stroke Volume Index    35 - 50    Normal/↑
		
		Late Sepsis/Septic Shock (Hypodynamic Phase)
		
		Parameter    Typical Values    Direction
		Cardiac Index    < 2.2    ↓ Decreased
		Heart Rate    120 - 160+    ↑ Increased
		Mean Arterial Pressure    < 65    ↓ Decreased
		Systemic Vascular Resistance    < 800    ↓ Severely decreased
		Stroke Volume Index    < 30    ↓ Decreased
		Oxygen Transport in Sepsis
		Parameter    Sepsis Values    Normal    Notes
		Oxygen Delivery    Often > 600    520-720    Initially increased due to high CO
		Oxygen Consumption    Variable    100-180    May be elevated or impaired
		O₂ Extraction Ratio    Often < 22%    22-30%    Impaired cellular extraction
		Mixed Venous Sat    Often > 70%    65-75%    Paradoxically high due to poor extraction
		Lactate    > 2.0 mmol/L    < 2.0    Marker of tissue hypoperfusion
		
		Example Patient Scenarios
		
		Normal Healthy Adult (70kg, 1.8m²)
		Cardiac Output: 5.0 L/min
		Cardiac Index: 2.8 L/min/m²
		SVR: 1920 dyne·s/cm⁵
		LVSWI: 50 g·m/beat/m²
		DO₂I: 600 mL/min/m²
		VO₂I: 150 mL/min/m²
		O₂ Extraction: 25%
		
		Early Sepsis Patient
		Cardiac Output: 8.5 L/min (high)
		Cardiac Index: 4.7 L/min/m² (high)
		SVR: 950 dyne·s/cm⁵ (low)
		LVSWI: 45 g·m/beat/m² (normal/low)
		DO₂I: 750 mL/min/m² (high)
		VO₂I: 140 mL/min/m² (normal)
		O₂ Extraction: 18% (low)
		Mixed Venous Sat: 78% (high)
		Late Septic Shock Patient
		Cardiac Output: 3.5 L/min (low)
		Cardiac Index: 1.9 L/min/m² (low)
		SVR: 650 dyne·s/cm⁵ (very low)
		LVSWI: 25 g·m/beat/m² (low)
		DO₂I: 380 mL/min/m² (low)
		VO₂I: 120 mL/min/m² (low)
		O₂ Extraction: 32% (high)
		Lactate: 4.5 mmol/L (high)
		
		Clinical Interpretation Notes
		Sepsis Pathophysiology
		Early Phase: Vasodilation → decreased SVR → compensatory increased CO
		Progressive Phase: Myocardial depression → decreased contractility
		Late Phase: Circulatory failure → multi-organ dysfunction
		
		Key Diagnostic Indicators
		Hyperdynamic circulation: High CO, low SVR, warm extremities
		Hypodynamic circulation: Low CO, persistent low SVR, cold extremities
		Cellular dysfunction: Poor O₂ extraction despite adequate delivery
		Distributive shock: Normal/high mixed venous saturation with elevated lactate
		Treatment Targets in Sepsis
		Mean Arterial Pressure: ≥ 65 mmHg
		Central Venous Pressure: 8-12 mmHg
		Mixed Venous Saturation: ≥ 70%
		Urine Output: ≥ 0.5 mL/kg/hr
		Lactate: < 2.0 mmol/L (or decreasing trend)
		
		
	#tag EndNote


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
