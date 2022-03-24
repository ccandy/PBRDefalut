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


PBRSurface CreateSurface(float3 normal, float4 color, float4 texColor, float metallic, float roughness)
{
	PBRSurface surface;

	surface.NormalWS = normal;
	surface.SurfaceColor = texColor* color;
	surface.Roughness = roughness;
	surface.Metallic = metallic;

	float3 F0 = lerp(unity_ColorSpaceDielectricSpec.rgb, surface.SurfaceColor, metallic);
	surface.BaseF0 = F0;

	return surface;

}



#endif