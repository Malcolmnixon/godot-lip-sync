tool
class_name LipSyncTraining
extends Resource


## Dictionary of training data 
## 
## This dictionary maps a phoneme to an array of speech fingerprints.
export(Dictionary) var training


func _init():
	training = {}
