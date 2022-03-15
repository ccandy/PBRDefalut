#ifndef LIGHT_INCLUDED
#define LIGHT_INCLUDED

struct RegularLight 
{
	float3 LightPos;
	float3 LightColor;
	float3 LightDir;

	float LightAtten;

};

RegularLight CreateLight(float3 lightColor, float4 lightPos)
{
	RegularLight light;

	light.LightColor = lightColor;
	light.LightPos = lightPos.xyz;

	if (lightPos.w == 0) 
	{
		light.LightDir = normalize(lightPos);
	}
	return light;
}


#endif