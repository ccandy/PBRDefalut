#ifndef LIGHT_INCLUDED
#define LIGHT_INCLUDED

struct PBRLight 
{
	float3 LightPos;
	float3 LightColor;
	float3 LightDir;

};

PBRLight CreateLight(float4 lightColor, float4 lightPos)
{
	PBRLight light;

	light.LightColor = lightColor;
	light.LightPos = lightPos;
	light.LightDir = normalize(lightPos);

	return light;
}


#endif