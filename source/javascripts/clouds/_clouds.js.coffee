class window.AmoebaCD.Clouds
  constructor:() ->
    @world = document.getElementById("world")
    @viewport = document.getElementById("viewport")
    @layers = []
    @objects = []
    @computedWeights = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0
    @lastTime = 0

    this._addClickHandlersToATags()
    this.setup()

  generate: () =>
    @objects = []
    @world.removeChild @world.firstChild  while @world.childNodes.length >= 1  if @world.hasChildNodes()
    @computedWeights = []
    total = 0
    j = 0

    textures = AmoebaCD.data.textures

    while j < textures.length
      total += textures[j].weight  if textures[j].weight > 0
      j++
    accum = 0
    j = 0

    while j < textures.length
      if textures[j].weight > 0
        w = textures[j].weight / total
        @computedWeights.push
          src: textures[j].file
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
    div.style.webkitTransform = t
    div.style.MozTransform = t
    div.style.oTransform = t
    @world.appendChild div
    j = 0

    while j < 5 + Math.round(Math.random() * 10)
      cloud = document.createElement("img")
      cloud.style.opacity = 0
      r = Math.random()
      src = "troll.png"
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
        speed: .1 * Math.random()

      t = "translateX( " + x + "px ) translateY( " + y + "px ) translateZ( " + z + "px ) rotateZ( " + a + "deg ) scale( " + s + " )"
      cloud.style.webkitTransform = t
      cloud.style.MozTransform = t
      cloud.style.oTransform = t
      div.appendChild cloud
      @layers.push cloud
      j++
    div



  setup: () =>
    #window.addEventListener( 'deviceorientation', orientationhandler, false );
    #window.addEventListener( 'MozOrientation', orientationhandler, false );

    #@worldXAngle = .1 * ( e.clientY - .5 * window.innerHeight );
    #@worldYAngle = .1 * ( e.clientX - .5 * window.innerWidth );

    updateView = =>
      t = "translateZ( " + @translateZ + "px ) rotateX( " + @worldXAngle + "deg) rotateY( " + @worldYAngle + "deg)"
      @world.style.webkitTransform = t
      @world.style.MozTransform = t
      @world.style.oTransform = t
    orientationhandler = (e) ->
      if not e.gamma and not e.beta
        e.gamma = -(e.x * (180 / Math.PI))
        e.beta = -(e.y * (180 / Math.PI))
      x = e.gamma
      y = e.beta
      @worldXAngle = y
      @worldYAngle = x
      updateView()

    update = =>
      j = 0

      while j < @layers.length
        layer = @layers[j]
        layer.data.a += layer.data.speed
        t = "translateX( " + layer.data.x + "px ) translateY( " + layer.data.y + "px ) translateZ( " + layer.data.z + "px ) rotateY( " + (-@worldYAngle) + "deg ) rotateX( " + (-@worldXAngle) + "deg ) rotateZ( " + layer.data.a + "deg ) scale( " + layer.data.s + ")"
        layer.style.webkitTransform = t
        layer.style.MozTransform = t
        layer.style.oTransform = t
        j++

      #layer.style.webkitFilter = 'blur(5px)';
      requestAnimationFrame update

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

    onContainerMouseWheel = (event) =>
      event = (if event then event else window.event)
      @translateZ = @translateZ - ((if event.detail then event.detail * -5 else event.wheelDelta / 8))
      updateView()

    window.addEventListener "mousewheel", onContainerMouseWheel
    window.addEventListener "DOMMouseScroll", onContainerMouseWheel

    document.getElementById("generateBtn").addEventListener "click", (e) =>
      this.generate()
      e.preventDefault()

    window.addEventListener "keydown", (e) =>
      this.generate()  if e.keyCode is 32

    window.addEventListener "mousemove", (e) =>
      @worldYAngle = -(.5 - (e.clientX / window.innerWidth)) * 180
      @worldXAngle = (.5 - (e.clientY / window.innerHeight)) * 180
      updateView()

    window.addEventListener "touchmove", (e) =>
      ptr = e.changedTouches.length
      while ptr--
        touch = e.changedTouches[ptr]
        @worldYAngle = -(.5 - (touch.pageX / window.innerWidth)) * 180
        @worldXAngle = (.5 - (touch.pageY / window.innerHeight)) * 180
        updateView()
      e.preventDefault()

    update()


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
