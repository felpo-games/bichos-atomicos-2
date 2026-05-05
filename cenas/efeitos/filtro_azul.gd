extends Control

shader_type canvas_item;

uniform float intensidade : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 cor = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	// reduz o azul
	cor.b *= (1.0 - intensidade);
	
	COLOR = cor;
}
