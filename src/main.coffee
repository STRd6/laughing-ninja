stats = xStats
  width: 200
  height: 130
$(stats.element).css
  position: "absolute"
  right: 0
  top: 0
.appendTo("body")

[camera, scene, renderer, geometry, material] = []

size = 8

findTextures = (key) ->
  return if key is '-'

  [].concat(textureLookup[key]).map (textureIndex) ->
    materials[textureIndex]
  .wrap(0, 6)

# left, right, top, bottom, front, back
textureLookup =
  D: 2
  G: [77, 77, 78, 2, 77, 77]
  P: [118, 118, 102, 118, 119, 118]
  W: [20, 20, 21, 21, 20, 20]

cubeData = ["""
G G D D D D G G
G G D D D D G G
D D D D D D D D
D D D D D D D D
D D D D D D D D
D D D D D D D D
G G D D D D G G
G G D D D D G G
""", """
- - - - - - - P
- - P - - - - -
- - - W - - P -
- - - - - P - -
- P - - - - - -
- - - - P - - -
- - - P - - - -
P - - - - - - -
""", """
- - - - - - - -
- - - - - - - -
- - - W - - - -
- - - - - - - -
- - - - - - - -
- - - - - - - -
- - - - - - - -
- - - - - - - -
"""].map (plane) ->
  plane.split("\n").map (row) ->
    row.split(" ")

$("canvas").remove()

testImageUrl = ResourceLoader.urlFor("images", "terrain")
textures = []
materials = []

n = 16
n.times (y) ->
  n.times (x) ->
    texture = THREE.ImageUtils.loadTexture testImageUrl

    texture.offset.x = (1/n) * x
    texture.offset.y = (1/n) * ((n - 1) - y)

    texture.repeat.x = 1/n
    texture.repeat.y = 1/n

    textures.push texture

init = ->
  {width, height} = App

  camera = new THREE.PerspectiveCamera( 75, width / height, 1, 10000 )
  camera.position.z = 100
  camera.position.y = 25
  camera.position.x = 0

  scene = new THREE.Scene()

  materials = textures.map (texture) ->
    new THREE.MeshBasicMaterial
      wireframe: false
      map: texture
      overdraw: true

  cubeData.each (plane, y) ->
    plane.each (row, z) ->
      row.each (c, x) ->
        if surfaceTextures = findTextures(c)
          geometry = new THREE.CubeGeometry(size, size, size, 1, 1, 1)
          cube = new THREE.Mesh(geometry, new THREE.MeshFaceMaterial(surfaceTextures))

          cube.position.y = size * (y - 4)
          cube.position.x = size * (x - 4)
          cube.position.z = size * (z - 4)

          scene.add( cube )

  renderer = new THREE.WebGLRenderer
    antialias: true
  renderer.setSize( width, height )

  document.body.appendChild( renderer.domElement )

animate = ->
  # note: three.js includes requestAnimationFrame shim
  requestAnimationFrame( animate )

  renderer.render( scene, camera )

init()
animate()

engine = Engine()

cameraTarget = new THREE.Vector3(0, 0, 0)

engine.bind "update", ->
  camera.position.x += 1 if keydown.right
  camera.position.x -= 1 if keydown.left
  camera.position.y += 1 if keydown.up
  camera.position.y -= 1 if keydown.down

  camera.lookAt(cameraTarget)

engine.start()
