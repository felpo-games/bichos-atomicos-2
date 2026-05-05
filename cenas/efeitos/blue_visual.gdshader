shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float intensidade : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 cor = texture(screen_texture, SCREEN_UV);

    vec3 cor_quente = vec3(
        cor.r * 1.02,
        cor.g * 1.01,
        cor.b * 0.8
    );

    cor.rgb = mix(cor.rgb, cor_quente, intensidade);

    COLOR = cor;
}