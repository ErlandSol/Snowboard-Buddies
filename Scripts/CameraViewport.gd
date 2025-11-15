extends SubViewportContainer
class_name CameraViewport
@export var cameraController : CameraController
static var test = "test"


@export var speed_effect_color_rect:ColorRect

#unc _ready() -> void:
	#ApplySpeedEffect.effect_change.connect(apply_effect)


	
#func apply_effect(value:float) -> void:
	#speed_effect_color_rect.material.set_shader_parameter('effect_power', value)
