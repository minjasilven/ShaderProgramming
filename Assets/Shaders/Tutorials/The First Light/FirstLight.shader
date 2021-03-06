﻿Shader "Custom/FirstLight"
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
			#pragma vertex MyVertex
			#pragma fragment MyFragment

			#include "UnityCG.cginc"

			float4 _Tint;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
			};

			struct VertexData 
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			Interpolators MyVertex(VertexData v)
			{
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.normal = v.normal;
				return i;
			}

			float4 MyFragment(Interpolators i) : SV_TARGET
			{
				return float4(i.normal * 0.5 + 0.5, 1);
			}
			ENDCG
		}
	}
}
