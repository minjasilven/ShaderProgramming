Shader "WhatMinjaDoes/WaterWithShoreline"
{
	Properties
	{
		_MainTex("Water texture", 2D) = "white" {}
		_DepthFactor("Depth Factor", float) = 1.0
		_RampTexture("Ramp texture", 2D) = "white" {}

		_Color("Color", color) = (1,1,1,1)

		_WaveSpeed("Wave speed", float) = 1.0
		_WaveAmp("Wave amp", float) = 1.0
		_NoiseTex("Noise texture", 2D) = "white" {}
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

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _Color;

			float _DepthFactor;
			sampler2D _RampTexture;

			float _WaveSpeed;
			float _WaveAmp;
			sampler2D _NoiseTex;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct vertexOutput
			{
			   float4 pos : SV_POSITION;
			   float2 uv : TEXCOORD0;
			   float4 screenPos : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv = TRANSFORM_TEX(input.uv, _MainTex);

				float noiseSample = tex2Dlod(_NoiseTex, float4(input.uv.xy, 0, 0));
				output.pos.y += sin(_Time * _WaveSpeed * noiseSample) * _WaveAmp;
				output.pos.x += cos(_Time * _WaveSpeed * noiseSample) * _WaveAmp;

				// compute depth (screenPos is a float4)
				output.screenPos = ComputeScreenPos(output.pos);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				// sample camera depth texture
				float4 depthSample = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, input.screenPos);
  				float depth = LinearEyeDepth(depthSample).r;

				// Because the camera depth texture returns a value between 0-1,
				// we can use that value to create a grayscale color
				// to test the value output.
  				float foamLine = 1 - saturate(_DepthFactor * (depth - input.screenPos.w));
  				// sample the ramp texture
  				float4 foamRamp = float4(tex2D(_RampTexture, float2(foamLine, 0.5)).rgb, 1.0);
				return tex2D(_MainTex, input.uv) * foamRamp;
			}

		 ENDCG
		}
	}
}