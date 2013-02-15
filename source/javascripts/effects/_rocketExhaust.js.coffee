
class window.AmoebaCD.RocketExhaust extends AmoebaCD.EffectsBase
  # called from base classes constructor
  setup:() =>
    @clouds = [
      new AmoebaCD.Clouds(@containerDiv, @fps, 3, false, 'bay')
      new AmoebaCD.Clouds(@containerDiv, @fps, 3, false, 'storm')
      new AmoebaCD.Clouds(@containerDiv, @fps, 2, false, 'boom')
      new AmoebaCD.Clouds(@containerDiv, @fps, 3, false, 'bay')
      new AmoebaCD.Clouds(@containerDiv, @fps, 1, false, 'boom')
    ]

    _.each(@clouds, (element, index) =>
      element.generate(false)
    )

    delay = 0
    _.each(@clouds, (cloud, index) =>
      this._run(cloud, delay)
      delay += 100 + Math.random() * 200
    )

  _run: (cloud, delay) =>
    left = Math.random() * window.innerWidth
    duration = 800 + Math.random() * 1000

    t = "translateY(-1000px)"
    cloud.applyCSS(false,
      transform: t
      left: left
    )

    t = "translateY(#{window.innerHeight + 100}px)"
    cloud.applyCSS(true,
      transform: t
      duration: duration
      delay: delay
      complete: () =>
        if not @stopped
          this._run(cloud, delay)  # loops until stopped
        else
          this._tearDown()
    )


