#ifndef PBRLIGHTING_INCLUDED
#define PBRsLIGHTING_INCLUDED

#include "UnityLightingCommon.cginc"
#include "UnityStandardBRDF.cginc"
#include "PBRSurface.cginc"
#include "PBRLight.cginc"
#include "PBRLighting.cginc"

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
float _Metallic, _Roughness;

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
	float4 col = tex2D(_MainTex, input.uv);
	
	PBRSurface pbrSurface = CreateSurface(input.normal,_Color, col, _Metallic,_Roughness);
	PBRLight pbrLight = CreateLight(_LightColor0, _WorldSpaceLightPos0);
	
	float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.posWS);
	float3 halfVector = normalize(viewDir+pbrLight.LightDir);
	
	
	float3 directLightColor = CalcualteDirectionLight(pbrSurface, pbrLight, viewDir, halfVector);
	float3 inDirectLightColor = CalcualteInDirectionLight(pbrSurface, pbrLight, viewDir);

	return float4(inDirectLightColor, 1);

	float NdotL = saturate(dot(pbrSurface.NormalWS, pbrLight.LightDir));
	float4 finalCol = pbrSurface.SurfaceColor * float4(pbrLight.LightColor,1) *  float4(directLightColor + inDirectLightColor,1) * UNITY_PI * NdotL;
	return finalCol;
	
}


#endif