class window.AmoebaCD.Clouds
  constructor:(@world, @fps) ->
    @clouds = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0
    @numClusters = 5

    this._animate()  # starts the requestAnimationFrame loop

  generate: () =>
    this._clearWorld()

    @clouds = []
    for i in [0...@numClusters]
      @clouds.push(new window.AmoebaCD.Cloud(@world, AmoebaCD.textures.weightedTextures(), @fps))

  updateWorld:(worldXAngle, worldYAngle, translateZ) =>
    @worldXAngle = worldXAngle
    @worldYAngle = worldYAngle
    @translateZ = translateZ

    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    $(@world).css(transform: t)

  _animateLayer: () =>
    # call this first
    requestAnimationFrame(this._animate);

    _.each(@clouds, (cloud, index) =>
      # could add this later
      # cloud.style.webkitFilter = 'blur(5px)';

      cloud.transformLayers(@worldXAngle, @worldYAngle)
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

