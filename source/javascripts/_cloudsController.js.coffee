class window.AmoebaCD.CloudsController
  constructor:() ->
    @viewPort = $("#viewport")
    @fps = 24

    AmoebaCD.textures = new AmoebaCD.Textures()
    AmoebaCD.cloudWorld = new AmoebaCD.CloudWorld(@fps)

    showUI = true
    if showUI
      AmoebaCD.options = new AmoebaCD.CloudOptions()
    else
      AmoebaCD.cloudWorld.generate()

    this._addClickHandlersToATags()
    this._addEventHandlers()
    this._setupRAF()
    this._slowlyRotateWorld()
    # this._setupEventListenersToMoveWorld()

  _addEventHandlers: () =>
    window.addEventListener "keydown", (e) =>
      # keycodes are always the uppercase character's ascii code
      switch (e.keyCode)
        when 32
          AmoebaCD.cloudWorld.generate()
        when 68  # 'd' key
          AmoebaCD.cloudWorld.hyperspace()
        when 69  # 'e' key
          AmoebaCD.cloudWorld.zoomWorld()
        when 70  # 'f' key
          this._showFallingClouds()
        when 71  # 'g' key
          AmoebaCD.cloudWorld.reversehyperspace()
        when 72
          this._showRocketShip()
        when 67  # 'c' key
          # only toggle if AmoebaCD.options exists
          if AmoebaCD.options?
            if $("#options").css('display') is 'none'
              $("#options").css(display: "block");
            else
              $("#options").css(display: "none");
#        else
#          console.log("keyCode: #{e.keyCode}")

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

  _setupEventListenersToMoveWorld: () =>
    orientationhandler = (e) ->
      [xAngle, yAngle, zTranslate] = AmoebaCD.cloudWorld.worldState()

      if not e.gamma and not e.beta
        e.gamma = -(e.x * (180 / Math.PI))
        e.beta = -(e.y * (180 / Math.PI))
      x = e.gamma
      y = e.beta
      xAngle = y
      yAngle = x
      AmoebaCD.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)

    # window.addEventListener( 'deviceorientation', orientationhandler, false );
    # window.addEventListener( 'MozOrientation', orientationhandler, false );

    onContainerMouseWheel = (event) =>
      [xAngle, yAngle, zTranslate] = AmoebaCD.cloudWorld.worldState()

      event = (if event then event else window.event)
      zTranslate = zTranslate - ((if event.detail then event.detail * -5 else event.wheelDelta / 8))
      AmoebaCD.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)

    window.addEventListener "mousewheel", onContainerMouseWheel
    window.addEventListener "DOMMouseScroll", onContainerMouseWheel

    window.addEventListener "mousemove", (e) =>
      # alternate calculation
      # xAngle = -(.1 * ( e.clientY - .5 * window.innerHeight ))
      # yAngle = .1 * ( e.clientX - .5 * window.innerWidth )

      [xAngle, yAngle, zTranslate] = AmoebaCD.cloudWorld.worldState()

      yAngle = -(.5 - (e.clientX / window.innerWidth)) * 180
      xAngle = (.5 - (e.clientY / window.innerHeight)) * 180

      AmoebaCD.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)

    window.addEventListener "touchmove", (e) =>
      [xAngle, yAngle, zTranslate] = AmoebaCD.cloudWorld.worldState()

      _.each(e.changedTouches, (touch, index) =>
        yAngle = -(.5 - (touch.pageX / window.innerWidth)) * 180
        xAngle = (.5 - (touch.pageY / window.innerHeight)) * 180
        AmoebaCD.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)
      )

      e.preventDefault()

  _showFallingClouds: () =>
    if @fallingClouds?
      @fallingClouds.stop()
      @fallingClouds = undefined

    @fallingClouds = new AmoebaCD.FallingClouds(@viewPort, @fps)

    # clouds continue to fall for 8 seconds, then we stop it here
    setTimeout(() =>
      if @fallingClouds?
        @fallingClouds.stop()
        @fallingClouds = undefined
    , 8000)

  _showRocketShip: () =>
    rocketShip = new AmoebaCD.RocketShip(@viewPort, @fps, () =>
      rocketShip.stop()
      rocketShip = undefined
    )

  _slowlyRotateWorld: () =>
    AmoebaCD.cloudWorld.slowlyRotateWorld()
