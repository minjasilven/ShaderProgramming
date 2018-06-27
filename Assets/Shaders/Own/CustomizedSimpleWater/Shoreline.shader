Shader "WhatMinjaDoes/Shoreline"
{
	Properties
	{
		_Color("Water color", Color) = (1, 1, 1, 1)
		_EdgeColor("Edge Color", Color) = (1, 1, 1, 1)
		_FadeAmount("Fade amount", Range(0.0, 5.0)) = 1.0
		_HeightAmount("Height", Range(0.1, 5.0)) = 0.5
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag
 
			sampler2D _CameraDepthTexture;

			float4 _Color;
			float4 _EdgeColor;
			float _FadeAmount;
			float _HeightAmount;

			struct vertexInput
			{
				float4 vertexPos : POSITION;
			};

			struct vertexOutput
			{
			   float4 pos : SV_POSITION;
			   float4 depth : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				output.pos = UnityObjectToClipPos(input.vertexPos);

				output.depth = ComputeScreenPos(output.pos);
				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				float4 sample = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, input.depth);
  				float sceneDepth = LinearEyeDepth(sample).r;
  				float shoreLine = saturate(_HeightAmount * (sceneDepth - input.depth.w));

				float4 finalColor;
				if(shoreLine > _FadeAmount)
					finalColor = _Color;
				else
					finalColor = float4(_Color.rgb * shoreLine + _EdgeColor * (1 - shoreLine), 1);

				return finalColor;
			}

		 ENDCG
		}
	}
}