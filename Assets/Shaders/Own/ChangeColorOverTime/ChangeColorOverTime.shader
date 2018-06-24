Shader "Custom/ChangeColorOverTime"
{
	Properties
	{
		_Color1("Color 1", Color) = (1 ,1 ,1 ,1)
		_Color2("Color 2", Color) = (0 ,1 ,1 ,1)
		_Color3("Color 3", Color) = (1 ,1 ,0 ,1)
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex MyVertex
			#pragma fragment MyFragment

			#include "UnityCG.cginc"

			float4 _Color1;
			float4 _Color2;
			float4 _Color3;

			uniform float time;

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
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
				i.uv = v.uv;

				return i;
			}

			float4 MyFragment(Interpolators i) : SV_TARGET
			{
				float4 sin = _SinTime;
				return sin > 0 ? _Color1 : _Color2;
			}
			ENDCG
		}
	}
}
