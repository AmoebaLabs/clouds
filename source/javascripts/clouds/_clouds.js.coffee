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

  applyCSS: (css) =>
    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      cssCopy = _.extend({}, css)

      cloud.applyCSS(cssCopy)
    )

  animateCSS: (callback, css, hideWhenDone=false) =>
    # add a callback so we can count down to 0 and call the passed in callback
    numCallbacks = @clouds.length
    localCallback = () =>
      if --numCallbacks == 0
        if typeof callback == 'function'
          callback.apply(self)

    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      cssCopy = _.extend({}, css)

      # add a callback so we can count down to 0 and call the passed in callback
      cssCopy.complete = localCallback

      cloud.animateCSS(callback, cssCopy, hideWhenDone)
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

