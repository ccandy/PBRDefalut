Shader "PBRDefault/RegularLit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
       
        _Color("Color", color) = (1,1,1,1)
        _Shinness("Shinness", float) = 1
        _SpecStrength("Spec Strength", float) = 1
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
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"
            #include "RegularLit.cginc"
            
            
            ENDCG
        }
    }
}
