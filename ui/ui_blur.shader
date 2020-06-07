shader_type canvas_item;
render_mode unshaded;

uniform float blurSize : hint_range(0,8);

void fragment()
{
    COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blurSize);
}