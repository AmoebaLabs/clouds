class window.AmoebaCD.Clouds
  constructor:() ->
    @world = $("#world").get(0)
    @viewport = $("#viewport").get(0)
    @textures = this._buildTextures()

    @layers = []
    @objects = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0
    @lastTime = 0
    @fps = 24    # cpu is high at >= 60
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

    @objects = []
    for i in [0..4]
      @objects.push this._createCloud(computedWeights)

  _createCloud: (computedWeights) =>
    div = document.createElement("div")
    div.className = "cloudBase"
    x = 256 - (Math.random() * 512)
    y = 256 - (Math.random() * 512)
    z = 256 - (Math.random() * 512)
    t = "translateX( " + x + "px ) translateY( " + y + "px ) translateZ( " + z + "px )"
    $(div).css(transform: t)

    @world.appendChild div

    cnt = 5 + Math.round(Math.random() * 10)
    for j in [0...cnt]
      cloud = document.createElement("img")
      cloud.style.opacity = 0
      r = Math.random()
      src = "troll.png"     # SNG need this image, or fix code

      _.each(computedWeights, (weight, index) =>
        if r >= weight.min and r <= weight.max
          ((img) ->
            img.addEventListener "load", ->
              img.style.opacity = .8

          ) cloud
          src = weight.src
      )

      cloud.setAttribute "src", src
      cloud.className = "cloudLayer"

      x = 256 - (Math.random() * 512)
      y = 256 - (Math.random() * 512)
      z = 100 - (Math.random() * 200)
      a = Math.random() * 360
      s = .25 + Math.random()
      x *= .2
      y *= .2
      cloud.data =
        x: x
        y: y
        z: z
        a: a
        s: s
        speed: ((60/Math.min(@fps, 60)) * .1) * Math.random()

      t = "translateX( " + x + "px ) translateY( " + y + "px ) translateZ( " + z + "px ) rotateZ( " + a + "deg ) scale( " + s + " )"
      $(cloud).css(transform: t)

      div.appendChild cloud
      @layers.push cloud

    return div

  _updateWorld:() =>
    t = "translateZ( " + @translateZ + "px ) rotateX( " + @worldXAngle + "deg) rotateY( " + @worldYAngle + "deg)"
    $(@world).css(transform: t)

  _animateLayer: () =>
    # call this first
    requestAnimationFrame(this._animate);

    _.each(@layers, (layer, index) =>
      # could add this later
      # layer.style.webkitFilter = 'blur(5px)';

      layer.data.a += layer.data.speed
      t = "translateX( " + layer.data.x + "px ) translateY( " + layer.data.y + "px ) translateZ( " + layer.data.z + "px ) rotateY( " + (-@worldYAngle) + "deg ) rotateX( " + (-@worldXAngle) + "deg ) rotateZ( " + layer.data.a + "deg ) scale( " + layer.data.s + ")"
      $(layer).css(transform: t)
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