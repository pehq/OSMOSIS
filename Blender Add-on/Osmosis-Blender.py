bl_info = {
    "name": "My Test Add-on",
    "blender": (4, 0, 0),
    "category": "Object",
}

import bpy, bpy_extras, json, mathutils
from mathutils import Vector, Matrix

transform_to_blender = bpy_extras.io_utils.axis_conversion(
    from_forward="Z", from_up="Y", to_forward="-Y", to_up="Z"
).to_4x4()  # transformation matrix from Y-up to Z-up
identity_cf = [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]  # identity CF components matrix

# Open and read the JSON file
with open("C:\DRIVE\Documents\Operation for Stop Motion of Swinging Interconnected Systems - Pieces of Legos Yodeling\FIle Format\Basic_Animation.OSMPLY.json", 'r') as file:
    data = json.load(file)

# Print the data
print(data)

# utilities
# y-up cf -> y-up mat
def cf_to_mat(cf):
    mat = Matrix.Translation((cf[0], cf[1], cf[2]))
    mat[0][0:3] = (cf[3], cf[4], cf[5])
    mat[1][0:3] = (cf[6], cf[7], cf[8])
    mat[2][0:3] = (cf[9], cf[10], cf[11])
    return mat

# y-up mat -> y-up cf
def mat_to_cf(mat):
    r_mat = [
        mat[0][3],
        mat[1][3],
        mat[2][3],
        mat[0][0],
        mat[0][1],
        mat[0][2],
        mat[1][0],
        mat[1][1],
        mat[1][2],
        mat[2][0],
        mat[2][1],
        mat[2][2],
    ]
    return r_mat

Motor6Ds = data["Header"]["Motor6Ds"]
Motor6DsLocMat = {}
for i in Motor6Ds:
    Motor6DsLocMat[i] = {
        "C0": cf_to_mat(Motor6Ds[i]["C0"]),
        "C1": cf_to_mat(Motor6Ds[i]["C1"])    
    }
    
for i in Motor6DsLocMat:
    print(i ,Motor6DsLocMat[i])

Motor6DsCFBack = {}
for i in Motor6DsLocMat:
    Motor6DsCFBack[i] = {
        "C0": mat_to_cf(Motor6DsLocMat[i]["C0"]),
        "C1": mat_to_cf(Motor6DsLocMa[i]["C1"])    
    }

for i in Motor6DsCFBack:
    print(i ,Motor6DsCFBack[i])

Motor6Ds = data
# TODO: Function for getting position of Motor6D Joint
    # Note that:
    # C0 is the offset of Part0 from Part1
    # C1 is the negative offset of Part0 from Part1
    # C0 is added to Part0’s CFrame, C1 is subtracted from Part0’s CFrame ???

# Use this to import the obj: https://docs.blender.org/api/current/bpy.ops.wm.html#bpy.ops.wm.obj_import
    # https://stackoverflow.com/questions/77807142/attributeerror-calling-operator-bpy-ops-import-scene-obj-error-could-not-be
    
    # It will be imported through a custom easy importer but use the original obj loader as a base
    
# Create Armature and bones
    # To create an Armature, use this function: bpy.ops.object.armature_add()
    # https://docs.blender.org/api/current/bpy.ops.object.html#bpy.ops.object.armature_add
    
    # To edit the bones, set the armature to edit mode and reference the bone
    # https://docs.blender.org/api/current/info_gotcha.html#edit-bones
    # new_bone.head = mathutils.Vector((0, 0, 0))  # Start position
    # new_bone.tail = mathutils.Vector((0, 0, 2))  # End position (2 units above the head)

# Create and load Keyframes...

def register():
    print("registered")
 
def unregister():
    print("unregistered")