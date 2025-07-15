extends StaticBody2D

var counter = 2

func break_apart():
	if counter == 0:
		queue_free()
	else:
		counter -= 1
		
