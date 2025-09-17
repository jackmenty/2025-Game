shader_type spatial;

uniform vec4 out_color: source_color = vec4(0.0, 0.2, 1.0, 1.0);
uniform float amount: hint_range(0.2, 5.0, 0.1) = 0.8;
uniform float speed: hint_range(0.1, 5.0, 0.1) = 1.0;
uniform float beer_factor = 0.2;
uniform float metallic = 0.6;
uniform float specular = 0.5;
uniform float roughness = 0.2;

// You need inverse projection matrix
// Godot provides INV_PROJECTION_MATRIX automatically in spatial shaders
uniform float near_plane = 0.1;
uniform float far_plane = 100.0;

float generateOffset(float x, float z, float val1, float val2, float time) {
    float radiansX = ((mod(x + z * x * val1, amount) / amount) + (time * speed) * mod(x * 0.8 + z, 1.5)) * 2.0 * 3.14159265;
    float radiansZ = ((mod(val2 * (z * x + x * z), amount) / amount) + (time * speed) * 2.0 * mod(x, 2.0)) * 2.0 * 3.14159265;
    return amount * 0.5 * (sin(radiansZ) * cos(radiansX));
}

vec3 applyDistortion(vec3 vertex, float time) {
    float xd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time);
    float yd = generateOffset(vertex.x, vertex.z, 0.1, 0.3, time);
    float zd = generateOffset(vertex.x, vertex.z, 0.15, 0.2, time);
    return vertex + vec3(xd, yd, zd);
}

void vertex() {
    VERTEX = applyDistortion(VERTEX, TIME * 0.1);
}

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture; 

void fragment() {
    NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
    METALLIC = metallic;
    SPECULAR = specular;
    ROUGHNESS = roughness;
    ALBEDO = out_color.rgb;

    float alpha_calc = out_color.a;
    if (beer_factor > 0.0) {
        float depth_raw = texture(DEPTH_TEXTURE, SCREEN_UV).r;
        vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth_raw);
        vec4 view_pos = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
        view_pos.xyz /= view_pos.w;
        float scene_linear_depth = -view_pos.z;
        float frag_linear_depth = -VERTEX.z;

        float thickness = max(scene_linear_depth - frag_linear_depth, 0.001);

        if (frag_linear_depth < 0.2) { // very close to camera
            alpha_calc = out_color.a;
        } else {
            alpha_calc = clamp(1.0 - exp(-beer_factor * thickness), 0.0, 1.0);
        }
    }
    ALPHA = alpha_calc;
}