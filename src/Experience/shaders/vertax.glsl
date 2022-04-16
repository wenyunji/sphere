varying vec3 vNormal;
varying float vPerlinStrength;
uniform float uTime;

uniform float uDistortionFrequency;
uniform float uDistortionStrength;
uniform float uDisplacemenFrequency;
uniform float uDisplacemenStrength;
uniform float uTimeFrequency;

#pragma glslify:perlin4d=require('../shaders/partials/perlin4d.glsl');
#pragma glslify:perlin3d=require('../shaders/partials/perlin3d.glsl');

void main(){
    
    vec3 newPosition=position;
    vec3 displacemenPosition=position*uDisplacemenFrequency;
    displacemenPosition+=perlin4d(vec4(displacemenPosition*uDistortionFrequency,uTime*uTimeFrequency))*uDistortionStrength;
    
    float perlinStrength=perlin4d(vec4(displacemenPosition,uTime*uTimeFrequency))*uDisplacemenStrength;
    newPosition+=normal*perlinStrength;
    
    vec4 modelPosition=modelMatrix*vec4(newPosition,1.);
    vec4 viewPosition=viewMatrix*modelPosition;
    gl_Position=projectionMatrix*viewPosition;
    
    vNormal=normal;
    vPerlinStrength=perlinStrength;
}