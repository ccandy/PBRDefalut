#ifndef PBRLIGHTING_INCLUDED
#define PBRsLIGHTING_INCLUDED

#include "UnityLightingCommon.cginc"
#include "PBRSurface.cginc"


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
	//float3 normal:TEXCOORD1;
	//float3 posWS:TEXCOORD2;
	float4 posCS : SV_POSITION;
};

sampler2D _MainTex;
float4 _MainTex_ST;
float4 _Color;
float _Metallc, _Roughness;

VertexOutput VertProgram(VertexInput input)
{
	VertexOutput o;
	o.posCS = UnityObjectToClipPos(input.posOS);
	o.uv = TRANSFORM_TEX(input.uv, _MainTex);

	return o;
}

float4 FragProgram(VertexOutput input) : SV_Target
{
    
	float4 col = tex2D(_MainTex, input.uv);
	float4 finalCol = col * _Color;
	return finalCol;
	
}


#endif