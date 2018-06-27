Shader "Custom/Shoreline"
{
	Properties
	{
		_Color("Water color", Color) = (1, 1, 1, 1)
		_EdgeColor("Edge Color", Color) = (1, 1, 1, 1)
		_FadeAmount("Fade amount", float) = 1.0
		_HeightAmount("Height", float) = 0.1
	}

	SubShader
	{
		Pass
		{

			CGPROGRAM
			// required to use ComputeScreenPos()
			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag
 
			// Unity built-in - NOT required in Properties
			sampler2D _CameraDepthTexture;

			float4 _Color;
			float4 _EdgeColor;
			float _FadeAmount;
			float _HeightAmount;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct vertexOutput
			{
			   float4 pos : SV_POSITION;
			   float2 uv : TEXCOORD0;
			   float4 vertexDepth : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				// convert obj-space position to camera clip space
				output.pos = UnityObjectToClipPos(input.vertex);
				// compute depth (screenPos is a float4)
				output.vertexDepth = ComputeScreenPos(output.pos);
				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				float4 depthSample = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, input.vertexDepth);
  				float sceneDepth = LinearEyeDepth(depthSample).r;

				// Because the camera depth texture returns a value between 0-1,
				// we can use that value to create a grayscale color
				// to test the value output.
  				float foamLine = saturate(_HeightAmount * (sceneDepth - input.vertexDepth.w));
  				// sample the ramp texture
				float4 color = float4(0,0,1,1);
				if(foamLine > _FadeAmount)
					return _Color;
				else
					return _EdgeColor;
			}

		 ENDCG
		}
	}
}