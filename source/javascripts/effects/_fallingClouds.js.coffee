
class window.AmoebaCD.FallingClouds extends AmoebaCD.EffectsBase
  # called from base classes constructor
  setup:() =>
    fragment = document.createDocumentFragment();

    @clouds = [
      new AmoebaCD.Cloud(fragment, AmoebaCD.textures.weightedTextures('clouds'), @fps)
      new AmoebaCD.Cloud(fragment, AmoebaCD.textures.weightedTextures('storm'), @fps)
      new AmoebaCD.Cloud(fragment, AmoebaCD.textures.weightedTextures('clouds'), @fps)
      new AmoebaCD.Cloud(fragment, AmoebaCD.textures.weightedTextures('storm'), @fps)
      new AmoebaCD.Cloud(fragment, AmoebaCD.textures.weightedTextures('clouds'), @fps)
    ]

    @containerDiv[0].appendChild(fragment);

    delay = 0
    _.each(@clouds, (cloud, index) =>
      this._run(cloud, delay)
      delay += 100 + Math.random() * 200
    )

  _run: (cloud, delay) =>
    numClouds = @clouds.length

    # set the starting point for the transition
    left = Math.random() * window.innerWidth
    t = "translateY(-1000px)"
    cloud.applyCSS(
      transform: t
      left: left
    )

    # don't use the complete: callback since that will get called for
    # every layer this transition is applied to. Send callback to applyCSS
    transitionCallback = () =>
      @numExpectedCallbacks--
      if not @stopped
        this._run(cloud, delay)  # loops until stopped
      else
        if @numExpectedCallbacks == 0
          this._tearDown()

    @numExpectedCallbacks++
    duration = 800 + Math.random() * 1000
    t = "translateY(#{window.innerHeight + 100}px)"
    cloud.animateCSS(
      transform: t
      duration: duration
      delay: delay
      complete: transitionCallback
    )


