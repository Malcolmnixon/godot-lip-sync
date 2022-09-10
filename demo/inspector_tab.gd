extends Tabs


## Description of phonemes
const DESCRIPTIONS := {
## Description of the [tS] phoneme.
Phonemes.PHONEME.PHONEME_TS: 
"""Voiceless postalveolar affricate [tS]

This phoneme is the CH sound in CHeck, CHoose, beaCH, and marCH.""",

## Description of the [dZ] phoneme.
Phonemes.PHONEME.PHONEME_DZ:
"""Voiced postalveolar affricate [dZ]

This phoneme is the J sound in Job, aGe, maJor, Joy, and Jump.""",

## Description of the [S] phoneme.
Phonemes.PHONEME.PHONEME_SH:
"""Voiceless postalveolar fricative [S]

This phoneme is the SH sound in SHe, puSH, and SHeep.""",

## Description of the [t] phoneme.
Phonemes.PHONEME.PHONEME_T:
"""Voiceless alveolar plosive [t]

This phoneme is the T sound in Take, haT, and sTew.

Note: Plosive (stop) phonemes are difficult to record.""",

## Description of the [d] phoneme.
Phonemes.PHONEME.PHONEME_D:
"""Voiced alveolar plosive [d]

This phoneme is the D sound in Day, haD, and Dig.

Note: Plosive (stop) phonemes are difficult to record.""",

## Description of the [e] phoneme.
Phonemes.PHONEME.PHONEME_E:
"""Close-mid front unrounded vowel [e]

This phoneme is the E sound in Ever and bEd.""",

## Description of the [f] phoneme.
Phonemes.PHONEME.PHONEME_F:
"""Voiceless labiodental fricative [f]

This phoneme is the F sound in Fan and Five.""",

## Description of the [v] phoneme.
Phonemes.PHONEME.PHONEME_V:
"""Voiced labiodental fricative [v]

This phoneme is the V sound in Van and Vest.""",

## Description of the [I] phoneme.
Phonemes.PHONEME.PHONEME_I:
"""Near-close front unrounded vowel [I]

This phoneme is the I sound in fIx, offIce, and kIt.""",

## Description of the [O] phoneme.
Phonemes.PHONEME.PHONEME_O:
"""Open-mid back rounded vowel [O]

This phoneme is the O sound in Otter, stOp, and nOt.""",

## Description of the [p] phoneme.
Phonemes.PHONEME.PHONEME_P:
"""Voiceless bilabial plosive [p]

This phoneme is the P sound in Pat, Put, and Pack.

Note: Plosive (stop) phonemes are difficult to record.""",

## Description of the [b] phoneme.
Phonemes.PHONEME.PHONEME_B:
"""Voiced bilabial plosive [b]

This phoneme is the B sound in Bat, tuBe, and Bed.

Note: Plosive (stop) phonemes are difficult to record.""",

## Description of the [m] phoneme.
Phonemes.PHONEME.PHONEME_M:
"""Bilabial nasal [m]

This phoneme is the M sound in Mat, froM, and Mouse.""",

## Description of the [r] phoneme.
Phonemes.PHONEME.PHONEME_R:
"""Alveolar trill [r]

This phoneme is the R sound in Red, fRom, and Ram.""",

## Description of the [s] phoneme.
Phonemes.PHONEME.PHONEME_S:
"""Voiceless alveolar fricative [s]

This phoneme is the S sound in Sir, See, and Seem.""",

## Description of the [z] phoneme.
Phonemes.PHONEME.PHONEME_Z:
"""Voiced alveolar fricative [z]

This phoneme is the Z sound in aS, hiS, and Zoo.""",

## Description of the [T] phoneme.
Phonemes.PHONEME.PHONEME_TH:
"""Voiceless dental fricative [T]

This phoneme is the TH sound in THink, THat, and THin.""",

## Description of the [u] phoneme.
Phonemes.PHONEME.PHONEME_OU:
"""Close back rounded vowel [u]

This phoneme is the OU sound in tOO, feW, and bOOm.""",

## Description of the [A] phoneme.
Phonemes.PHONEME.PHONEME_A:
"""Open back unrounded vowel [A]

This phoneme is the A sound in cAr, Art, and fAther.""",

## Description of the [k] phoneme.
Phonemes.PHONEME.PHONEME_K:
"""Voiceless velar plosive [k]

This phoneme is the K sound in Call, weeK, and sCat.

Note: Plosive (stop) phonemes are difficult to record.""",

## Description of the [g] phoneme.
Phonemes.PHONEME.PHONEME_G:
"""Voiced velar plosive [g]

This phoneme is the G sound in Gas, aGo, and Game.

Note: Plosive (stop) phonemes are difficult to record.""",

## Description of the [n] phoneme.
Phonemes.PHONEME.PHONEME_N:
"""Alveolar nasal [n]

This phoneme is the N sound in Not, aNd, and Nap.""",

## Description of the [l] phoneme.
Phonemes.PHONEME.PHONEME_L:
"""Alveolar lateral approximant [l]

This phoneme is the L sound in Lot, chiLd, and Lay.""",
}


## Calibration tree path
export (NodePath) var calibration_tree


## Calibration tree node
onready var _calibration_tree: CalibrationTree = get_node(calibration_tree)


# Called when the node enters the scene tree for the first time.
func _ready():
	_calibration_tree.connect("item_selected", self, "_on_CalibrationTree_item_selected")


func _on_CalibrationTree_item_selected():
	# Get the phoneme and possibly fingerprint
	var item: TreeItem = _calibration_tree.get_selected()
	var phoneme: int = item.get_metadata(0)
	var fingerprint: LipSyncFingerprint = item.get_metadata(1)

	# Ensure the description is hidden
	$Description.visible = false

	# Populate selected item
	if fingerprint:
		# Hide phoneme description
		$PhonemeDescription.visible = false

		# Get scale to normalize volume
		var max_value: float = fingerprint.values.max()
		var max_scale = 0.0 if max_value <= 0.0 else 1.0 / max_value

		# Populate bars
		for i in LipSyncFingerprint.BANDS_COUNT:
			var bar: TextureProgress = $FingerprintBars.get_child(i)
			bar.value = fingerprint.values[i] * max_scale

		# Show fingerprint bars
		$FingerprintBars.visible = true
	else:
		# Hide fingerprint bars
		$FingerprintBars.visible = false

		# Set the text
		$PhonemeDescription.text = DESCRIPTIONS[phoneme]

		# Show phoneme description
		$PhonemeDescription.visible = true
