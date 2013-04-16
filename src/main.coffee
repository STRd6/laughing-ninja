GameObject.defaultModules = GameObject.defaultModules.without(['Drawable']).concat(['GameObject.ThreeD'])

stats = xStats
  width: 200
  height: 130

$(stats.element).css
  position: "absolute"
  right: 0
  top: 0
.appendTo("body")

{width, height} = App

# TODO: Move into engine module?
renderer = new THREE.WebGLRenderer
  antialias: true
  canvas: $('canvas').get(0)
renderer.setSize(width, height)

Engine.defaultModules.push "Gamepads"

# Create the engine
window.engine = Engine
  canvas: renderer
  clear: false
  backgroundColor: null

engine.start()

addParticle = (position) ->
  scene = engine.scene()

  material = new THREE.ParticleBasicMaterial
    size: 5
    depthFalse: false
    #transparent: true

  geometry = new THREE.Geometry()
  geometry.vertices.push(position)

  mesh = new THREE.ParticleSystem(geometry, material)

  scene.add( mesh )

engine.on "update", (dt) ->
  cameraSpeed = 100

  p = engine
    .controller(0)
    .position(1)
    .scale(cameraSpeed * dt)

  engine.pan
    x: p.x
    y: 0
    z: p.y

  scene = engine.scene()

  # Picking Objects via mouse
  # TODO Move into 3d cameras module
  if mousePressed.left
    vector = new THREE.Vector3(
      ( mousePosition.x / App.width ) * 2 - 1,
      - ( mousePosition.y / App.height ) * 2 + 1,
      0
    )

    projector = projector = new THREE.Projector()
    camera = engine.camera()
    objects = scene.children

    raycaster = projector.pickingRay( vector, camera )

    intersects = raycaster.intersectObjects( objects )

    if intersects.length > 0
      addParticle intersects.first().point
      # intersects[ 0 ].object.material.color.setHex( Math.random() * 0xffffff )

engine.camera = ->
  engine.I.currentState.camera

engine.scene = ->
  engine.I.currentState.scene

engine.pan = (delta) ->
  engine.I.currentState.pan delta

Map()
