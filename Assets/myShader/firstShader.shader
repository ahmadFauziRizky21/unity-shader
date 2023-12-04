Shader "Custom/firstShader"
{
    Properties
    {
        _ColorPrimary ("Primary Color", Color) = (1,1,1,1)
        _ColorSecondary ("Secondary Color", Color) = (1,1,1,1)
        _ColorLine ("Line Color", Color) = (1,1,1,1)

        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _ColorPrimary;
        fixed4 _ColorSecondary;
        fixed4 _ColorLine;

        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _ColorPrimary;
            o.Albedo = c.rgb;

            float deltaTime = 2.0;
            float normalizedWorldPos = (IN.worldPos.y + 0.5) / 1.0; // Assuming the cube has a size of 1.0

            float currPos = (normalizedWorldPos - _Time.y % deltaTime) / deltaTime;
            float colorIndex = floor(IN.worldPos.y / deltaTime);
            if (abs(currPos - frac(currPos * 2.0)) < 0.02) // You can adjust the condition based on your requirements
            {
                o.Albedo = _ColorLine;
            }
         

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
