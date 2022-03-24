#ifndef PBRCALLIGHTING_INCLUDED
#define PBRCALLIGHTING_INCLUDED



float3 FresnelSchlick(float3 viewDir, float3 halfVector	, float3 F0)
{

	float cosTheta = saturate(dot(viewDir, halfVector));
	float3 F = F0 + (1 - F0) * exp2((-5.55473 * cosTheta - 6.98316) * cosTheta);
	return F;
}

float3 CalDirectionDiffuse(PBRSurface surface, PBRLight light, float3 kd) 
{
	
	float NdotL = saturate(dot(surface.NormalWS, light.LightDir));
	float3 diffuseColor = (surface.SurfaceColor.rgb / UNITY_PI) * kd * NdotL;
	return diffuseColor;
}

float DistributionGGX(PBRSurface surface, float3 halfvector) 
{

	float r = surface.Roughness;
	float r2 = r * r;

	float3 n = surface.NormalWS;
	float NdotH = max(saturate(dot(n, halfvector)), 0.00001);
	float temp = (NdotH * NdotH * (r2 - 1) + 1);
	float result = UNITY_PI * temp * temp;

	//return r2 / result;
	float lerpSquareRoughness = pow(lerp(0.002, 1, r), 2);
	float D = lerpSquareRoughness / (pow((pow(NdotH, 2) * (lerpSquareRoughness - 1) + 1), 2) * UNITY_PI);

	return D;
}


float SchlickGGX(float3 normal, float3 dir, float roughness) 
{
	float kdir = (roughness + 1) * (roughness + 1) / 8;

	float NdotD = saturate(dot(normal, dir));
	float ggx = NdotD / lerp(NdotD, 1, kdir);
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

	return saturate(FDG * UNITY_PI * NdotL);
}


float3 CalcualteDirectionLight(PBRSurface surface, PBRLight light, float3 viewDir, float3 halfVector) 
{
	float3 F = FresnelSchlick(viewDir, halfVector, surface.BaseF0);
	float3 kd = (1 - F) * (1 - surface.Metallic);

	float3 diffuseColor = CalDirectionDiffuse(surface, light, kd);
	float3 specColor = CalcualteSpecColor(surface, light, viewDir, halfVector);

	return diffuseColor + specColor;
}

half CalcuateCubeMap(float roughness) 
{
	float mipRoughness = roughness * (1.7 - 0.7 * roughness);
	half mip = mipRoughness * UNITY_SPECCUBE_LOD_STEPS;

	return mip;
}

float3 CalculateInDirectionSpec(PBRSurface surface, PBRLight light, float3 viewDir) 
{
	float roughness = surface.Roughness;
	half mip = CalcuateCubeMap(roughness);
	float3 reflectVector = reflect(-viewDir, surface.NormalWS);
	
	half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectVector, mip);
	float3 iblSpecular = DecodeHDR(rgbm, unity_SpecCube0_HDR);

	half surfaceReduction = 1.0/(roughness * roughness + 1.0);

	float oneMinusReflectivity = unity_ColorSpaceDielectricSpec.a - unity_ColorSpaceDielectricSpec.a * surface.Metallic;
	half grazingTerm = saturate((1 - surface.Roughness) + (1 - oneMinusReflectivity));

	float nv = max(saturate(dot(surface.NormalWS, viewDir)), 0.000001);
	half t = Pow5(1 - nv);
	float3 FresnelLerp = lerp(surface.BaseF0, grazingTerm, t);

	float3 iblSpecularResult = surfaceReduction * iblSpecular * FresnelLerp;

	return iblSpecularResult;

}
float3 FresnelSchlickRoughness(float cosTheta, float3 F0, float roughness)
{
	return F0 + (max(float3(1, 1, 1) * (1 - roughness), F0) - F0) * pow(1.0 - cosTheta, 5.0);
}

float3 CalculateInDirectionDiffuse(PBRSurface surface, PBRLight light, float3 viewDir)
{
	float4 normal = float4(surface.NormalWS, 1);
	float3 F0 = surface.BaseF0;
	float roughness = surface.Roughness;
	
	half3 iblDiffuse = ShadeSH9(normal);
	
	float nv = max(saturate(dot(surface.NormalWS, viewDir)), 0.000001);
	
	float3 Flast = FresnelSchlickRoughness(max(nv, 0.0), F0, roughness);
	float k = (1 - Flast) * (1 - surface.Metallic);
	float3 iblDiffuseResult = iblDiffuse * k;
	return iblDiffuseResult;
}



float3 CalcualteInDirectionLight(PBRSurface surface, PBRLight light, float3 viewDir) 
{
	float roughness = surface.Roughness;
	half mip = CalcuateCubeMap(roughness);
	float3 reflectVector = reflect(-viewDir, surface.NormalWS);

	float3 diffuse = CalculateInDirectionDiffuse(surface, light, viewDir);
	float3 spec = CalculateInDirectionSpec(surface, light, viewDir);

	return spec;
	return diffuse + spec;
}

#endif