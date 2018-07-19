Shader "Test/AlphaNoiseTest"
{
	Properties
	{
		_Tint("Tint", Color) = (1 ,1 ,1 ,1)
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_Smoothness("Smoothness", Range(0.0, 1.0)) = 1.0
		_Speed("Speed", float) = 1.0
	}

	SubShader
	{
  		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _Tint;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _NoiseTex;
			float _Smoothness;
			float _Speed;

			struct VertexOutput
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uvSplat : TEXCOORD1;
			};

			struct VertexInput 
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			VertexOutput vert(VertexInput v)
			{
				VertexOutput i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.uvSplat = v.uv;

				
				return i;
			}

			float4 frag(VertexOutput i) : SV_TARGET
			{
				float4 splat = tex2D(_NoiseTex, i.uvSplat);

                if(splat.r < 0.5f)
				{
					splat.rgba = 0;
				}
				splat = saturate(_Smoothness * splat.a);

				//return splat;
				// Splat map is monochrome, so we can use any color channel (splat.r) to retrieve the value
				return  tex2D(_MainTex, i.uv) * splat.r;
			}
			ENDCG
		}
	}
}
