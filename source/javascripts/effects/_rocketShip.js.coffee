
class window.AmoebaCD.RocketShip extends AmoebaCD.EffectsBase
  # called from base classes constructor
  setup:() =>
    fragment = document.createDocumentFragment();

    this._buildShip(fragment)

    @containerDiv[0].appendChild(fragment);

    this._runShipAnimation()

    delay = 0
    _.each(@exhaustClouds, (cloud, index) =>
      this._runExhaustAnimation(cloud, delay)
      delay += 90
    )

  _runShipAnimation: () =>
    @ship.css(
      opacity: 1
      scale: 1
      left: window.innerWidth / 2
      top: window.innerHeight
    )

    duration = 4000
    @ship.transition(
      top: -1000
      scale: 1
      duration: duration
      complete: () =>
        this.stop()

        if @callback?
          @callback.call()
    )

  _runExhaustAnimation: (cloud, delay) =>
    numClouds = @exhaustClouds.length

    # set the starting point for the transition
    cloud.applyCSS(
      opacity: 1
      display: 'block' # display : none is set at end of transition
      left: '50%'
      top: 30
      # clouds by default are translated x,y on creation, so this returns it back to zero
      transform: 'translateX(0px) scale(0.2) translateY(0px)'
    )

    # don't use the complete: callback since that will get called for
    # every layer this transition is applied to. Send callback to applyCSS
    transitionCallback = () =>
      @numExpectedCallbacks--
      if not @stopped
        this._runExhaustAnimation(cloud, 10)  # loops until stopped
      else
        if @numExpectedCallbacks == 0
          this._tearDown()

    @numExpectedCallbacks++
    duration = 300
    cloud.animateCSS(
      top: 233
      scale: 0.6
      opacity: 0.4
      duration: duration
      delay: delay
      complete: transitionCallback
    )

  _buildShip: (parentDiv) =>
    @ship = $('<div/>')
      .appendTo(parentDiv)
      .css(
        position: 'absolute'
        top: 30
        left: (window.innerWidth / 2) - 30
        width: 200
        height: 360
        backgroundImage: 'url("' + shipImage + '")'
        backgroundPosition: 'center center'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
      )

    shipImage = "/images/mascot.svg"
    shipDiv = $('<div/>')
      .appendTo(@ship)
      .css(
        position: 'absolute'
        top: 0
        left: 0
        width: '100%'
        height: '40%'
        backgroundImage: 'url("' + shipImage + '")'
        backgroundPosition: 'center center'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
      )
    fireDiv = $('<div/>')
      .appendTo(@ship)
      .css(
        position: 'absolute'
        top: '40%'
        left: 0
        width: '100%'
        height: '60%'
      )

    this._addExhaustClouds(fireDiv)

  _addExhaustClouds: (parentDiv) =>
    @exhaustClouds = [
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('bay'), @fps)
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('fire'), @fps)
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('fire'), @fps)
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('bay'), @fps)
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('fire'), @fps)
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('fire'), @fps)
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('bay'), @fps)
      new AmoebaCD.Cloud(parentDiv, AmoebaCD.textures.weightedTextures('bay'), @fps)
    ]
