/**
 * Depth Map Based 3d post-process shader v1.5.4
 *
 * --------------------------
 * This work is licensed under a Creative Commons Attribution 3.0 Unported License.
 * So you are free to share, modify and adapt it for your needs, and even use it for commercial use.
 * I would also love to hear about a project you are using it.
 *
 * Have fun,
 * Jose Negrete 
 * 
 * --------------------------
 *
 * Original work was based on Shader Based on forum user 04348 and be located here http://reshade.me/forum/shader-presentation/1594-3d-anaglyph-red-cyan-shader-wip#15236
 *
 * 
 */
 
#include EFFECT_CONFIG(BSD)

#if USE_Depth3D

#pragma message "Depth3D by BSD\n"
namespace BSD
{

#define pix  	float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)

texture texCL  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCR  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCC  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 

sampler SamplerCL
	{
		Texture = texCL;
	};
	
sampler SamplerCR
	{
		Texture = texCR;
	};
	
		sampler2D SamplerCC
	{
		Texture = texCC;
		MinFilter = LINEAR;
		MagFilter = LINEAR;
		MipFilter = LINEAR;
		AddressU = Clamp;
		AddressV = Clamp;
	};

	
//depth information
	float SbSdepth (float2 texcoord) 
	
	{
	
	 float4 color = tex2D(SamplerCC, texcoord);
     		#if DepthFix == 0
			texcoord.y = texcoord.y;
			#endif
			#if DepthFix == 1
			texcoord.y = 1 - texcoord.y;
			#endif
	

	#if EyeSwap == 0 & Pop == 1
		float4 depthL = tex2D(ReShade::LinearizedDepth, float2(texcoord.x*2,texcoord.y));
	#endif
	
	#if EyeSwap == 1 & Pop == 1
		float4 depthL = tex2D(ReShade::LinearizedDepth, float2(texcoord.x*2-1,texcoord.y));
	#endif
	
	#if Pop == 0 
	float4 depthL = 0;
	#endif	
    
     #if AltDepthMap >= 0 & Pop == 1
    depthL = (pow(abs(depthL),+0.025));
	#endif
 
    float4 DL = depthL;

	#if EyeSwap == 0
	float4 depthR = tex2D(ReShade::LinearizedDepth, float2(texcoord.x*2-1,texcoord.y));
	#endif
	
	#if EyeSwap == 1
	float4 depthR = tex2D(ReShade::LinearizedDepth, float2(texcoord.x*2,texcoord.y));
	#endif
	
	//Among The Sleep
    #if AltDepthMap == 0
    depthR = (pow(abs(depthR),0.75));
    //depthR = (-1.0+(pow(abs(depthR),0.25))*2)+0.15;
	#endif
	
	//Naruto Shippuden UNS3 Full Blurst
	#if AltDepthMap == 1
	depthR = (pow(abs(depthR*depthR),0.15)-0.25);
    #endif
	
	//Quake 4
	#if AltDepthMap == 2
	float LinLog = 0.125;
	depthR = ((LinLog) / (LinLog - depthR * (-0.05)))-0.10;
    #endif
    
    //Amnesia Games
    #if AltDepthMap == 3
	//depthR = 1 - ((125 * 2) / ( -(500 * 2) * (depthR*depthR) + (350 * 2) ))+0.25;
    #endif
    
    //Fallout 4
    #if AltDepthMap == 4
	depthR = 1 - ((pow(abs(depthR),0.30)+0.75)/5);
	#endif
	
	//Souls Games | The Evil With In | Lords of The Fallen | Dragons Dogma: Dark Arisen | DragonBall Xenoverse | Deadly Premonition: The Directors's Cut
	 #if AltDepthMap == 5
	depthR = (pow(abs(depthR),0.25)-0.15);
	#endif
	
	//Sleeping Dogs: DE
	#if AltDepthMap == 6
	float LinLog = 0.025;
	depthR = 1 - (LinLog) / (LinLog - depthR * (LinLog - 1));
	#endif
	
	//Assassin Creed Unity
	 #if AltDepthMap == 7
	float LinLog = 0.0000025;
	depthR = (LinLog) / (LinLog - depthR * (LinLog - 1));
	#endif
	
	//GTAV
	 #if AltDepthMap == 8
	float LinLog = 0.00005;
	depthR = (LinLog) / (LinLog - depthR * (LinLog - 1));
	#endif
	
	//Withcer 3
	 #if AltDepthMap == 9
	float LinLog = 0.00005;
	depthR = (LinLog) / (LinLog - depthR * (LinLog - 25))-0.375;
	#endif
	
	//DreamFall Chapters | BoarderLands 2
	 #if AltDepthMap == 10
	depthR = ((pow(abs(depthR),0.30)+0.75)/2);
	#endif
	
	//Magicka 2
	#if AltDepthMap == 11
	float LinLog = 0.050;
	depthR = 1 - (LinLog) / (LinLog - depthR * depthR * (LinLog -  15));
	#endif
	
	//Condemned: Criminal Origins
	#if AltDepthMap == 12
	depthR = 1 - (pow(abs(depthR*depthR),1)+0.15)-0.50;
	#endif
	
	//Wolfenstine The New Order
	#if AltDepthMap == 13
	depthR = ((pow(abs(depthR/1.875),0.30)+0.75)/2);
	#endif
	
	//Metro Last Light Redux
	#if AltDepthMap == 14
	float LinLog = 0.050;
	depthR = (LinLog) / (LinLog+0.025 - depthR * 2 * (LinLog - 1));
	#endif
	
	//Metro 2033 Redux
	#if AltDepthMap == 15
	float LinLog = 0.050;
	depthR = 1 -(LinLog) / (LinLog+0.025 - depthR * 2 * (LinLog - 1));
	#endif
	
	//Middle-earth: Shadow of Mordor
	#if AltDepthMap == 16
	depthR = 1 - ((pow(abs(depthR),0.25))*9)-0.25;
	#endif
	
    float4 DR = 1 - depthR;

     #if EyeSwap == 0
    if (texcoord.x < 0.5f) color.r = DL.r;
    else if(texcoord.x > 0.5f) color.r = DR.r;
	 #endif
	 
	 #if EyeSwap == 1
    if (texcoord.x < 0.5f) color.r = DR.r;
    else if(texcoord.x > 0.5f) color.r = DL.r;
	 #endif	 

	return color.r;
		
	}


