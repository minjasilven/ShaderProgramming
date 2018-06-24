Shader "Custom/Textured with detail"
{
	Properties
	{
		_Tint("Tint", Color) = (1 ,1 ,1 ,1)
		_MainTex ("Texture", 2D) = "white" {}
		_DetailTex ("Detail Texture", 2D) = "gray" {}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex MyVertex
			#pragma fragment MyFragment

			#include "UnityCG.cginc"

			float4 _Tint;

			sampler2D _MainTex, _DetailTex;
			float4 _MainTex_ST, _DetailTex_ST;

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uvDetail : TEXCOORD1;
			};

			struct VertexData 
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertex(VertexData v)
			{
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.uvDetail = TRANSFORM_TEX(v.uv, _DetailTex);
				return i;
			}

			float4 MyFragment(Interpolators i) : SV_TARGET
			{
				float4 color = (tex2D(_MainTex, i.uv) * _Tint);
				// Main texture becomes both brighter and dimmer based on the detail texture
				// unity_ColorSpaceDouble will render material so it looks the same no matter which color space is selected
				color *= tex2D(_DetailTex, i.uvDetail) * unity_ColorSpaceDouble;
				return color;
			}
			ENDCG
		}
	}
}
