shader_type canvas_item;

uniform float brightness : hint_range(-1.0, 2.0) = 1.2;
uniform float alpha : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(TEXTURE, UV) * brightness;
    COLOR.a *= alpha;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
