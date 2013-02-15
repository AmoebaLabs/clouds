
class window.AmoebaCD.RocketExhaust extends AmoebaCD.EffectsBase
  # called from base classes constructor
  setup:() =>
    @clouds = [
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'bay')
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'fire')
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'fire')
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'bay')
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'fire')
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'fire')
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'bay')
    ]

    _.each(@clouds, (element, index) =>
      element.generate(false)
    )

    delay = 0
    _.each(@clouds, (cloud, index) =>
      this._run(cloud, delay)
      delay += 40
    )

  _run: (cloud, delay) =>
    numClouds = @clouds.length

    # set the starting point for the transition
    left = window.innerWidth / 2
    top = window.innerHeight / 4
    t = "translateY(0px)"
    cloud.applyCSS(
      transform: t
      scale: 0.2
      opacity: 1
      display: 'inline'
      left: left
      top: top
    )

    # don't use the complete: callback since that will get called for
    # every layer this transition is applied to. Send callback to applyCSS
    transitionCallback = () =>
      @numExpectedCallbacks--
      if not @stopped
        this._run(cloud, 10)  # loops until stopped
      else
        if @numExpectedCallbacks == 0
          this._tearDown()

    @numExpectedCallbacks++
    duration = 300
    t = "translateY(#{(window.innerHeight / 4) + 60}px)"
    cloud.animateCSS(transitionCallback,
      transform: t
      scale: 0.6
      opacity: 0.2
      duration: duration
      delay: delay
    , true)


