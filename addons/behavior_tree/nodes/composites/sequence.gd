@icon("../../icons/sequencer.svg")
extends Composite

class_name SequenceComposite

func tick(actor, blackboard):
	for c in get_children():
		var response = c.tick(actor, blackboard)

		if response != SUCCESS:
			return response

	return SUCCESS
