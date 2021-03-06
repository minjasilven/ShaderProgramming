﻿Shader "Custom/Template"
{
	Properties
	{
		_Tint("Tint", Color) = (1 ,1 ,1 ,1)
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _Tint;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct VertexOutput
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
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
				return i;
			}

			float4 frag(VertexOutput i) : SV_TARGET
			{
				return tex2D(_MainTex, i.uv) * _Tint;
			}
			ENDCG
		}
	}
}
