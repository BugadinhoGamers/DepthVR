# DepthVR

A tool for people that make DIY VR Headsets and all it does is convert your game image into a stereoscopic 3D image with apropiate distortions.

## Works with:

All Directx 8,9,10,11 and OpenGL games, but keep in mind that if the game doesn't have an accessible depth buffer it will only duplicate the image without 3D effects.

## How to use:

### For 32-Bit games:

1) Put all files to your game's executable folder.
2) Rename ReShade32.dll to:

- d3d8.dll for Directx 8
- d3d8.dll for Directx 9
- d3d10.dll for Directx 10
- d3d11.dll for Directx 11
- opengl32.dll for OpenGL

3) Press Scroll Lock to enable the effect.
4) Enjoy the game!

### For 64-Bit games:

1) Put all files to your game's executable folder.
2) Rename ReShade64.dll to:

- d3d8.dll for Directx 8
- d3d8.dll for Directx 9
- d3d10.dll for Directx 10
- d3d11.dll for Directx 11
- opengl32.dll for OpenGL

3) Press Scroll Lock to enable the effect.
4) Enjoy the game!


## Made with:

- Reshade 2
- Depth3D Original (https://github.com/BlueSkyDefender/Depth3D)
