Shader "FaderCircle"
{
    Properties
    {
        [NoScaleOffset] Texture2D_537bfbadffce4b87bf05ea79a600199f("MainTexture", 2D) = "white" {}
        Color_17ab3c68e3954f68bfcc1fa5db3024ee("Tint", Color) = (1, 1, 1, 0)
        _PositionPlayer("PlayerPos", Vector) = (0.5, 0.5, 0, 0)
        _Size("Size", Float) = 1
        Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2("Smoothness", Range(0, 1)) = 0.5
        Vector1_41f94b36521a4488883baba6e9cf4ce5("Opacity", Range(0, 1)) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue" = "Transparent"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
    #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
    #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
    #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float3 viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        float2 lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 sh;
        #endif
        float4 fogFactorAndVertexLight;
        float4 shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        float3 interp4 : TEXCOORD4;
        #if defined(LIGHTMAP_ON)
        float2 interp5 : TEXCOORD5;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 interp6 : TEXCOORD6;
        #endif
        float4 interp7 : TEXCOORD7;
        float4 interp8 : TEXCOORD8;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
        output.interp4.xyz = input.viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        output.interp5.xy = input.lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.interp6.xyz = input.sh;
        #endif
        output.interp7.xyzw = input.fogFactorAndVertexLight;
        output.interp8.xyzw = input.shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
        output.viewDirectionWS = input.interp4.xyz;
        #if defined(LIGHTMAP_ON)
        output.lightmapUV = input.interp5.xy;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.sh = input.interp6.xyz;
        #endif
        output.fogFactorAndVertexLight = input.interp7.xyzw;
        output.shadowCoord = input.interp8.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 NormalTS;
    float3 Emission;
    float Metallic;
    float Smoothness;
    float Occlusion;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_537bfbadffce4b87bf05ea79a600199f);
    float4 _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.tex, _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_R_4 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.r;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_G_5 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.g;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_B_6 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.b;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_A_7 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.a;
    float4 _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0 = Color_17ab3c68e3954f68bfcc1fa5db3024ee;
    float4 _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2;
    Unity_Multiply_float(_SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0, _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0, _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2);
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.BaseColor = (_Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2.xyz);
    surface.NormalTS = IN.TangentSpaceNormal;
    surface.Emission = float3(0, 0, 0);
    surface.Metallic = 0;
    surface.Smoothness = 0.5;
    surface.Occlusion = 1;
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "GBuffer"
    Tags
    {
        "LightMode" = "UniversalGBuffer"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
    #pragma multi_compile _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float3 viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        float2 lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 sh;
        #endif
        float4 fogFactorAndVertexLight;
        float4 shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        float3 interp4 : TEXCOORD4;
        #if defined(LIGHTMAP_ON)
        float2 interp5 : TEXCOORD5;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 interp6 : TEXCOORD6;
        #endif
        float4 interp7 : TEXCOORD7;
        float4 interp8 : TEXCOORD8;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
        output.interp4.xyz = input.viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        output.interp5.xy = input.lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.interp6.xyz = input.sh;
        #endif
        output.interp7.xyzw = input.fogFactorAndVertexLight;
        output.interp8.xyzw = input.shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
        output.viewDirectionWS = input.interp4.xyz;
        #if defined(LIGHTMAP_ON)
        output.lightmapUV = input.interp5.xy;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.sh = input.interp6.xyz;
        #endif
        output.fogFactorAndVertexLight = input.interp7.xyzw;
        output.shadowCoord = input.interp8.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 NormalTS;
    float3 Emission;
    float Metallic;
    float Smoothness;
    float Occlusion;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_537bfbadffce4b87bf05ea79a600199f);
    float4 _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.tex, _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_R_4 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.r;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_G_5 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.g;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_B_6 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.b;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_A_7 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.a;
    float4 _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0 = Color_17ab3c68e3954f68bfcc1fa5db3024ee;
    float4 _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2;
    Unity_Multiply_float(_SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0, _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0, _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2);
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.BaseColor = (_Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2.xyz);
    surface.NormalTS = IN.TangentSpaceNormal;
    surface.Emission = float3(0, 0, 0);
    surface.Metallic = 0;
    surface.Smoothness = 0.5;
    surface.Occlusion = 1;
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 NormalTS;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.NormalTS = IN.TangentSpaceNormal;
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "Meta"
    Tags
    {
        "LightMode" = "Meta"
    }

        // Render State
        Cull Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        float4 uv2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 Emission;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_537bfbadffce4b87bf05ea79a600199f);
    float4 _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.tex, _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_R_4 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.r;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_G_5 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.g;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_B_6 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.b;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_A_7 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.a;
    float4 _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0 = Color_17ab3c68e3954f68bfcc1fa5db3024ee;
    float4 _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2;
    Unity_Multiply_float(_SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0, _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0, _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2);
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.BaseColor = (_Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2.xyz);
    surface.Emission = float3(0, 0, 0);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

    ENDHLSL
}
Pass
{
        // Name: <None>
        Tags
        {
            "LightMode" = "Universal2D"
        }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_537bfbadffce4b87bf05ea79a600199f);
    float4 _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.tex, _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_R_4 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.r;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_G_5 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.g;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_B_6 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.b;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_A_7 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.a;
    float4 _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0 = Color_17ab3c68e3954f68bfcc1fa5db3024ee;
    float4 _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2;
    Unity_Multiply_float(_SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0, _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0, _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2);
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.BaseColor = (_Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2.xyz);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

    ENDHLSL
}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue" = "Transparent"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
    #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
    #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
    #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float3 viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        float2 lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 sh;
        #endif
        float4 fogFactorAndVertexLight;
        float4 shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        float3 interp4 : TEXCOORD4;
        #if defined(LIGHTMAP_ON)
        float2 interp5 : TEXCOORD5;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 interp6 : TEXCOORD6;
        #endif
        float4 interp7 : TEXCOORD7;
        float4 interp8 : TEXCOORD8;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
        output.interp4.xyz = input.viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        output.interp5.xy = input.lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.interp6.xyz = input.sh;
        #endif
        output.interp7.xyzw = input.fogFactorAndVertexLight;
        output.interp8.xyzw = input.shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
        output.viewDirectionWS = input.interp4.xyz;
        #if defined(LIGHTMAP_ON)
        output.lightmapUV = input.interp5.xy;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.sh = input.interp6.xyz;
        #endif
        output.fogFactorAndVertexLight = input.interp7.xyzw;
        output.shadowCoord = input.interp8.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 NormalTS;
    float3 Emission;
    float Metallic;
    float Smoothness;
    float Occlusion;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_537bfbadffce4b87bf05ea79a600199f);
    float4 _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.tex, _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_R_4 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.r;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_G_5 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.g;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_B_6 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.b;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_A_7 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.a;
    float4 _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0 = Color_17ab3c68e3954f68bfcc1fa5db3024ee;
    float4 _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2;
    Unity_Multiply_float(_SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0, _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0, _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2);
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.BaseColor = (_Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2.xyz);
    surface.NormalTS = IN.TangentSpaceNormal;
    surface.Emission = float3(0, 0, 0);
    surface.Metallic = 0;
    surface.Smoothness = 0.5;
    surface.Occlusion = 1;
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 NormalTS;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.NormalTS = IN.TangentSpaceNormal;
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "Meta"
    Tags
    {
        "LightMode" = "Meta"
    }

        // Render State
        Cull Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        float4 uv2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 Emission;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_537bfbadffce4b87bf05ea79a600199f);
    float4 _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.tex, _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_R_4 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.r;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_G_5 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.g;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_B_6 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.b;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_A_7 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.a;
    float4 _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0 = Color_17ab3c68e3954f68bfcc1fa5db3024ee;
    float4 _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2;
    Unity_Multiply_float(_SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0, _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0, _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2);
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.BaseColor = (_Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2.xyz);
    surface.Emission = float3(0, 0, 0);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

    ENDHLSL
}
Pass
{
        // Name: <None>
        Tags
        {
            "LightMode" = "Universal2D"
        }

        // Render State
        Cull Back
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_537bfbadffce4b87bf05ea79a600199f_TexelSize;
float4 Color_17ab3c68e3954f68bfcc1fa5db3024ee;
float2 _PositionPlayer;
float _Size;
float Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
float Vector1_41f94b36521a4488883baba6e9cf4ce5;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_537bfbadffce4b87bf05ea79a600199f);
SAMPLER(samplerTexture2D_537bfbadffce4b87bf05ea79a600199f);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_537bfbadffce4b87bf05ea79a600199f);
    float4 _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.tex, _Property_8d43bc49df3646788cd0a36bb9a323f1_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_R_4 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.r;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_G_5 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.g;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_B_6 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.b;
    float _SampleTexture2D_3308b0ff65884136912532e98135da30_A_7 = _SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0.a;
    float4 _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0 = Color_17ab3c68e3954f68bfcc1fa5db3024ee;
    float4 _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2;
    Unity_Multiply_float(_SampleTexture2D_3308b0ff65884136912532e98135da30_RGBA_0, _Property_f6f50508242f4ff7ab57548fe6cb6b01_Out_0, _Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2);
    float _Property_816e6a58dfda4c3888b9195433a761b5_Out_0 = Vector1_c4b6e7a4507c4ad8bf6ec91e4c38dfa2;
    float4 _ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0 = _PositionPlayer;
    float2 _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3;
    Unity_Remap_float2(_Property_db5f2a8bf1844018a6c11c56f7d53d20_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3);
    float2 _Add_5225213829f84312ae15014b1b1f8e08_Out_2;
    Unity_Add_float2((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), _Remap_0d6107a8fdff4b4ab4faa6c52a62834b_Out_3, _Add_5225213829f84312ae15014b1b1f8e08_Out_2);
    float2 _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_24e25693e0594b9c809cc203bf2b25ad_Out_0.xy), float2 (1, 1), _Add_5225213829f84312ae15014b1b1f8e08_Out_2, _TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3);
    float2 _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2;
    Unity_Multiply_float(_TilingAndOffset_3024a62ff7be4d9a960e9f23792d7c59_Out_3, float2(2, 2), _Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2);
    float2 _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2;
    Unity_Subtract_float2(_Multiply_5f0f004b7e5e48a7b5423b3dcd64c33b_Out_2, float2(1, 1), _Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2);
    float _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2;
    Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2);
    float _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0 = _Size;
    float _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2;
    Unity_Multiply_float(_Divide_5dea9b3fa6cf43d1a0a072eedc901d51_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0, _Multiply_5dd1872323b34355900db0d60fe8901e_Out_2);
    float2 _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0 = float2(_Multiply_5dd1872323b34355900db0d60fe8901e_Out_2, _Property_3f6546d8168b4445b46a5fc0e20907f5_Out_0);
    float2 _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2;
    Unity_Divide_float2(_Subtract_862bfdc3591e46afbd3aa07f6a1245f9_Out_2, _Vector2_29b3735174f44752a2e65577ad9722b0_Out_0, _Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2);
    float _Length_22e6e96853444a779505d697e3764da5_Out_1;
    Unity_Length_float2(_Divide_41e3ccb4c6b44903a67a86a44593dce7_Out_2, _Length_22e6e96853444a779505d697e3764da5_Out_1);
    float _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1;
    Unity_OneMinus_float(_Length_22e6e96853444a779505d697e3764da5_Out_1, _OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1);
    float _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1;
    Unity_Saturate_float(_OneMinus_a0d4b5cfd93a4a7ebb29ccfdc1e49931_Out_1, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1);
    float _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3;
    Unity_Smoothstep_float(0, _Property_816e6a58dfda4c3888b9195433a761b5_Out_0, _Saturate_aa8ebbf7445640edb04a6ff3dd8a57f0_Out_1, _Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3);
    float _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0 = Vector1_41f94b36521a4488883baba6e9cf4ce5;
    float _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2;
    Unity_Multiply_float(_Smoothstep_31480044a91d4a18b459a3da6510c307_Out_3, _Property_3a4077cd87444e29aa6313b6e5f8d051_Out_0, _Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2);
    float _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    Unity_OneMinus_float(_Multiply_d64a63e410b643d8aa6e676c4b3ea37e_Out_2, _OneMinus_d728dd67d10f470490b1884161da0235_Out_1);
    surface.BaseColor = (_Multiply_786efaa6dde14ffd9015da597c4c670f_Out_2.xyz);
    surface.Alpha = _OneMinus_d728dd67d10f470490b1884161da0235_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

    ENDHLSL
}
    }
        CustomEditor "ShaderGraph.PBRMasterGUI"
        FallBack "Hidden/Shader Graph/FallbackError"
}