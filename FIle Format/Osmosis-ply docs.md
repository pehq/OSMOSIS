# OSMOSIS FILE FORMAT
This file format is heavily based on the [wavefront OBJ](https://wikipedia.org/wiki/Wavefront_.obj_file) file structure.

Anything following a hash character (#) is a comment  
```  
# This is a comment
```

## CFrames
`cf`represents a [Coordinate Frame](https://create.roblox.com/docs/reference/engine/datatypes/CFrame) value. A coordinate Frame Value composes of 3 positional values and 9 rotational values, the values being:  
x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22
```  
# This is what a empty Coordinate Frame
# would look like  
  
cf 0 0 0 1 0 0 0 1 0 0 0 1
# Which would be the same as
cf 0
```
CFrames do not support a set of scale values, only positional and rotational.

