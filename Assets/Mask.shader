Shader "Unlit/EyeMask" {

    Properties{
        _Angle("Angle", Range(0, 180)) = 90
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _SectorColor("Sector Color", Color) = (1, 0, 0, 1)
        _EyeSectoral("Eye Sectoral", Range(0, 1)) = 0
        _Offset("Offset", Range(0, 360)) = 0
        _SectorStart("SectorStart", Range(0, 360)) = 0
        _SectorEnd("SectorEnd", Range(0, 360)) = 0
        _PixelAngle("PixelAngle", Range(0, 360)) = 0
    }

    SubShader{
        Tags { "Queue" = "Transparent" }
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t {

                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _MainColor;
            float4 _SectorColor;
            int _EyeSectoral;
            float _Angle;
            float _Offset;
            float _SectorStart;
            float _SectorEnd;
            float _PixelAngle;

            // Vertex Shader
            v2f vert(appdata_t v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            // Fragment Shader
            half4 frag(v2f i) : SV_Target {

                half4 col = _MainColor;

                _SectorStart = (_Offset) * 3.14159265359 / 180.0;
                _SectorStart = _SectorStart % (2 * 3.14159265359);


                _SectorEnd = (_SectorStart + -_Angle + _Offset) * 3.14159265359 / 180.0;
                _SectorEnd = _SectorEnd % (2 * 3.14159265359);

                half2 center = half2(0.5, 0.5);
                half2 toPixel = i.texcoord - center;
                _PixelAngle = atan2(toPixel.x, toPixel.y);

                if (_EyeSectoral == 1) {

                    if (_SectorStart >= _PixelAngle && _PixelAngle >= _SectorEnd) {
                        col = _SectorColor;
                    }
                    else {
                        col = _MainColor;
                    }
                }

                return col;
            }
            ENDCG
        }
    }
}