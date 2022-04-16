
varying vec3 vNormal;
varying float vPerlinStrength;

void main(){
   float temp=vPerlinStrength+.1;
   temp*=2.;
   gl_FragColor=vec4(temp,temp,temp,1.);
}