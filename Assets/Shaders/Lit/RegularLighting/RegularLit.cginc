#ifndef REGULARLIGHTING_INCLUDED
#define REGULARLIGHTING_INCLUDED

#include "UnityLightingCommon.cginc"
#include "RegularSurface.cginc"
#include "RegularLight.cginc"
#include "RegularLighting.cginc"

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
float _Shinness;
float _SpecStrength;

VertexOutput VertProgram(VertexInput input)
{
	VertexOutput o;
	UNITY_SETUP_INSTANCE_ID(input);
    o.posCS = UnityObjectToClipPos(input.posOS);
    o.uv = TRANSFORM_TEX(input.uv, _MainTex);
	o.normal = UnityObjectToWorldNormal(input.normal);
	
	float4 worldPos = mul(unity_ObjectToWorld, input.posOS);
	o.posWS = worldPos.xyz;

    return o;
}

float4 FragProgram(VertexOutput input) : SV_Target
{
    // sample the texture
	float4 col = tex2D(_MainTex, input.uv);

	RegularLight light = CreateLight(_LightColor0.rgb, _WorldSpaceLightPos0);
	RegularSurface surface = CreateSurface(input.normal, _Color, _SpecStrength, _Shinness);

	float3 diffuseColor = CalcuateDiffuseColor(surface, light);
	float3 specColor = CalcualteSpecColor(surface, light, _WorldSpaceCameraPos, input.posWS);

	float4 finalCol = col * surface.surfaceColor * float4(diffuseColor + specColor, 1);

	return finalCol;
}


#endif