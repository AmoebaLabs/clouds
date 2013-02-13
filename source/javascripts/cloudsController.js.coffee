class window.AmoebaCD.CloudsController
  constructor:() ->
    @world = $("#world").get(0)
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0

    AmoebaCD.clouds = new window.AmoebaCD.Clouds(@world, 24)

    showUI = true
    if showUI
      AmoebaCD.options = new window.AmoebaCD.CloudOptions(AmoebaCD.clouds.textures)
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
