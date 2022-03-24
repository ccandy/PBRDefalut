Shader "PBRDefault/PBRLitFix"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        [Gamma]_Metallic("Metallic", Range(0,1)) = 1
        _Roughness("Rougnness", Range(0,1)) = 1
        _Color("Color", color) = (1,1,1,1)
        _BaseF0("Base F0", Range(0,1)) = 0.04
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
            #include "UnityLightingCommon.cginc"

            struct a2v
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
                float4 positionWS:TEXCOORD2;
                float3 normal:TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Metallic, _Roughness, _BaseF0;


            float Distribution(float roughness, float nh) 
            {
                float lerpSquareRoughness = pow(lerp(0.002, 1, roughness),2);
                float D = lerpSquareRoughness / (pow((pow(nh, 2) * (lerpSquareRoughness - 1) + 1), 2) * UNITY_PI);
                
                return D;
            }

            float Geometry(float roughness, float nl, float nv) 
            {
                float kDirectLight = pow(roughness + 1, 2) / 8;
                float GLeft = nl / lerp(nl, 1, kDirectLight);
                float GRight = nv / lerp(nv, 1, kDirectLight);

                float G = GLeft * GRight;

                return G;
            }


            float3 Fresnel(float3 F0, float vh) 
            {
                float3 F = F0 + (1 - F0) * exp2((-5.55473 * vh - 6.98316) * vh);
                return F;
            }

            v2f vert (a2v v)
            {
                v2f o;
                o.positionCS = UnityObjectToClipPos(v.positionOS);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.normal = normalize(o.normal);
                o.positionWS = mul(unity_ObjectToWorld, v.positionOS);

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {

                //perpare data

                float normal = normalize(i.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.positionWS.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfVector = normalize(lightDir + viewDir);
                
                float roughness = _Roughness * _Roughness;
                float squareRoughness = roughness * roughness;

                float3 Albedo = _Color.rgb * tex2D(_MainTex, i.uv).rgb;

                //limit data

                float nl = max(saturate(dot(i.normal, lightDir)), 0.00001);
                float nv = max(saturate(dot(i.normal, viewDir)), 0.00001);
                float vh = max(saturate(dot(viewDir, halfVector)), 0.00001);
                float lh = max(saturate(dot(lightDir, halfVector)), 0.00001);
                float nh = max(saturate(dot(i.normal, halfVector)), 0.00001);
                
                //Spec Direct light
                float D = Distribution(roughness, nh);
                float G = Geometry(roughness, nl, nv);
                float3 F0 = lerp(unity_ColorSpaceDielectricSpec.rgb, Albedo, _Metallic);
                float3 F = Fresnel(F0, vh);

                float3 specularResult = (D * F * G) / (nv * nl * 4);
                float3 specColor = specularResult * lightColor * nl * UNITY_PI;
                specColor = saturate(specColor);



                return float4(specColor, 1);
            }
            ENDCG
        }
    }
}
