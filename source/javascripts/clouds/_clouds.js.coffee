class window.AmoebaCD.Clouds
  constructor:() ->
    @world = $("#world").get(0)
    @viewport = $("#viewport").get(0)
    @textures = this._buildTextures()

    @layers = []
    @objects = []
    @computedWeights = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0
    @lastTime = 0
    @fps = 24    # cpu is high at >= 60
    this._setupRAF()
    this._setupEventListeners()

    this._addClickHandlersToATags()
    this._animate()  # starts the requestAnimationFrame loop

  generate: () =>
    @objects = []
    @world.removeChild @world.firstChild  while @world.childNodes.length >= 1  if @world.hasChildNodes()
    @computedWeights = []
    total = 0
    j = 0

    while j < @textures.length
      total += @textures[j].weight  if @textures[j].weight > 0
      j++
    accum = 0
    j = 0

    while j < @textures.length
      if @textures[j].weight > 0
        w = @textures[j].weight / total
        @computedWeights.push
          src: @textures[j].file
          min: accum
          max: accum + w

        accum += w
      j++
    j = 0

    while j < 5
      @objects.push this.createCloud()
      j++

  createCloud: () =>
    div = document.createElement("div")
    div.className = "cloudBase"
    x = 256 - (Math.random() * 512)
    y = 256 - (Math.random() * 512)
    z = 256 - (Math.random() * 512)
    t = "translateX( " + x + "px ) translateY( " + y + "px ) translateZ( " + z + "px )"
    $(div).css(transform: t)

    @world.appendChild div
    j = 0

    while j < 5 + Math.round(Math.random() * 10)
      cloud = document.createElement("img")
      cloud.style.opacity = 0
      r = Math.random()
      src = "troll.png"     # SNG need this image, or fix code
      k = 0

      while k < @computedWeights.length
        if r >= @computedWeights[k].min and r <= @computedWeights[k].max
          ((img) ->
            img.addEventListener "load", ->
              img.style.opacity = .8

          ) cloud
          src = @computedWeights[k].src
        k++

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

      j++
    return div

  _updateWorld:() =>
    t = "translateZ( " + @translateZ + "px ) rotateX( " + @worldXAngle + "deg) rotateY( " + @worldYAngle + "deg)"
    $(@world).css(transform: t)

  _animateLayer: () =>
    # call this first
    requestAnimationFrame(this._animate);

    j = 0
    while j < @layers.length
      layer = @layers[j]

      # could add this later
      # layer.style.webkitFilter = 'blur(5px)';

      layer.data.a += layer.data.speed
      t = "translateX( " + layer.data.x + "px ) translateY( " + layer.data.y + "px ) translateZ( " + layer.data.z + "px ) rotateY( " + (-@worldYAngle) + "deg ) rotateX( " + (-@worldXAngle) + "deg ) rotateZ( " + layer.data.a + "deg ) scale( " + layer.data.s + ")"
      $(layer).css(transform: t)
      j++

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

    document.getElementById("generateBtn").addEventListener "click", (e) =>
      this.generate()
      e.preventDefault()

    window.addEventListener "keydown", (e) =>
      this.generate()  if e.keyCode is 32

    window.addEventListener "mousemove", (e) =>
      # alternate calculation
      # @worldXAngle = -(.1 * ( e.clientY - .5 * window.innerHeight ))
      # @worldYAngle = .1 * ( e.clientX - .5 * window.innerWidth )

      @worldYAngle = -(.5 - (e.clientX / window.innerWidth)) * 180
      @worldXAngle = (.5 - (e.clientY / window.innerHeight)) * 180

      this._updateWorld()

    window.addEventListener "touchmove", (e) =>
      ptr = e.changedTouches.length
      while ptr--
        touch = e.changedTouches[ptr]
        @worldYAngle = -(.5 - (touch.pageX / window.innerWidth)) * 180
        @worldXAngle = (.5 - (touch.pageY / window.innerHeight)) * 180
        this._updateWorld()
      e.preventDefault()

  _addClickHandlersToATags:() =>
    links = document.querySelectorAll("a[rel=external]")
    j = 0

    while j < links.length
      a = links[j]
      a.addEventListener "click", ((e) ->
        window.open @href, "_blank"
        e.preventDefault()
      ), false
      j++

  _setupRAF: () =>
    vendors = ["ms", "moz", "webkit", "o"]
    x = 0

    while x < vendors.length and not window.requestAnimationFrame
      window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
      window.cancelRequestAnimationFrame = window[vendors[x] + "CancelRequestAnimationFrame"]
      ++x

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
      weight: 0
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