# HaemO2

## Project Overview

This Xojo project contains the following components:

## Project Components

- **Classes:** 5 (App, PatientData, HaemodynamicData, OxygenTransportData, CalculationResults)
- **Modules:** 2 (ConsoleHelpers, ClinicalInterpreter)

## Classes

### App

#### Properties

None

#### Methods

- **`CalculateHaemodynamics`** Private Sub
  - **Parameters:** `patient As PatientData, haemo As HaemodynamicData, outputs() As Double, results As CalculationResults`
  - **Signature:** `Private Sub CalculateHaemodynamics(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, results As CalculationResults)`

- **`CalculateOxygenSaturation`** Private Function
  - **Parameters:** `PO2 As Double, pH As Double, PCO2 As Double, temperature As Double`
  - **Returns:** `Double`
  - **Signature:** `Private Function CalculateOxygenSaturation(PO2 As Double, pH As Double, PCO2 As Double, temperature As Double) As Double`

- **`CalculateOxygenTransport`** Private Sub
  - **Parameters:** `patient As PatientData, haemo As HaemodynamicData, oxygen As OxygenTransportData, results As CalculationResults`
  - **Signature:** `Private Sub CalculateOxygenTransport(patient As PatientData, haemo As HaemodynamicData, oxygen As OxygenTransportData, results As CalculationResults)`

- **`ClearScreen`** Private Sub
  - **Signature:** `Private Sub ClearScreen()`

- **`CollectCardiacOutputs`** Private Function
  - **Parameters:** `ByRef outputs() As Double`
  - **Returns:** `Boolean`
  - **Signature:** `Private Function CollectCardiacOutputs(ByRef outputs() As Double) As Boolean`

- **`CollectHaemodynamicData`** Private Function
  - **Parameters:** `data As HaemodynamicData`
  - **Returns:** `Boolean`
  - **Signature:** `Private Function CollectHaemodynamicData(data As HaemodynamicData) As Boolean`

- **`CollectOxygenTransportData`** Private Function
  - **Parameters:** `data As OxygenTransportData`
  - **Returns:** `Boolean`
  - **Signature:** `Private Function CollectOxygenTransportData(data As OxygenTransportData) As Boolean`

- **`CollectPatientData`** Private Function
  - **Parameters:** `data As PatientData`
  - **Returns:** `Boolean`
  - **Signature:** `Private Function CollectPatientData(data As PatientData) As Boolean`

- **`CreateDatabaseTables`** Private Sub
  - **Parameters:** `db As SQLiteDatabase`
  - **Signature:** `Private Sub CreateDatabaseTables(db As SQLiteDatabase)`

- **`DisplayClinicalInterpretation`** Private Sub
  - **Parameters:** `results As CalculationResults`
  - **Signature:** `Private Sub DisplayClinicalInterpretation(results As CalculationResults)`

- **`DisplayOxygenTransportResults`** Private Sub
  - **Parameters:** `oxygen As OxygenTransportData, results As CalculationResults`
  - **Signature:** `Private Sub DisplayOxygenTransportResults(oxygen As OxygenTransportData, results As CalculationResults)`

- **`DisplayToPrinter`** Private Sub
  - **Parameters:** `patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean`
  - **Signature:** `Private Sub DisplayToPrinter(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)`

- **`DisplayToScreen`** Private Sub
  - **Parameters:** `patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean`
  - **Signature:** `Private Sub DisplayToScreen(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)`

- **`getOutputChoice`** Public Function
  - **Returns:** `String`
  - **Signature:** `Public Function getOutputChoice() As String`

- **`HandleError`** Private Sub
  - **Parameters:** `e As RuntimeException`
  - **Signature:** `Private Sub HandleError(e As RuntimeException)`

- **`HandleOutput`** Private Sub
  - **Parameters:** `patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean`
  - **Signature:** `Private Sub HandleOutput(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)`

- **`InsertOxygenTransportRecord`** Private Sub
  - **Parameters:** `db As SQLiteDatabase, patientID As Integer, oxygen As OxygenTransportData, results As CalculationResults`
  - **Signature:** `Private Sub InsertOxygenTransportRecord(db As SQLiteDatabase, patientID As Integer, oxygen As OxygenTransportData, results As CalculationResults)`

