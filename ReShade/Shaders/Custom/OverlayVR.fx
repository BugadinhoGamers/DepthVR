NAMESPACE_ENTER(CFX)

#include CFX_SETTINGS_DEF

texture HudTex	< string source = "ReShade/Custom/Textures/vr_overlay1080.png"; > {Width = 1920; Height = 1080; Format = RGBA8;};
sampler	HudColor 	{ Texture = HudTex; };

float4 PS_Hud(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float4 hud = tex2D(HudColor, texcoord);
	return lerp(tex2D(RFX_backbufferColor, texcoord),hud,hud.a);
}

technique Hud_Tech <bool enabled = RFX_Start_Enabled; int toggle = RFX_ToggleKey; >
{
	pass HudPass
	{
		VertexShader = RFX_VS_PostProcess;
		PixelShader = PS_Hud;
	}
}

#include CFX_SETTINGS_UNDEF

NAMESPACE_LEAVE()