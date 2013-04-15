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

Map = (I={}) ->
  Object.defaults I,
    x: App.width/2
    y: App.height/2
    height: App.height
    width: App.width
    size: 8

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
    materials = textures.map (texture) ->
      new THREE.MeshBasicMaterial
        wireframe: false
        map: texture
        # overdraw: true

    cubeData.each (plane, y) ->
      plane.each (row, z) ->
        row.each (c, x) ->
          if surfaceTextures = findTextures(c)
            geometry = new THREE.CubeGeometry(I.size, I.size, I.size, 1, 1, 1)

            cube = new THREE.Mesh(geometry, new THREE.MeshFaceMaterial(surfaceTextures))

            cube.position.y = I.size * (y - 4)
            cube.position.x = I.size * (x - 4)
            cube.position.z = I.size * (z - 4)

            engine.scene().add(cube)

  init()
