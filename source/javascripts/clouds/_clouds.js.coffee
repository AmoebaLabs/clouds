class window.AmoebaCD.Clouds
  constructor:(@world, @fps, @numClusters=5, animate=true, @preset='current') ->
    @clouds = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0

    if animate
      this._animate()  # starts the requestAnimationFrame loop

  destructor: () =>
    _.each(@clouds, (cloud, index) =>
      cloud.destructor()
    )

  generate: (clearWorld=true) =>
    if clearWorld
      @world.empty()

    @clouds = []
    for i in [0...@numClusters]
      @clouds.push(new window.AmoebaCD.Cloud(@world, AmoebaCD.textures.weightedTextures(@preset), @fps))

  updateWorld:(worldXAngle, worldYAngle, translateZ) =>
    @worldXAngle = worldXAngle
    @worldYAngle = worldYAngle
    @translateZ = translateZ

    @translateWorld = true

  applyCSS: (animate, css) =>
    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      cssCopy = _.extend({}, css)

      cloud.applyCSS(animate, cssCopy)
    )

  applyCSSToLayers: (animate, css) =>
    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      cssCopy = _.extend({}, css)

      cloud.applyCSSToLayers(animate, cssCopy)
    )

  _animateLayer: () =>
    # call this first
    requestAnimationFrame(this._animate);

    if @translateWorld
      @translateWorld = false
      t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
      @world.css(transform: t)

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

