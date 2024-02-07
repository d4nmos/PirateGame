shader_type spatial;

uniform sampler2D terrain_grass;
uniform sampler2D terrain_rock;
uniform sampler2D terrain_beach;
uniform float min_grass_height = 0.0;
uniform float max_rock_height = 3.0;
uniform float max_beach_height = 5.0;
varying float vertex_y;
uniform vec2 uvscale = vec2(5);
void fragment() {
	float vert_weight = vertex_y;
	
	vec3 grass = texture(terrain_grass,UV*uvscale).rgb;
	vec3 rock = texture(terrain_rock,UV*uvscale).rgb;
	vec3 beach = texture(terrain_beach,UV*uvscale).rgb;
	
	//float weight = smoothstep(min_grass_height,max_beach_height,vert_weight);
	//vec3 final_color = mix(grass,beach,weight);
	
	float weight_grass = smoothstep(min_grass_height, max_rock_height, vert_weight);
    float weight_beach = smoothstep(max_rock_height, max_beach_height, vert_weight);
    
    vec3 final_color;
    
    if (vert_weight < max_rock_height) {
        final_color = mix(grass, rock, weight_grass);
    } else {
        final_color = mix(rock, beach, weight_beach);
    }
    
	ALBEDO = final_color.rgb;
}

void vertex(){
	vertex_y = VERTEX.y;
}

