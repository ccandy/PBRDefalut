Shader "PBRDefault/PBRLit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Metallic("Metallc", float) = 1
        _Roughness("Rougnness", float) = 1
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
            #pragma vertex VertProgram
            #pragma fragment FragProgram
            
            #include "UnityCG.cginc"
            #include "PBRLit.cginc"
            
            ENDCG
        }
    }
}
