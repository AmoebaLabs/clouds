class window.AmoebaCD.CloudsController
  constructor:() ->
    @world = $("#world").get(0)
    @sky = $("#sky").get(0)
    @viewport = $("#viewport").get(0)

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

    @viewport.appendChild @whiteOut.get(0)

    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0

    AmoebaCD.textures = new window.AmoebaCD.Textures()
    AmoebaCD.clouds = new window.AmoebaCD.Clouds(@world, 24)

    showUI = true
    if showUI
      AmoebaCD.options = new window.AmoebaCD.CloudOptions()
    else
      AmoebaCD.clouds.generate()

    this._addClickHandlersToATags()
    this._addEventHandlers()
    this._setupRAF()
    this._setupEventListeners()

  _addEventHandlers: () =>
    window.addEventListener "keydown", (e) =>
      switch (e.keyCode)
        when 32
          AmoebaCD.clouds.generate()
        when 68  # 'd' key
          this._hyperspace()
        when 69  # 'e' key
          this._rotateWorld()
        when 70  # 'f' key
          this._showSky()
        when 71  # 'g' key
          this._reversehyperspace()
        when 67  # 'c' key
          # only toggle if AmoebaCD.options exists
          if AmoebaCD.options?
            if $("#options").css('display') is 'none'
              $("#options").css(display: "block");
            else
              $("#options").css(display: "none");
        else
          console.log(e.keyCode)

  _addClickHandlersToATags: () =>
    links = document.querySelectorAll("a[rel=external]")

    _.each(links, (a, index) =>
      a.addEventListener("click", (e) ->
        window.open @href, "_blank"
        e.preventDefault()
      )
    )

  # requestAnimationFrame polyfill
  _setupRAF: () =>
    vendors = ["ms", "moz", "webkit", "o"]

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

  _setupEventListeners: () =>
    orientationhandler = (e) ->
      if not e.gamma and not e.beta
        e.gamma = -(e.x * (180 / Math.PI))
        e.beta = -(e.y * (180 / Math.PI))
      x = e.gamma
      y = e.beta
      @worldXAngle = y
      @worldYAngle = x
      AmoebaCD.clouds.updateWorld(@worldXAngle, @worldYAngle, @translateZ)

    # window.addEventListener( 'deviceorientation', orientationhandler, false );
    # window.addEventListener( 'MozOrientation', orientationhandler, false );

    onContainerMouseWheel = (event) =>
      event = (if event then event else window.event)
      @translateZ = @translateZ - ((if event.detail then event.detail * -5 else event.wheelDelta / 8))
      AmoebaCD.clouds.updateWorld(@worldXAngle, @worldYAngle, @translateZ)

    window.addEventListener "mousewheel", onContainerMouseWheel
    window.addEventListener "DOMMouseScroll", onContainerMouseWheel

    window.addEventListener "mousemove", (e) =>
      # alternate calculation
      # @worldXAngle = -(.1 * ( e.clientY - .5 * window.innerHeight ))
      # @worldYAngle = .1 * ( e.clientX - .5 * window.innerWidth )

      @worldYAngle = -(.5 - (e.clientX / window.innerWidth)) * 180
      @worldXAngle = (.5 - (e.clientY / window.innerHeight)) * 180

      AmoebaCD.clouds.updateWorld(@worldXAngle, @worldYAngle, @translateZ)

    window.addEventListener "touchmove", (e) =>
      _.each(e.changedTouches, (touch, index) =>
        @worldYAngle = -(.5 - (touch.pageX / window.innerWidth)) * 180
        @worldXAngle = (.5 - (touch.pageY / window.innerHeight)) * 180
        AmoebaCD.clouds.updateWorld(@worldXAngle, @worldYAngle, @translateZ)
      )

      e.preventDefault()

  _hyperspace: () =>
    t = "translateZ(#{@translateZ+2000}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    $(@world).transition(
      transform: t
      duration: 2600
    )
    @whiteOut.transition(
      opacity: 1
      duration: 2600
    )

  _reversehyperspace: () =>
    t = "translateZ(#{@translateZ+2000}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    $(@world).css(
      transform: t
      duration: 2600
    )
    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    $(@world).transition(
      transform: t
      duration: 2600
    )
    @whiteOut.transition(
      opacity: 0
      duration: 600
    )

  _rotateWorld: () =>
    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle+360}deg) rotateY(#{@worldYAngle+360}deg)"
    $(@world).transition(
      transform: t
      duration: 2600
    )

  _showSky: () =>
    if not AmoebaCD.skyClouds?
      AmoebaCD.skyClouds = [
        new window.AmoebaCD.Clouds(@sky, 24, 3)
        new window.AmoebaCD.Clouds(@sky, 24, 3)
        new window.AmoebaCD.Clouds(@sky, 24, 2)
        new window.AmoebaCD.Clouds(@sky, 24, 3)
        new window.AmoebaCD.Clouds(@sky, 24, 1)
      ]
      _.each(AmoebaCD.skyClouds, (element, index) =>
        element.generate(false)
      )

    _.each(AmoebaCD.skyClouds, (element, index) =>
      element.fallFromSky()
    )