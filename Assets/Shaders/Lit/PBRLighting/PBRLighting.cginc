#ifndef PBRCALLIGHTING_INCLUDED
#define PBRCALLIGHTING_INCLUDED

#define PI 3.1415926

float3 CalDirectionDiffuse(float4 color, float kd) 
{
	return (color.rgb / PI) * kd;
}


float3 FresnelSchlick(float cosTheta, float F0) 
{
	float3 F = F0 + (1 - F0) * pow(1 - cosTheta, 5);
	return F;
}

#endif