	void  PS_calcLR(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float3 color : SV_Target)
	{
			
			color.rgb = texcoord.x-Seperation*pix.x*SbSdepth(float2(texcoord.x-Seperation*pix.x,texcoord.y));
	
	}
	

	/////////////////////////////////////////GOOD
	#if EyeSwap == 1
	void PS_renderR(in float4 position : SV_Position, in float2 texcoord: TEXCOORD0, out float3 color : SV_Target)
		{	
			color.rgb = tex2D(ReShade::BackBuffer, float2(texcoord.x*2-1, texcoord.y)).rgb;
			#if Pop == 0
			color.rgb = tex2D(ReShade::BackBuffer, float2((texcoord.x*2-1), texcoord.y)).rgb;
			#endif
		
		for (int i = 0; i <= Seperation; i++) 
		{
			if (tex2D(SamplerCC, float2((texcoord.x > 0.5)-i*pix.x,texcoord.y)).r >= texcoord.x-pix.x && tex2D(SamplerCC, float2(texcoord.x+i*pix.x,texcoord.y)).r <= texcoord.x+pix.x)
		{
			
			#if Pop == 1	
			color.rgb = tex2D(ReShade::BackBuffer, float2(texcoord.x*2-1+i*pix.x, texcoord.y)).rgb;
			#endif

		}
	}		
}
	#endif

