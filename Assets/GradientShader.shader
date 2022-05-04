Shader "Unlit/GradientShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _GradientStart("Gradient Start",range(0,1)) = 0
        _GradientEnd("Gradient End",range(0,1)) = 1
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _ColorA;
            float4 _ColorB;
            float _GradientStart;
            float _GradientEnd;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float v) {//Allows you to move the start and end of the gradient
                return (v - a) / (b - a);
            }

            float4 frag(v2f i) : SV_Target
            {
                // sample the texture
                float t = saturate(InverseLerp(_GradientStart,_GradientEnd,i.uv.x));//saturate = clamp;
                float4 lerpCol = lerp(_ColorA, _ColorB, t);
                return lerpCol;
            }
            ENDCG
        }
    }
}
