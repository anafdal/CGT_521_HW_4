#version 400
uniform sampler2DShadow shadowmap;////////

uniform int pass;
uniform bool change;
uniform bool enable;
uniform float w_num;

out vec4 fragcolor;           
in vec4 shadow_coord;
      
void main(void)
{   

	if(pass == 1) // render depth to shadowmap from light point of view
	{
		fragcolor = vec4(1.0-gl_FragCoord.z*gl_FragCoord.w); //compute a color for us to visualize the shadow map in rendermode = 2
	}
	else if(pass == 2) 
	{
		
		//float z = texture(shadowmap, shadow_coord.xy/shadow_coord.w).r; // light-space depth in the shadowmap
		//float r = shadow_coord.z / shadow_coord.w; // light-space depth of this fragment
		//float lit = float(r <= z); // if ref is closer than z then the fragment is lit
		//float lit = textureProj(shadowmap,shadow_coord);
 if(enable==false){
  
  
          if(change==false){//4x4 PCF
		    vec4 lit4;
            //float w = 1.5/textureSize(shadowmap, 0).x;

			float w = w_num/textureSize(shadowmap, 0).x;
            lit4[0] = textureProj(shadowmap, shadow_coord+vec4(-w, -w, 0.0, 0.0));
            lit4[1] = textureProj(shadowmap, shadow_coord+vec4(+w, -w, 0.0, 0.0));
            lit4[2] = textureProj(shadowmap, shadow_coord+vec4(-w, +w, 0.0, 0.0));
            lit4[3] = textureProj(shadowmap, shadow_coord+vec4(+w, +w, 0.0, 0.0));
            float lit = dot(lit4, vec4(0.25, 0.25, 0.25, 0.25));
			fragcolor  = vec4(lit);

			
		}

         else if(change==true){//2x2 PCF

		   float lit = textureProj(shadowmap,shadow_coord);
		   fragcolor  = vec4(lit);
		   }

		}
	  else if(enable==true){
		     
			 vec3 coord = shadow_coord.xyz / shadow_coord.w;
             vec4 lit4 = textureGather(shadowmap, coord.xy, coord.z);
             float lit = dot(lit4, vec4(0.25, 0.25, 0.25, 0.25));
			 fragcolor  = vec4(lit);
        }
   }
	
}

