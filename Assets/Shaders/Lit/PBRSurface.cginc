#ifndef SURFACE_INCLUDED
#define SURFACE_INCLUDED

struct PBRSurface {
	
	float3 normalWS;
	float4 surfaceColor;
	float specStrength;
	float Shinness;

};


PBRSurface CreateSurface(float3 normal, float4 color, float spec, float shinness) 
{
	PBRSurface surface;

	surface.normalWS = normal;
	surface.surfaceColor = color;
	surface.Shinness = shinness;
	surface.specStrength = spec;

	return surface;

}



#endif