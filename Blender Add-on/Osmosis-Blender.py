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
with open("C:\DRIVE\Documents\Operation for Stop Motion of Swinging Interconnected Systems - Pieces of Legos Yodeling\FIle Format\output.json", 'r') as file:
    Json_data = json.load(file)

# Print the data
print(Json_data)

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

y_to_z = Matrix(((1, 0,  0, 0),
                 (0, 0, -1, 0),
                 (0, 1,  0, 0),
                 (0, 0,  0, 1)))

def RotateMat180(Mat):
    # Create a 180° rotation matrix around the Y-axis
    rotation_y_180 = Matrix.Rotation(math.radians(180), 4, 'Y')
    
    # Apply the rotation by multiplying the matrices
    rotated_matrix = rotation_y_180 @ original_matrix

    return rotated_matrix

Join_Pos = {}
Motor6Ds = Json_data["Header"]["Motor6Ds"]
Part0Mats = {}
for i in Motor6Ds:
    Part0Mats[i] = cf_to_mat(Json_data["Header"]["Parts"][Motor6Ds[i]["Part0"]]["CFrame"]) @ cf_to_mat(Motor6Ds[i]["C0"])

print(Part0Mats)

# Create an armature
armature_data = bpy.data.armatures.new("MyArmature")
armature_object = bpy.data.objects.new("MyArmatureObject", armature_data)
bpy.context.scene.collection.objects.link(armature_object)

# Set the armature as the active object and enter Edit Mode
bpy.context.view_layer.objects.active = armature_object
bpy.ops.object.mode_set(mode='EDIT')

# Iterate through the dictionary
for joint_name, matrix in Part0Mats.items():
    # Convert the Y-up matrix to Z-up
    z_up_matrix = y_to_z @ matrix

    # Extract the position and direction from the matrix
    head_position = z_up_matrix.translation  # Bone head is at the matrix translation
    direction = z_up_matrix @ Vector((0, 0, 1)) - head_position  # Local Z-axis

    # Create a new bone
    bone = armature_data.edit_bones.new(joint_name)
    bone.head = head_position
    bone.tail = head_position + direction.normalized()  # Extend outward by 1 unit

# Exit Edit Mode
bpy.ops.object.mode_set(mode='OBJECT')


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