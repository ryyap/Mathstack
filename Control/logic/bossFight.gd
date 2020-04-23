extends Control

# Declare member variables here. Examples:
onready var boss1 = get_tree().get_root().get_node("World").find_node("BossSprite1") #Yellow Cyborg
onready var boss2 = get_tree().get_root().get_node("World").find_node("BossSprite2") #Blue Rabbit
onready var boss3 = get_tree().get_root().get_node("World").find_node("BossSprite3") #Raging Zombie
onready var boss4 = get_tree().get_root().get_node("World").find_node("BossSprite4") #Dark Knight
onready var bg = get_tree().get_root().get_node("World").find_node("BossBg") #Background

#Timer
onready var timer = get_tree().get_root().get_node("World").find_node("Timer") #Background

#Buttons
onready var option1 = $BossMenu/MarginContainer/row/columnLeft/Option1/Label
onready var option2 = $BossMenu/MarginContainer/row/columnRight/Option2/Label
onready var option3 = $BossMenu/MarginContainer/row/columnLeft/Option3/Label
onready var option4 = $BossMenu/MarginContainer/row/columnRight/Option4/Label

var question #Question Array
var qnNo
var ans
onready var questionTitle = $BossMenu/QuestionLabel

onready var character = get_tree().get_root().get_node("World").find_node("SelectedCharacter") #Player Character
onready var blkTower = get_tree().get_root().get_node("World").find_node("BlockTower") #Blk Tower
onready var qnBoard = get_tree().get_root().get_node("World").find_node("PlayBoard")
onready var music = get_tree().get_root().get_node("World").find_node("MusicBox")

onready var bossHP = $BossMenu/HProw/BossHealth

var bossMode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func restoreBoss():
	qnNo = 1
	bossHP.value = 100
	print(str(bossHP.value))

func startBossMode():
	restoreBoss()
	bg.show()
	qnBoard.hide()
	show()
	timer.pauseTime()
	randomizeQuestion()
	bossMode = true
	music.bossTheme()
	character.losePower()

func endBossMode():
	bg.hide()
	qnBoard.show()
	hide()
	bossDies()
	bossMode = false
	timer.countTime()
	music.playTrack()
	character.addLife()
	character.recoverPower()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (bossMode == true) and bossHP.value<=0:
		endBossMode()

func bossDies():
	#Set Array of Boss
	var bossArr = [boss1,boss2,boss3,boss4]
	var bossNo
	if (blkTower.getNoOfBoxes()>90):
		bossNo = 4 #Dark Night dies
	elif (blkTower.getNoOfBoxes()>70):
		bossNo = 3	
	elif (blkTower.getNoOfBoxes()>50):
		bossNo = 2	
	else:
		bossNo = 1
	bossArr[bossNo-1].hide()

func randomizeQuestion():
	#Randomize operands
	var operand1 = int(floor(rand_range(10,100)))
	var operand2 = int(floor(rand_range(10,100)))
	#Randomize operations
	var operation = int(floor(rand_range(1,5)))
	print(operation)
	#Set answer
	var finalAns = 0
	var operationStr = ""
		#1 = Addition, 2 = Subtraction, 3 = Multiplication, 4 = Mod
	match operation:
		1:
			operationStr = "+"
			finalAns = operand1+operand2
		2: 
			operationStr = "-"
			finalAns = operand1-operand2
		3:
			operationStr = "*"
			finalAns = operand1*operand2
		4:
			operationStr = "%"
			finalAns = operand1%operand2
	#Set options
	
	option1.set_text(str(randCloseAns(finalAns))) 
	option2.set_text(str(randCloseAns(finalAns)))
	option3.set_text(str(randCloseAns(finalAns)))
	option4.set_text(str(randCloseAns(finalAns)))
	
	match int(floor(rand_range(1,5))):
		1:
			option1.set_text(str(finalAns)) 
		2: 
			option2.set_text(str(finalAns)) 
		3:
			option3.set_text(str(finalAns)) 
		4:
			option4.set_text(str(finalAns)) 
			
	setQuestion(operand1, operand2, operation)
	#set Question title
	questionTitle.set_text("Q"+str(qnNo)+") "+str(question[0])+str(operationStr)+str(question[1])+"?")
	qnNo+=1
	
#Sets question and store it
func setQuestion(operand1, operand2, operation):
	#0 = operand1, 1 = operand2, 2 = operation, 3 = correct Answer
	var correctAnswer = 0
	match operation:
		1: #default/1
			correctAnswer = int(operand1+operand2)
		2:
			correctAnswer = int(operand1-operand2)
		3:
			correctAnswer = int(operand1*operand2)
		4:
			correctAnswer = int(operand1%operand2)
	
	#Save question set
	question = [operand1,operand2,operation,correctAnswer] 
	print(question)

#Make the ans close to actual
func randCloseAns(ans):
	var newAns = ans + int(floor(rand_range(-15,15)))
	return newAns 

#Check Ans
func checkAnswer(option):
	if (str(question[3])==option.get_text()):#Check if correct answer was click
		correctAnswer()
		
	else:
		wrongAnswer()

func damageBoss():
	bossHP.value -= 30

func correctAnswer():
	print("Correct!")
	#Play Sound
	var sound = get_tree().get_root().get_node("World").find_node("CorrectSound")
	sound.play()
	#Make Character speak!
	character.characterSpeak("HIYA!! ")
	damageBoss()
	randomizeQuestion()

func wrongAnswer():
	print("Wrong!")
	#Play Sound
	var sound = get_tree().get_root().get_node("World").find_node("WrongSound")
	sound.play()
	#Make Character speak!
	character.characterSpeak("SHUCKS! That was wrong. ")
	randomizeQuestion()

func _on_Option1_pressed():
	checkAnswer(option1)

func _on_Option3_pressed():
	checkAnswer(option3)

func _on_Option2_pressed():
	checkAnswer(option2)

func _on_Option4_pressed():
	checkAnswer(option4)