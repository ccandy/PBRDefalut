#ifndef PBRCALLIGHTING_INCLUDED
#define PBRCALLIGHTING_INCLUDED

#define PI 3.1415926

float3 FresnelSchlick(float cosTheta, float F0)
{
	float3 F = F0 + (1 - F0) * pow(1 - cosTheta, 5);
	return F;
}


float3 CalDirectionDiffuse(PBRSurface surface, PBRLight light, float kd) 
{

	float NdotL = saturate(dot(surface.NormalWS, light.LightDir));
	float3 diffuseColor = (surface.SurfaceColor.rgb / PI) * kd * NdotL;
	return diffuseColor;
}



#endif