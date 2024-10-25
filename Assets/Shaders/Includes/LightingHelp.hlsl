void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten) {
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(0.5, 0.5, 0));
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
    #if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToClip(WorldPos);
        float4 shadowCoord = ComputeScreenPos(clipPos);
    #else
        float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}

void ChooseColor_float(float3 Highlight, float3 Shadow, float Diffuse, float Threshold, out float3 OUT)
{
    if (Diffuse < Threshold)
    {
        OUT = Shadow;
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseColorSmooth_float(float3 Highlight, float3 Shadow, float Diffuse, float Threshold, float Smoothness, out float3 OUT)
{
    float start = Threshold * (1. - Smoothness);
    float end = Threshold * (1. + Smoothness);
    if (Diffuse < start)
    { 
        OUT = Shadow;
    }
    else if (Diffuse < end)
    {
        OUT = lerp(Shadow, Highlight, (Diffuse - start) / (end - start));
    }
    else
    {
        OUT = Highlight;
    }
}