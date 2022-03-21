#ifndef PBRCALLIGHTING_INCLUDED
#define PBRCALLIGHTING_INCLUDED

#define PI 3.1415926

float3 FresnelSchlick(float3 viewDir, float3 halfVector	, float F0)
{

	float cosTheta = saturate(dot(viewDir, halfVector));
	float3 F = F0 + (1 - F0) * pow(1 - cosTheta, 5);
	return F;
}

float3 CalDirectionDiffuse(PBRSurface surface, PBRLight light, float3 kd) 
{
	
	float NdotL = saturate(dot(surface.NormalWS, light.LightDir));
	float3 diffuseColor = (surface.SurfaceColor.rgb / PI) * kd * NdotL;
	return diffuseColor;
}

float DistributionGGX(PBRSurface surface, float3 halfvector) 
{

	float r = surface.Roughness;
	float r2 = r * r;

	float3 n = surface.NormalWS;
	float NdotH = saturate(dot(n, halfvector));
	float temp = (NdotH * NdotH * (r2 - 1) + 1);
	float result = PI * temp * temp;

	return r2 / result;

}


float SchlickGGX(float3 normal, float3 dir, float roughness) 
{
	float kdir = (roughness + 1) * (roughness + 1) / 8;

	float NdotD = saturate(dot(normal, dir));
	float ggx = NdotD / (NdotD * (1 - kdir) + kdir);
	return ggx;
}

float GeometrySmith(PBRSurface surface, PBRLight light, float viewDir) 
{
	float3 lightDir = light.LightDir;

	float g1 = SchlickGGX(surface.NormalWS, viewDir, surface.Roughness);
	float g2 = SchlickGGX(surface.NormalWS, lightDir, surface.Roughness);

	return g1 * g2;
}

float3 CalcualteSpecColor(PBRSurface surface, PBRLight light, float3 viewDir, float3 halfVector) 
{
	float3 F = FresnelSchlick(viewDir, halfVector, surface.BaseF0);
	float G = GeometrySmith(surface, light, viewDir);
	float D = DistributionGGX(surface, halfVector);

	float NdotV = saturate(dot(surface.NormalWS, viewDir));
	float NdotL = saturate(dot(surface.NormalWS, light.LightDir));

	float3 FDG = F * G * D;
	FDG /= 4 * NdotV * NdotL;

	return FDG;
}


#endif