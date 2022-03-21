#ifndef SURFACE_INCLUDED
#define SURFACE_INCLUDED

struct PBRSurface {
	
	float3 NormalWS;
	float3 BaseF0;
	float3 kd;
	float4 SurfaceColor;
	float SpecStrength;
	float Shinness;
	float Metallic;
	float Roughness;
};


PBRSurface CreateSurface(float3 normal, float4 color, float metallic, float roughness, float3 basef0)
{
	PBRSurface surface;

	surface.NormalWS = normal;
	surface.SurfaceColor = color;
	surface.Roughness = roughness;
	surface.Metallic = metallic;
	basef0 = lerp(basef0, color, metallic);
	surface.BaseF0 = basef0;

	return surface;

}



#endif