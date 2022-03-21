#ifndef PBRLIGHTING_INCLUDED
#define PBRsLIGHTING_INCLUDED

#include "UnityLightingCommon.cginc"
#include "PBRSurface.cginc"
#include "PBRLight.cginc"
#include "PBRLighting.cginc"

#define PI 3.1415926

struct VertexInput
{
    float4 posOS : POSITION;
    float2 uv : TEXCOORD0;
	float3 normal:NORMAL;
	UNITY_VERTEX_INPUT_INSTANCE_ID
	
};

struct VertexOutput
{
    float2 uv : TEXCOORD0;
	float3 normal:TEXCOORD1;
	float3 posWS:TEXCOORD2;
	float4 posCS : SV_POSITION;

};

sampler2D _MainTex;
float4 _MainTex_ST;
float4 _Color;
float _Metallic, _Roughness, _BaseF0;

VertexOutput VertProgram(VertexInput input)
{
	VertexOutput o;
	o.posCS = UnityObjectToClipPos(input.posOS);
	
	float4 worldPos = mul(unity_ObjectToWorld, input.posOS);
	o.posWS = worldPos.xyz;

	o.uv = TRANSFORM_TEX(input.uv, _MainTex);
	o.normal = UnityObjectToWorldNormal(input.normal);
	return o;
}

float4 FragProgram(VertexOutput input) : SV_Target
{
	
	PBRSurface pbrSurface = CreateSurface(input.normal,_Color,_Metallic,_Roughness,_BaseF0);
	PBRLight pbrLight = CreateLight(_LightColor0, _WorldSpaceLightPos0);

	float3 viewDir = normalize(_WorldSpaceCameraPos - input.posWS);
	float3 halfVector = normalize(viewDir+pbrLight.LightDir);
	
	float3 F = FresnelSchlick(viewDir,halfVector, pbrSurface.BaseF0);
	float3 kd = (1 - F) * (1 - pbrSurface.Metallic);
	//pbrSurface.kd = kd;

	float3 diffuseColor = CalDirectionDiffuse(pbrSurface, pbrLight, kd);
	float3 specColor = CalcualteSpecColor(pbrSurface, pbrLight, viewDir, halfVector);

	float4 col = tex2D(_MainTex, input.uv);
	float4 finalCol = col * _Color * float4(diffuseColor + specColor,1);
	float D = DistributionGGX(pbrSurface, halfVector);
	float G = GeometrySmith(pbrSurface, pbrLight, viewDir);

	return finalCol * PI;
	
}


#endif