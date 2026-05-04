extends TextureButton

@export var cena:String
@export var asset_normal: CompressedTexture2D
@export var asset_precionado: CompressedTexture2D

# Configurações da animação
@export var scale_factor: float = 1.1 # O botão crescerá 10%
@export var animation_duration: float = 0.1 # Duração da animação (rápida)

var default_scale: Vector2
var namira

func _ready() -> void:
	texture_normal = asset_normal
	texture_pressed = asset_precionado
	
# Garante que o pivô seja o centro ANTES de salvar a escala
	pivot_offset = size / 2
	default_scale = scale # Aqui ele salva: "A escala normal é X"
	
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)

func _on_focus_entered() -> void:
	namira = true
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", default_scale * scale_factor, animation_duration)

func _on_focus_exited() -> void:
	namira = false
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", default_scale, animation_duration)

func _on_mouse_entered() -> void:
	grab_focus() 


func _on_mouse_exited() -> void:
	release_focus() # Isso remove o foco quando o mouse sai (opcional, depende do design)
	pass # Replace with function body.




func _on_pressed() -> void:
	if Input.is_action_pressed("ação") and namira:
		_on_pressed()
	if cena != "": 
		get_tree().change_scene_to_file(cena)
	else:
		get_tree().quit()
pass # Replace with function body.
