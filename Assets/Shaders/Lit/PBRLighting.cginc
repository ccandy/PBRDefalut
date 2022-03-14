#ifndef LIGHTING_INCLUDED
#define LIGHTING_INCLUDED

float CalcuateDiffuse(float3 normalDir, float3 lightDir) 
{
	return saturate(dot(normalDir, lightDir));
}

float3 CalcuateDiffuseColor(float3 lightColor, float3 normalDir, float3 lightDir) 
{
	float diffuse = CalcuateDiffuse(normalDir, lightDir);
	return lightColor * diffuse;
}


float CalcuateBlingPhong(float3 normalDir, float3 lightDir, float3 viewDir) 
{
	float3 refLightDir = reflect(-lightDir, normalDir);
	
	float spec = saturate(dot(refLightDir, viewDir));

	return spec;
}



#endif