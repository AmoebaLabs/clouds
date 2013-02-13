class window.AmoebaCD.Clouds
  constructor:(@fps) ->
    @world = $("#world").get(0)
    @textures = this._buildTextures()

    @clouds = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0
    @lastTime = 0
    @numClusters = 5
    this._setupRAF()
    this._setupEventListeners()

    this._animate()  # starts the requestAnimationFrame loop

  generate: () =>
    if @world.hasChildNodes()
      while @world.childNodes.length >= 1
        @world.removeChild(@world.firstChild)

    total = 0
    _.each(@textures, (texture, index) =>
      total += texture.weight  if texture.weight > 0
    )

    computedWeights = []
    accum = 0
    _.each(@textures, (texture, index) =>
      if texture.weight > 0
        w = texture.weight / total

        computedWeights.push
          src: texture.file
          min: accum
          max: accum + w

        accum += w
    )

    @clouds = []
    for i in [0...@numClusters]
      @clouds.push(new window.AmoebaCD.Cloud(@world, computedWeights, @fps))

  _updateWorld:() =>
    t = "translateZ( " + @translateZ + "px ) rotateX( " + @worldXAngle + "deg) rotateY( " + @worldYAngle + "deg)"
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

  _setupEventListeners: () =>
    orientationhandler = (e) ->
      if not e.gamma and not e.beta
        e.gamma = -(e.x * (180 / Math.PI))
        e.beta = -(e.y * (180 / Math.PI))
      x = e.gamma
      y = e.beta
      @worldXAngle = y
      @worldYAngle = x
      this._updateWorld()

    # window.addEventListener( 'deviceorientation', orientationhandler, false );
    # window.addEventListener( 'MozOrientation', orientationhandler, false );

    onContainerMouseWheel = (event) =>
      event = (if event then event else window.event)
      @translateZ = @translateZ - ((if event.detail then event.detail * -5 else event.wheelDelta / 8))
      this._updateWorld()

    window.addEventListener "mousewheel", onContainerMouseWheel
    window.addEventListener "DOMMouseScroll", onContainerMouseWheel

    window.addEventListener "mousemove", (e) =>
      # alternate calculation
      # @worldXAngle = -(.1 * ( e.clientY - .5 * window.innerHeight ))
      # @worldYAngle = .1 * ( e.clientX - .5 * window.innerWidth )

      @worldYAngle = -(.5 - (e.clientX / window.innerWidth)) * 180
      @worldXAngle = (.5 - (e.clientY / window.innerHeight)) * 180

      this._updateWorld()

    window.addEventListener "touchmove", (e) =>
      _.each(e.changedTouches, (touch, index) =>
        @worldYAngle = -(.5 - (touch.pageX / window.innerWidth)) * 180
        @worldXAngle = (.5 - (touch.pageY / window.innerHeight)) * 180
        this._updateWorld()
      )

      e.preventDefault()

  _setupRAF: () =>
    vendors = ["ms", "moz", "webkit", "o"]
    x = 0

    unless window.requestAnimationFrame
      _.each(vendors, (prefix, index) =>
        window.requestAnimationFrame = window[prefix + "RequestAnimationFrame"]
        window.cancelRequestAnimationFrame = window[prefix + "CancelRequestAnimationFrame"]

        # return breaks out of _.each
        return if window.requestAnimationFrame
      )

    unless window.requestAnimationFrame
      window.requestAnimationFrame = (callback, element) ->
        currTime = new Date().getTime()
        timeToCall = Math.max(0, 16 - (currTime - @lastTime))
        id = window.setTimeout(->
          callback currTime + timeToCall
        , timeToCall)
        @lastTime = currTime + timeToCall
        id

    unless window.cancelAnimationFrame
      window.cancelAnimationFrame = (id) ->
        clearTimeout id

  _buildTextures: () =>
    result = [
      name: "white cloud"
      file: "/images/cloud.png"
      opacity: 1
      weight: 1
    ,
      name: "dark cloud"
      file: "/images/darkCloud.png"
      opacity: 1
      weight: 0
    ,
      name: "smoke cloud"
      file: "/images/smoke.png"
      opacity: 1
      weight: 0
    ,
      name: "explosion"
      file: "/images/explosion.png"
      opacity: 1
      weight: 0
    ,
      name: "explosion 2"
      file: "/images/explosion2.png"
      opacity: 1
      weight: 0
    ,
      name: "box"
      file: "/images/box.png"
      opacity: 1
      weight: 0
    ]

    return result