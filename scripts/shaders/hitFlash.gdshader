shader_type canvas_item;

uniform bool flash = false;

void fragment() {
	if (flash){
		COLOR = vec4(0.961, 0.961, 0.961, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
