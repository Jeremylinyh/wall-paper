extends Node2D
# GDScript equivalent of the GLSL fragment shader logic.
# This would typically be part of a script attached to a Node2D or similar.

# NOTE: Since this is a direct translation of shader logic,
# it will be significantly slower than running the original GLSL as a Godot ShaderMaterial.

# You would need to define these variables (uniforms) in your script or pass them as arguments:
# var u_resolution: Vector2 = Vector2(1024.0, 600.0) # Example resolution
# var u_mouse: Vector2 = Vector2(0.0, 0.0) # Example mouse position
# var u_time: float = 0.0 # Example time

# Helper function to mimic the GLSL 'dot' product for Vector2
func dot(a: Vector2, b: Vector2) -> float:
	return a.dot(b)

# Helper function to mimic the GLSL 'fract' (returns the fractional part of a float)
func fract(x: float) -> float:
	return x - floor(x)

# Helper function to mimic the GLSL 'mix' (linear interpolation)
func mix(a, b, t):
	if typeof(a) == TYPE_VECTOR2:
		return a.linear_interpolate(b, t)
	else:
		return a + (b - a) * t

# --- GLSL Function Translations ---

# vec2 random2(vec2 st)
func random2(st: Vector2) -> Vector2:
	var v_st = Vector2(
		dot(st, Vector2(127.1, 311.7)),
		dot(st, Vector2(269.5, 183.3))
	)
	
	# GLSL 'sin(st)*43758.5453123' is implemented using sin() on the Vector2 components
	var sin_st = Vector2(sin(v_st.x), sin(v_st.y)) * 43758.5453123
	
	# fract() on the components
	var frac_sin_st = Vector2(fract(sin_st.x), fract(sin_st.y))
	
	# return -1.0 + 2.0 * fract(...)
	return -Vector2.ONE + 2.0 * frac_sin_st

# float noise(vec2 st)
func noise(st: Vector2) -> float:
	var i: Vector2 = st.floor()
	var f: Vector2 = st - i # Same as fract(st)

	# vec2 u = f*f*(3.0-2.0*f);
	var u: Vector2 = f * f * (Vector2.ONE * 3.0 - Vector2.ONE * 2.0 * f)

	# The four dot products:
	var d00: float = dot(random2(i + Vector2(0.0, 0.0)), f - Vector2(0.0, 0.0))
	var d10: float = dot(random2(i + Vector2(1.0, 0.0)), f - Vector2(1.0, 0.0))
	var d01: float = dot(random2(i + Vector2(0.0, 1.0)), f - Vector2(0.0, 1.0))
	var d11: float = dot(random2(i + Vector2(1.0, 1.0)), f - Vector2(1.0, 1.0))
	
	# Linear interpolations (mix):
	# mix(dot00, dot10, u.x)
	var x_mix_bottom: float = mix(d00, d10, u.x)
	# mix(dot01, dot11, u.x)
	var x_mix_top: float = mix(d01, d11, u.x)
	
	# mix(x_mix_bottom, x_mix_top, u.y)
	return mix(x_mix_bottom, x_mix_top, u.y)
