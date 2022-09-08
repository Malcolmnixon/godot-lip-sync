class_name LipSyncFingerprint


## Fingerprint frequency bands.
##
## Each entry is from-Hz, to-Hz, middle-Hz
const BANDS_RANGE := [
	[140.0, 160.0, 150.0],
	[160.0, 196.0, 178.0],
	[196.0, 242.0, 219.0],
	[242.0, 300.0, 271.0],
	[300.0, 362.0, 331.0],
	[362.0, 432.0, 397.0],
	[432.0, 510.0, 471.0],
	[510.0, 592.0, 551.0],
	[592.0, 680.0, 636.0],
	[680.0, 772.0, 726.0],
	[772.0, 868.0, 820.0],
	[868.0, 970.0, 919.0],
	[970.0, 1076.0, 1023.0],
	[1076.0, 1186.0, 1131.0],
	[1186.0, 1300.0, 1243.0],
	[1300.0, 1420.0, 1360.0],
	[1420.0, 1540.0, 1480.0],
	[1540.0, 1666.0, 1603.0],
	[1666.0, 1796.0, 1731.0],
	[1796.0, 1928.0, 1862.0],	
]

## Count of frequency bands
const BANDS_COUNT := 20

## Average energy level for silence
const SILENCE := 0.1

## Fingerprint description
var description: String = ""

## Fingerprint values
var values: Array = [
	0.0, 0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0, 0.0]


## Populate this fingerprint from a spectrum analyzer instance
func populate(spectrum: AudioEffectSpectrumAnalyzerInstance):
	# Populate values with energy
	var energy_sum := 0.0
	for i in BANDS_COUNT:
		var from_hz: float = BANDS_RANGE[i][0]
		var to_hz: float = BANDS_RANGE[i][1]
		var center_hz: float = BANDS_RANGE[i][2]
		var magnitude := spectrum.get_magnitude_for_frequency_range(from_hz, to_hz, AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_AVERAGE)
		var e := magnitude.length() * center_hz
		values[i] = e
		energy_sum += e

	# Calculate fingerprint
	var energy_avg := energy_sum / BANDS_COUNT
	var energy_scale := 0.0 if energy_avg <= SILENCE else 1.0 / energy_avg
	for i in BANDS_COUNT:
		values[i] *= energy_scale


## Calculate deviation between two fingerprints
static func deviation(a: LipSyncFingerprint, b: LipSyncFingerprint) -> float:
	# Calculate sum of squares of error
	var sum := 0.0
	for i in BANDS_COUNT:
		var delta: float = b.values[i] - a.values[i]
		sum += delta * delta
	
	# Return sum as deviation
	return sum
