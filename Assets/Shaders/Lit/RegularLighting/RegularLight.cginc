#ifndef LIGHT_INCLUDED
#define LIGHT_INCLUDED

struct RegularLight 
{
	float3 LightPos;
	float3 LightColor;
	float3 LightDir;

};

RegularLight CreateLight(float3 lightColor, float3 lightPos)
{
	RegularLight light;

	light.LightColor = lightColor;
	light.LightPos = lightPos;
	light.LightDir = normalize(lightPos);

	return light;
}


#endif