	#if EyeSwap == 1
	void PS_renderL(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float3 color : SV_Target)
	{	
				for (int j = 0; j <= Seperation; j++) 
	{
			  if (tex2D(SamplerCC, float2((texcoord.x < 0.5)+j*pix.x,texcoord.y)).r >= texcoord.x-pix.x && tex2D(SamplerCC, float2(texcoord.x+j*pix.x,texcoord.y)).r <= texcoord.x+pix.x) {
				
			color.rgb = tex2D(ReShade::BackBuffer, float2((texcoord.x*2)+j*pix.x, texcoord.y)).rgb;
		
		}
	}		
}
	#endif

/////////////////////////////////////////GOOD
	
		#if EyeSwap == 0
	void PS_renderR(in float4 position : SV_Position, in float2 texcoord: TEXCOORD0, out float3 color : SV_Target)
	{	
		
		color.rgb = tex2D(ReShade::BackBuffer, float2(texcoord.x*2-1, texcoord.y)).rgb;
		
		for (int j = 0; j <= Seperation; j++) 
	{
			if (tex2D(SamplerCC, float2((texcoord.x > 0.5)-j*pix.x,texcoord.y)).r >= texcoord.x-pix.x && tex2D(SamplerCC, float2(texcoord.x+j*pix.x,texcoord.y)).r <= texcoord.x+pix.x) {
				
			color.rgb = tex2D(ReShade::BackBuffer, float2((texcoord.x*2-1)+j*pix.x, texcoord.y)).rgb;

		}
	}
}
	#endif
			
