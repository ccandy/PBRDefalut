#ifndef REGULARSURFACE_INCLUDED
#define REGULARSURFACE_INCLUDED

struct RegularSurface {
	
	float3 normalWS;
	float4 surfaceColor;
	float specStrength;
	float Shinness;

};


RegularSurface CreateSurface(float3 normal, float4 color, float spec, float shinness)
{
	RegularSurface surface;

	surface.normalWS = normal;
	surface.surfaceColor = color;
	surface.Shinness = shinness;
	surface.specStrength = spec;

	return surface;

}



#endif