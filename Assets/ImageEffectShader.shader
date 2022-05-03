Shader "Hidden/ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlueTint("Blue Tint", Range(0,2)) = 1.0
        _GreenTint("Green Tint",Range(0,2)) = 1.0
        _RedTint("Red Tint",Range(0,2)) = 1.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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
                float change : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.change = _SinTime;
                return o;
            }

            sampler2D _MainTex;
            float _BlueTint;
            float _RedTint;
            float _GreenTint;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                col.b *= _BlueTint * i.change;
                col.r *= _RedTint;
                col.g *= _GreenTint;
                return col;
            }
            ENDCG
        }
    }
}
