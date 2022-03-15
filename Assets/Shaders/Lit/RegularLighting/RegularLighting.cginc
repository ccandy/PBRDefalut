#ifndef LIGHTING_INCLUDED
#define LIGHTING_INCLUDED

float CalcuateDiffuse(float3 normalDir, float3 lightDir) 
{
	return saturate(dot(normalDir, lightDir));
}

float3 CalcuateDiffuseColor(RegularSurface surface, RegularLight light)
{
	float diffuse = CalcuateDiffuse(surface.normalWS, light.LightDir);
	return light.LightColor * diffuse;

}

float CalcuatePhong(RegularSurface surface, RegularLight light, float3 viewDir)
{
	float3 refLightDir = reflect(-light.LightDir, surface.normalWS);

	float spec = saturate(dot(refLightDir, viewDir));

	return spec;
}

float3 CalcualteSpecColor(RegularSurface surface, RegularLight light, float3 cameraPos, float3 posWS)
{
	float3 viewDir = normalize(cameraPos - posWS);
	float spec = CalcuatePhong(surface, light, viewDir);
	float3 specColor = pow(spec, surface.Shinness) * light.LightColor;
	specColor = specColor * surface.specStrength;
	return specColor;
}

/*
#include "PBRLight.cginc"
#include "PBRSurface.cginc"

float CalcuateDiffuse(float3 normalDir, float3 lightDir) 
{
	return saturate(dot(normalDir, lightDir));
}
float3 CalcuateDiffuseColor(PBRLight light, PBRSurface surface) 
{
	float diffuse = CalcuateDiffuse(surface.normalWS, light.LightDir);

	return light.LightColor * diffuse;
	
}

float CalcuatePhong(PBRSurface surface, PBRLight light, float3 viewDir)
{
	float3 refLightDir = reflect(-light.LightDir, surface.normalWS);

	float spec = saturate(dot(refLightDir, viewDir));

	return spec;
}

float3 CalcualteSpecColor(PBRLight light, PBRSurface surface, float3 cameraPos, float3 posWS) 
{
	float3 viewDir = normalize(cameraPos - posWS);
	float spec = CalcuatePhong(surface, light, viewDir);
	float3 specColor = pow(spec, surface.Shinness) * light.LightColor;
	specColor = specColor * surface.specStrength;
	return specColor;
}
*/


#endif