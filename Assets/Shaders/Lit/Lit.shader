Shader "PBRDefault/Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", color) = (1,1,1,1)
        _Specular("Spec Color", float) = 1
        _Shinness("Shinness", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"
            #include "PBRLighting.cginc"
            #include "PBRLight.cginc"
            #include "PBRSurface.cginc" 
            #include "UnityLightingCommon.cginc"

            struct VertexInput
            {
                float4 posOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
                
            };

            struct VertexOutput
            {
                float2 uv : TEXCOORD0;
                float4 posCS : SV_POSITION;
                float3 normal:TEXCOOR1;
                float3 posWS:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Shinness, _Specular;
            
            
            VertexOutput vert (VertexInput input)
            {
                VertexOutput output;
                
                output.posCS = UnityObjectToClipPos(input.posOS);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.normal = UnityObjectToWorldNormal(input.normal);
                
                float4 worldPos = mul(unity_ObjectToWorld, input.posOS);
                output.posWS = worldPos.xyz;

                return output;
            }

            fixed4 frag (VertexOutput input) : SV_Target
            {
                
                fixed4 col = tex2D(_MainTex, input.uv);
                
                float3 normalDir = normalize(input.normal);
                
                
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;

                PBRLight pbrLight = CreateLight(lightColor, lightDir);
                PBRSurface pbrSurface = CreateSurface(normalDir, _Color, _Shinness, _Specular);


                float3 diffuseColor = CalcuateDiffuseColor(pbrLight, pbrSurface);
                float3 specColor = CalcualteSpecColor(pbrLight, pbrSurface, _WorldSpaceCameraPos.xyz, input.posWS);

                float4 finalCol = col * pbrSurface.surfaceColor * float4(diffuseColor + specColor,1);
                return finalCol;
            }
            ENDCG
        }
    }
}
