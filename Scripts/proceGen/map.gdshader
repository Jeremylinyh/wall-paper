shader_type canvas_item;
render_mode world_vertex_coords;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y);
}

// Passes the world coordinates to the fragment shader
varying vec2 v_world_pos;

void vertex() {
    // Transform local vertex position to 2D world space
    // We use (0.0, 1.0) for Z and W for 2D matrix math
    v_world_pos = VERTEX.xy; //(MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;

    // We don't touch the built-in VERTEX, so the panel renders normally.
}

uniform sampler2D grassTex : repeat_enable;
uniform sampler2D sandTex : repeat_enable;

void fragment() {
	vec2 pixelPos = v_world_pos/600.0;
	float height = abs(noise(pixelPos));
	height *= 6.0;
	height = clamp(height,0,1);

	//COLOR = texture(grassTex,pixelPos);
	COLOR = mix(texture(grassTex,pixelPos*3.0),texture(sandTex,pixelPos/3.0),1.0-height);
	//COLOR = vec4(vec3(height),1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
