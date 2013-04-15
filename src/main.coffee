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

engine.scene = ->
  engine.I.currentState.scene

engine.pan = (delta) ->
  engine.I.currentState.pan delta

Map()
