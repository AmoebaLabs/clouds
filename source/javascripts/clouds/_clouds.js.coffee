class window.AmoebaCD.Clouds
  constructor:(@world, @fps, @numClusters=5) ->
    @clouds = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0

    this._animate()  # starts the requestAnimationFrame loop

  generate: (clearWorld=true) =>
    if clearWorld
      this._clearWorld()

    @clouds = []
    for i in [0...@numClusters]
      @clouds.push(new window.AmoebaCD.Cloud(@world, AmoebaCD.textures.weightedTextures(), @fps))

  updateWorld:(worldXAngle, worldYAngle, translateZ) =>
    @worldXAngle = worldXAngle
    @worldYAngle = worldYAngle
    @translateZ = translateZ

    @translateWorld = true

  _animateLayer: () =>
    # call this first
    requestAnimationFrame(this._animate);

    if @translateWorld
      @translateWorld = false
      t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
      $(@world).css(transform: t)

    _.each(@clouds, (cloud, index) =>
      # could add this later
      # cloud.style.webkitFilter = 'blur(5px)';
      cloud.transformLayers(@worldXAngle, @worldYAngle)
    )

  fallFromSky: () =>
    _.each(@clouds, (cloud, index) =>
      # could add this later
      # cloud.style.webkitFilter = 'blur(5px)';
      cloud.fallFromSky()
    )

  # called by requestAnimationFrame to set the next state of animation
  _animate: () =>
    if @fps >= 60
      this._animateLayer()
    else
      setTimeout(() =>
        this._animateLayer()
      ,1000 / @fps)

  _clearWorld: () =>
    if @world.hasChildNodes()
      while @world.childNodes.length >= 1
        @world.removeChild(@world.firstChild)

