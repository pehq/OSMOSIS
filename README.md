`Operation for Stop Motion of Swinging interconnected Systems - Pieces of Legos Yodeling` can be shortened to OSMOSIS-PLY
--> Name is subject to change!

This is all based on Roblox's Mortor6D Object
This file format will be based on Wavefront.obj because that is what Roblox uses and is very simple!
That will mean this file format will be provided alongside .obj files (kinda like how materials are provided via .mtl)

Motor 6d has 4 different values it needs to satisfy:
Part0, Part1, C0, C1

Part0 and Part1 is the objects it's referring to
C0, C1 is the Coordinate Frame Value which represents the offset of the objects

CFrame: (https://create.roblox.com/docs/reference/engine/datatypes/CFrame)
• Describes a 3D position and orientation
• Position Value are 3 values, (X, Y, Z) representing the 3d space of the object's origin
• Rotational Values, stored in a 3x3 rotation matrix form