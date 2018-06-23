Shader "Custom/FirstShader"
{
	// A: Simple color
	// B: Interpreting local positions as colors
	// C: Using structures
	// D: Tweaking colors
	// E: Texturing
	// F: Tiling and offset

	// Shown in inspector
	Properties
	{
		// B
		// Property name, string shown in inspector, property type, default value
		_Tint("Tint", Color) = (1 ,1 ,1 ,1)

		// E
		// Adding a texture, default value for the string is either white, black or gray
		_MainTex ("Texture", 2D) = "white" {}
	}

	// Different subshaders for different build platforms or levels of detail
	// For example different for desktop/mobile
	SubShader
	{
		// Where object actually gets rendered
		// Multiple passes means object gets rendered multiple times
		// Required for lot of effects
		Pass
		{
			// Unity's shading language
			// Variant of HLSL and CGShading languages
			CGPROGRAM
			#pragma vertex MyVertex
			#pragma fragment MyFragment

			#include "UnityCG.cginc"

			// B
			// Add inspector property as variable, note that the name has to be the same!
			float4 _Tint;

			// E
			sampler2D _MainTex;

			// F
			// "Scale and Transition", old name for tiling and offset
			// _ST is used if offset and tiling are used
			// To use tiling, simply multiply it with UV coordinates
			// To use offset, add it after UV scaling
			float4 _MainTex_ST;

			// C
			// We can define data structures, which are simply a collection of variables
			// This defines the data that we're interpolating
				//struct Interpolators
				//{
				//	float4 position : SV_POSITION;
				//	float3 localPosition : TEXCOORD0;
				//};

			// E
			// Let's just pass the UV coordinates straight to the fragment program, replacing the localPosition
			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			// C
			// Using structs makes our code a lot tidier
			//Interpolators MyVertex(float4 position: POSITION)
			//{
				//Interpolators i;
				//i.localPosition = position.xyz;
				//i.position = UnityObjectToClipPos(position);
				//return i;

				//E
				// Texture coordinates are used to control the projection
				// These are 2D coordinate pairs that cover the entire image in one-unit square area
				// Horizontal coordinate is known as U and vertical as V --> UV coordinates
				// U coordinate increases from left to right, so it's 0 at the left side of the image, 1/2 halfway,
				// and 1 at the right side, the V coordinate works the same way vertically, increases from top to bottom

				//	(0,1) ------ (1,1)
				//    |            |
				//    |            |
				//    |            |
				//	(0,0) ------ (1,0)

			//E
			struct VertexData 
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			// E
			// Vertex program can access UV coordinates via a parameter with the TEXCOORD0 semantic
			// Our vertex program now uses more tham one input parameter --> struct to group them
			Interpolators MyVertex(VertexData v)
			{
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				// E
					//i.uv = v.uv;
					//return i;

				// F
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				// UnityCG.cginc contains a macro for this --> i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return i;

			// A
			// Returns position of vertex in display position
			// float4 is just collection of 4 floating point numbers
			//float4 MyVertex(float4 position : POSITION, out float3 localPosition : TEXCOORD0) : SV_POSITION
			//{
				// A
				// Changes object-space positions to display positions
				// If not done, object would look distorted
				// Upgraded, original was mul(UNITY_MATRIX_MVP, position)
					//return UnityObjectToClipPos(position);

				// B
				//Vertex program needs to output the local position for using the position in fragment program
				// Use the same output semantic
				// To pass the data through the vertex program, copy the X, Y and Z components
				// from position and localPosition
					//localPosition = position.xyz;
					//return UnityObjectToClipPos(position);
			}

			// C
			float4 MyFragment(Interpolators i) : SV_TARGET
			{
				// C
				//return float4(i.localPosition, 1);

			// A
			// RGB color or each pixel
			// Semantics: SV_POSITION --> let compiler know we want to return a position
			// TEXCOORD0 --> there are no generic semantics for interpolated data, everyone just uses texture
			// coordinate semantics for everything that's interpolated and is not a vertex position
			// SV_TARGET --> default shader target, this is the frame buffer which contains the image we are generating
			//float4 MyFragment(float4 position : SV_POSITION, float3 localPosition : TEXCOORD0) : SV_TARGET
			//{
				// A
				// Colors the object, in this case yellow
					//return float4(1,1,0,1);

				// Returns the color set at Unity inspector
				// Now the vertex program's data is not used at all
					// return _Tint;

				// B
				// To access interpolated local position, we add parameter localPosition
				// that only needs X, Y and Z --> float3, then output position as it were a color
				// We do need to provide fourth component, which can simply remain 1
					//return float4(localPosition, 1);

				// D
				// Negative colors get clamped to zero, our sphere is rather dark
				// As the default sphere has an object-space radius of 1/2 so the color channels end up
				// somewhere between -1/2 and 1/2. We want them to 0-1 range, which we can do by adding 1/2
				// to all channels
				// We can also apply our tint by factoring it into the result
					//return float4(i.localPosition + 0.5, 1) + _Tint;

				// E
				// We can make UV coordinates visible, just like the local position, by interpreting them as 
				// color channels
					//return float4(i.uv, 1, 1);

				// E
				// Sampling the texture with UV coordinates is done in the fragment program by using tex2D function
				return tex2D(_MainTex, i.uv) * _Tint;

			}
			ENDCG
		}
	}
}
