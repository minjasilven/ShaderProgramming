Shader "Custom/Texture Splatting with waves"
{
	Properties
	{
		_MainTex ("Splat Map", 2D) = "white" {}
		[NoScaleOffset] _Texture1 ("Texture 1", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex MyVertex
			#pragma fragment MyFragment

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _Texture1;
			float3 worldPos;

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uvSplat : TEXCOORD1;
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
				worldPos = mul(unity_ObjectToWorld, v.position).xyz;
				
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);

				i.uvSplat = v.uv;
				return i;
			}

			float4 MyFragment(Interpolators i) : SV_TARGET
			{
				float4 splat = tex2D(_MainTex, i.uvSplat);
				//worldPos += i.position.y + (i.position.y * sin(worldPos.x * _Time.y));

				//float4 waves = 

				// Splat map is monochrome, so we can use any color channel (splat.r) to retrieve the value
				return tex2D(_Texture1, i.uv) * splat.r;
			}
			ENDCG
		}
	}
}
