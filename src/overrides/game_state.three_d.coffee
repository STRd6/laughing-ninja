GameState.ThreeD = (I={}, self) ->
  {width, height} = App

  scene = new THREE.Scene()

  camera = new THREE.PerspectiveCamera(75, width / height, 1, 10000)

  camera.position.z = 100
  camera.position.y = 25
  camera.position.x = 0

  cameraTarget = new THREE.Vector3(0, 0, 0)

  self.on "draw", (canvas) ->
    canvas.render(scene, camera)

  self.on 'afterAdd', (obj) ->
    scene.add obj.mesh()

  self.bind "update", ->
    camera.lookAt(cameraTarget)

  pan: (delta) ->
    ["x", "y", "z"].each (d) ->
      camera.position[d] += delta[d]
      cameraTarget[d] += delta[d]

  scene: scene