- **`InsertPatientRecord`** Private Function
  - **Parameters:** `db As SQLiteDatabase, patient As PatientData, haemo As HaemodynamicData, outputs() As Double, results As CalculationResults, includeOxygen As Boolean`
  - **Returns:** `Integer`
  - **Signature:** `Private Function InsertPatientRecord(db As SQLiteDatabase, patient As PatientData, haemo As HaemodynamicData, outputs() As Double, results As CalculationResults, includeOxygen As Boolean) As Integer`

- **`RunClinicalStudy`** Private Function
  - **Returns:** `Boolean`
  - **Signature:** `Private Function RunClinicalStudy() As Boolean`

- **`SaveToDisk`** Private Sub
  - **Parameters:** `patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean`
  - **Signature:** `Private Sub SaveToDisk(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, results As CalculationResults, includeOxygen As Boolean)`

- **`ShowDataReview`** Private Sub
  - **Parameters:** `patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, includeOxygen As Boolean`
  - **Signature:** `Private Sub ShowDataReview(patient As PatientData, haemo As HaemodynamicData, outputs() As Double, oxygen As OxygenTransportData, includeOxygen As Boolean)`

- **`ShowIntroduction`** Private Sub
  - **Signature:** `Private Sub ShowIntroduction()`

- **`ShowInvalidChoiceMessage`** Private Sub
  - **Signature:** `Private Sub ShowInvalidChoiceMessage()`

#### Events

- **`Run`**
  - **Signature:** `Event Run(args() as String) As Integer`
  - **Parameters:** `args() as String`
  - **Returns:** `Integer`

---

### PatientData

#### Properties

- **`Date`** Public String

- **`Inotropes`** Public String

- **`MRN`** Public String

- **`Name`** Public String

- **`Time`** Public String

#### Methods

None

#### Events

None

---

### HaemodynamicData

#### Properties

- **`ArterialDiastolic`** Public Double

- **`ArterialMean`** Public Double

- **`ArterialSystolic`** Public Double

- **`CVPMean`** Public Double

- **`HeartRate`** Public Double

- **`Height`** Public Double

- **`PulmonaryMean`** Public Double

- **`PulmonaryWedge`** Public Double

- **`Weight`** Public Double

#### Methods

None

#### Events

None

---

### OxygenTransportData

#### Properties

- **`ArterialPCO2`** Public Double

- **`ArterialPH`** Public Double

- **`ArterialPO2`** Public Double

- **`CoreTemperature`** Public Double

- **`Haemoglobin`** Public Double

- **`InspiredOxygen`** Public Double

- **`VenousPCO2`** Public Double

- **`VenousPH`** Public Double

- **`VenousPO2`** Public Double

#### Methods

None

#### Events

None

---

### CalculationResults

#### Properties

- **`AAGradient`** Public Double

- **`AARatio`** Public Double

- **`AlveolarPO2`** Public Double

- **`ArterialO2Content`** Public Double

- **`ArterialSaturation`** Public Double

- **`AVDifference`** Public Double

- **`CaloricNeeds`** Public Double

- **`CardiacIndex`** Public Double

- **`CardiacOutput`** Public Double

- **`CoronaryPerfusionPressure`** Public Double

- **`EndCapillaryContent`** Public Double

- **`EndCapillarySaturation`** Public Double

- **`ExtractionRatio`** Public Double

- **`LeftCardiacWork`** Public Double

- **`LVSWI`** Public Double

- **`OxygenConsumption`** Public Double

- **`OxygenDelivery`** Public Double

- **`PulmonaryVascularResistance`** Public Double

- **`PulmonaryVascularResistance1`** Public Double

- **`RatePressureProduct`** Public Double

- **`RightCardiacWork`** Public Double

- **`RVSWI`** Public Double

- **`Shunt`** Public Double

- **`StrokeIndex`** Public Double

- **`SurfaceArea`** Public Double

- **`SystemicVascularResistance`** Public Double

- **`VenousO2Content`** Public Double

- **`VenousSaturation`** Public Double

#### Methods

None

#### Events

None

---

## Requirements

- **Xojo:** Latest compatible version

## Installation

1. Clone or download this repository
2. Open the `.xojo_project` file in Xojo
3. Build and run the project

## Usage

[Add specific usage instructions for your application]

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

[Specify your license here]

---
*This README was automatically generated from the Xojo project file on 12/8/2025*
