#ifndef LIGHT_INCLUDED
#define LIGHT_INCLUDED

struct PBRLight 
{
	float3 LightPos;
	float3 LightColor;
	float3 LightDir;

};

PBRLight CreateLight(float3 lightColor, float3 lightPos)
{
	PBRLight light;

	light.LightColor = lightColor;
	light.LightPos = lightPos;
	light.LightDir = normalize(lightPos);

	return light;
}


#endif