GameObject.ThreeD = (I={}, self) ->
  Object.defaults I,
    size: 10

  self.on 'update', ->
    I.mesh.geometry.vertices[0].set(I.x, I.y, I.z)
    I.mesh.geometry.verticesNeedUpdate = true

  mesh: ->
    texture = THREE.ImageUtils.loadTexture(ResourceLoader.urlFor("images", I.spriteName))
    
    material = new THREE.ParticleBasicMaterial
      size: I.size
      depthFalse: false
      transparent: true 
      map: texture
        
    I.geometry = new THREE.Geometry()
    
    I.geometry.vertices.push(new THREE.Vector3(I.x, I.y, I.z))

    I.mesh = new THREE.ParticleSystem(I.geometry, material) 

    return I.mesh
    