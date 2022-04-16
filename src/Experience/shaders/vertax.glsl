#define M_PI 3.1415926535897932384626433832795
varying vec3 vNormal;
varying vec3 vColor;
varying float vPerlinStrength;

uniform float uTime;

uniform float uDistortionFrequency;
uniform float uDistortionStrength;
uniform float uDisplacemenFrequency;
uniform float uDisplacemenStrength;
uniform float uTimeFrequency;


uniform vec2 uSubdivision;

#pragma glslify:perlin4d=require('../shaders/partials/perlin4d.glsl');
#pragma glslify:perlin3d=require('../shaders/partials/perlin3d.glsl');

vec3 getDisplacedPosition(vec3 _position)
{
    vec3 distoredPosition=_position;
    distoredPosition+=perlin4d(vec4(distoredPosition*uDistortionFrequency,uTime*uTimeFrequency))*uDistortionStrength;
    
    float perlinStrength=perlin4d(vec4(distoredPosition*uDisplacemenFrequency,uTime*uTimeFrequency));
    
    vec3 displacedPosition=_position;
    displacedPosition+=normalize(_position)*perlinStrength*uDisplacemenStrength;
    
    return displacedPosition;
}

void main(){
    //position
    vec3 displacedPosition=getDisplacedPosition(position);
    vec4 viewPosition=viewMatrix*vec4(displacedPosition,1.);
    gl_Position=projectionMatrix*viewPosition;
    // vec3 biTangent=cross(normal,tangent.xyz);

      // Bi tangents
    float distanceA = (M_PI * 2.0) / uSubdivision.x;
    float distanceB = M_PI / uSubdivision.x;

    vec3 biTangent = cross(normal, tangent.xyz);

    vec3 positionA = position + tangent.xyz * distanceA;
    vec3 displacedPositionA = getDisplacedPosition(positionA);

    vec3 positionB = position + biTangent.xyz * distanceB;
    vec3 displacedPositionB = getDisplacedPosition(positionB);

    vec3 computedNormal = cross(displacedPositionA - displacedPosition.xyz, displacedPositionB - displacedPosition.xyz);
    computedNormal = normalize(computedNormal);

    // Fresnel
    // vec3 viewDirection = normalize(displacedPosition.xyz - cameraPosition);
    // float fresnel = uFresnelOffset + (1.0 + dot(viewDirection, computedNormal)) * uFresnelMultiplier;
    // fresnel = pow(max(0.0, fresnel), uFresnelPower);

    //color
    vec3 uLightAColor=vec3(1.,.2,.5);
    vec3 uLightAPosition=vec3(1.,1.,0.);
    float lightA=max(0.,-dot(computedNormal.xyz,normalize(-uLightAPosition)));
    
    vec3 uLightBColor=vec3(.5,.2,1.0);
    vec3 uLightBPosition=vec3(-1.,-.5,0.);
    float lightB=max(0.,-dot(computedNormal.xyz,normalize(-uLightBPosition)));
    
    vec3 color=vec3(0.);
    color=mix(color,uLightAColor,lightA);
    color=mix(color,uLightBColor,lightB);
    
    vNormal=normal;
    vPerlinStrength=length(displacedPosition-position);
    
    vColor=color;
}