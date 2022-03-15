#ifndef SURFACE_INCLUDED
#define SURFACE_INCLUDED

struct PBRSurface {
	
	float3 NormalWS;
	float4 SurfaceColor;
	float SpecStrength;
	float Shinness;
	float Metallc;
	float Roughness;


};


PBRSurface CreateSurface(float3 normal, float4 color, float spec, float shinness, float metallc, float roughness)
{
	PBRSurface surface;

	surface.NormalWS = normal;
	surface.SurfaceColor = color;
	surface.Shinness = shinness;
	surface.SpecStrength = spec;
	surface.Roughness = roughness;
	surface.Metallc = metallc;


	return surface;

}



#endif