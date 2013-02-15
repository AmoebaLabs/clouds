class window.AmoebaCD.FallingClouds
  constructor: (parentDiv, fps) ->
    @stopped = false
    @containerDiv = $('<div/>')
      .addClass('effectsStage')
      .appendTo(parentDiv)

    @clouds = [
      new AmoebaCD.Clouds(@containerDiv, fps, 3, false, 'bay')
      new AmoebaCD.Clouds(@containerDiv, fps, 3, false, 'storm')
      new AmoebaCD.Clouds(@containerDiv, fps, 2, false, 'boom')
      new AmoebaCD.Clouds(@containerDiv, fps, 3, false, 'bay')
      new AmoebaCD.Clouds(@containerDiv, fps, 1, false, 'boom')
    ]
    _.each(@clouds, (element, index) =>
      element.generate(false)
    )
    delay = 0
    _.each(@clouds, (cloud, index) =>
      this._run(cloud, delay)
      delay += 100 + Math.random() * 200
    )

  stop:() =>
    @stopped = true

    # delay the removal of the container div so that any animations running have some time to stop
    # we could call this from the transition complete, but what if it's not running?  This is more fool proof
    setTimeout(() =>
      # remove container from dom so we don't leak divs
      @containerDiv.remove()
      @containerDiv = undefined
    , 2000)

  _run: (cloud, delay) =>
    left = Math.random() * 1000
    duration = 2000 + Math.random() * 1000

    t = "translateY(-1000px)"
    cloud.applyCSS(false,
      transform: t
      left: left
    )

    t = "translateY(2000px)"
    cloud.applyCSS(true,
      transform: t
      duration: duration
      delay: delay
      complete: () =>
        if not @stopped
          this._run(cloud, delay)  # loops until stopped
    )


