Shader "Unlit/WaveShader"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}

		_Color ("Color Tint", Color) = (1, 1, 1, 1)

		_Magnitude ("Distortion Depth", Float) = 1.0

		_Frequency ("Distortion Frequency", Float) = 1.0

		_WaveLength ("Wavelength", Float) = 1.0

		_WaveSpeed ("Wave Speed", Float) = 0.5


	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector"="True" "Disablebatching"="True" }
		LOD 100

		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull off


			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _Magnitude;
			float _Frequency;
			float _WaveLength;
			float _WaveSpeed;
			
			v2f vert (a2v v)
			{
				v2f o;

				float4 offset;

				offset.yzw = float3(0.0, 0.0, 0.0);

				offset.x = sin( _Frequency *  _Time.y + v.vertex.x/ _WaveLength + v.vertex.y / _WaveLength + v.vertex.z / _WaveLength) * _Magnitude;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex + offset);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv += float2(0.0, _Time.y * _WaveSpeed);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= _Color.rgb;
				return col;
			}
			ENDCG
		}
	}

	Fallback "Tramsparent/VertexLit"
}