	#if EyeSwap == 0
	void PS_renderL(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float3 color : SV_Target)
		{	
		
			#if Pop == 0
			color.rgb = tex2D(ReShade::BackBuffer, float2((texcoord.x*2), texcoord.y)).rgb;
			#endif
		
				for (int i = 0; i <= Seperation; i++) 
		{
			if (tex2D(SamplerCC, float2(texcoord.x*2+i*pix.x,texcoord.y)).r >= texcoord.x-pix.x && tex2D(SamplerCC, float2(texcoord.x+i*pix.x,texcoord.y)).r <= texcoord.x-pix.x)
		{
			
			#if Pop == 1	
			color.rgb = tex2D(ReShade::BackBuffer, float2(texcoord.x*2+i*pix.x, texcoord.y)).rgb;
			#endif
			
		}		
	}
}
	#endif









void PS0(float4 pos : SV_Position, float2 texcoord : TEXCOORD0, out float3 color : SV_Target)
{
	

	
	float4 l = tex2D(SamplerCL, texcoord);
	float4 r = tex2D(SamplerCR, texcoord);

				if(texcoord.x < 0.5) color.rgb = l.rgb;
				
				else if(texcoord.x > 0.5 ) color.rgb = r.rgb;
				
				

}

float4 PS(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_Target
{
    
    float4 color = tex2D(SamplerCC, texcoord);
       	
     		#if DepthFix == 0
			texcoord.y = texcoord.y; 
			#endif
			#if DepthFix == 1
			texcoord.y = 1 - texcoord.y;
			#endif
    
	float4 depthM = tex2D(ReShade::LinearizedDepth, float2(texcoord.x,texcoord.y));
		
		//Among The Sleep
		#if AltDepthMap == 0
		depthM = 1 - (-1.0+(pow(abs(depthM),0.25))*2)+0.15;
		#endif
		
		//Naruto Shippuden UNS3 Full Blurst
		#if AltDepthMap == 1
		depthM = 1 - (pow(abs(depthM*depthM),0.15)-0.25);
		#endif
		
		//Quake 4
		#if AltDepthMap == 2
		float LinLog = 0.125;
		depthM = ((LinLog) / (LinLog - depthM * (-0.05)))-0.10;
		#endif
			
		//Amnesia Games
		#if AltDepthMap == 3
		depthM =  1 - (-1+(pow(abs(depthM),0.25))*2);
		#endif
		
		//Fallout 4
		#if AltDepthMap == 4
		depthM = 1 - ((pow(abs(depthM),0.30)+0.75)/5);
		#endif

		//Souls Games | The Evil With In | Lords of The Fallen | Dragons Dogma: Dark Arisen | DragonBall Xenoverse | Deadly Premonition: The Directors's Cut
		 #if AltDepthMap == 5
		depthM = 1 - (pow(abs(depthM),0.25)-0.15);
		#endif
		
		//Sleeping Dogs: DE
		#if AltDepthMap == 6
		float LinLog = 0.025;
		depthM = (LinLog) / (LinLog - depthM * (LinLog - 1));
		#endif
		
		//Assassin Creed Unity
		#if AltDepthMap == 7
		float LinLog = 0.0000025;
		depthM = 1 - (LinLog) / (LinLog - depthM * (LinLog - 1));
		#endif
		
		//GTAV
		#if AltDepthMap == 8
		float LinLog = 0.00005;
		depthM = 1 - (LinLog) / (LinLog - depthM * (LinLog - 1));
		#endif
		
		//Witcher 3
		#if AltDepthMap == 9
		float LinLog = 0.000005;
		depthM = 1 - (LinLog) / (LinLog - depthM *  (LinLog - 25))-0.375;
		#endif
		
		//DreamFall Chapters | BoarderLands 2
		#if AltDepthMap == 10
		depthM = 1 - ((pow(abs(depthM),0.30)+0.75)/2);
		#endif
		
		//Magica 2
		#if AltDepthMap == 11
		float LinLog = 0.050;
		depthM = (LinLog) / (LinLog - depthM * depthM * (LinLog -  15));
		#endif
		
		//Condemned: Criminal Origins
		#if AltDepthMap == 12
		depthM = 1 - (pow(abs(depthM*depthM),1)+0.15)-0.50;
		#endif
		
		//Wolfenstine The New Order
		#if AltDepthMap == 13
		depthM = 1 - ((pow(abs(depthM/1.875),0.30)+0.75)/2);
		#endif
		
		//Metro Last Light
		#if AltDepthMap == 14
		float LinLog = 0.050;
		depthM = 1 - (LinLog) / (LinLog+0.025 - depthM * 2 * (LinLog - 1));
		#endif
		
		//Metro 2033
		#if AltDepthMap == 15
		float LinLog = 0.050;
		depthM = (LinLog) / (LinLog+0.025 - depthM * 2 * (LinLog - 1));
		#endif
		
		//Middle-earth: Shadow of Mordor
		#if AltDepthMap == 16
		depthM = ((pow(abs(depthM),0.25))*9)-0.25;
		#endif
		
	float4 DM = 1 - depthM;
	
    if (DepthMap == 1)
    {
	color.rgb = DM.rrr;
    }
    return color;
    }

technique depth_Tech < enabled = RESHADE_START_ENABLED; int toggle = Depth3D_ToggleKey;>
	{
		#if (DepthMap == 0)
				pass
		{
			VertexShader = ReShade::VS_PostProcess;
			PixelShader = PS_calcLR;
			RenderTarget = texCC;
		}


				pass
		{
			VertexShader = ReShade::VS_PostProcess;
			PixelShader = PS_renderL;
			RenderTarget = texCL;
		}
		
				pass
		{
			VertexShader = ReShade::VS_PostProcess;
			PixelShader = PS_renderR;
			RenderTarget = texCR;
		}
		
		pass
		{
			VertexShader = ReShade::VS_PostProcess;
			PixelShader = PS0;
		}
		#endif		
		#if (DepthMap == 1)
		pass
		{
			VertexShader = ReShade::VS_PostProcess;
			PixelShader = PS;
		}
		#endif	
	}
}
	
#endif

#include EFFECT_CONFIG_UNDEF(D3D)
