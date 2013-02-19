class window.AmoebaCD.CloudWorld
  constructor:(@fps, @numClusters=5, @preset='current') ->
    @world = $("#world")
    @viewPort = $("#viewport")
    @clouds = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0

    @whiteOut = $('<div/>')
      .css(
        position: 'absolute'
        backgroundColor: '#fff'
        top:0
        left:0
        height: '100%'
        width: '100%'
        opacity: 0
      )

    @whiteOut.appendTo(@viewPort)

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
      @clouds.push(new AmoebaCD.Cloud(@world, AmoebaCD.textures.weightedTextures(@preset), @fps))

  worldState: () =>
    return [@worldXAngle, @worldYAngle, @translateZ]

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
          callback.call()

    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      transition = _.extend({}, css)

      if hideWhenDone
        hideTransition =
          display: 'none'
          complete: localCallback
      else
        # add a callback so we can count down to 0 and call the passed in callback
        transition.complete = localCallback

      cloud.animateCSS(transition, hideTransition)
    )

  applyCSSToLayers: (animate, css) =>
    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      cssCopy = _.extend({}, css)

      cloud.applyCSSToLayers(animate, cssCopy)
    )

  hyperspace: () =>
    t = "translateZ(#{@translateZ+2000}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.transition(
      transform: t
      duration: 2600
    )
    @whiteOut.transition(
      opacity: 1
      duration: 2600
    )

  reversehyperspace: () =>
    t = "translateZ(#{@translateZ+2000}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.css(
      transform: t
      duration: 2600
    )
    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.transition(
      transform: t
      duration: 2600
    )
    @whiteOut.transition(
      opacity: 0
      duration: 600
    )

  zoomWorld: () =>
    @translateZ = -4000
    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.css(
      transform: t
      opacity: 0.1
    )
    @translateZ = 2000

    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.transition(
      transform: t
      opacity: 1
      delay: 400
      duration: 2600
    )

  _animateLayer: () =>
    # call this first
    requestAnimationFrame(this._animate);

    if @automaticallyRotateWorld > 0
      this.updateWorld(@worldXAngle, @worldYAngle+0.15, @translateZ)

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

  slowlyRotateWorld: () =>
    @automaticallyRotateWorld = 2
