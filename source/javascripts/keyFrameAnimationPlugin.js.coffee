

class AmoebaCD.KeyframeAnimationPlugin
  constructor:() ->
    if AmoebaCD.keyframeAnimationPlugin?
      console.log("AmoebaCD.keyframeAnimationPlugin created twice?")

    _props =
      animation: ['animation', 'animationend', 'keyframes'],
      webkitAnimation: ['-webkit-animation', 'webkitAnimationEnd', '-webkit-keyframes'],
      MozAnimation: ['-moz-animation', 'animationend', '-moz-keyframes'],
      OAnimation: ['-o-animation', 'oAnimationEnd', '-o-keyframes'],
      MSAnimation: ['-ms-animation', 'MSAnimationEnd', '-ms-keyframes']

    style = document.createElement('div').style
    for key of _props
      if style[key] != undefined
        opts = _props[key]
        @animationProperty = opts[0]
        @endAnimation = opts[1]
        @keyFramesProperty = opts[2]
        break

    this._setupJQueryFunctions()

  _setupJQueryFunctions: () =>
    $.fn.keyframe = (name, duration, easing, delay, iterations, direction, callback) ->
      if (typeof duration == 'object')
        callback = duration.complete
        direction = duration.direction
        iterations = duration.iterations
        delay = duration.delay
        easing = duration.easing
        duration = duration.duration

      direction = direction || 'normal'
      iterations = iterations || 1
      delay = delay || 0
      easing = easing || 'linear'
      duration = duration || 1
      if (typeof duration == 'number')
        duration += 'ms'

      if (typeof delay == 'number')
        delay += 'ms'

      if (callback)
        AmoebaCD.keyframeAnimationPlugin.animationCallback(this, callback)

      params = [name, duration, easing, delay, iterations, direction].join(' ')

      this.css(AmoebaCD.keyframeAnimationPlugin.animationProperty, params)

    return this

  animationCallback: (element, callback) =>
    return element.one(@endAnimation, element, callback)

# is a variable like this the best or only way to do this?
AmoebaCD.keyframeAnimationPlugin ?= new AmoebaCD.KeyframeAnimationPlugin()



###

  experiments

  @include keyframes(cloudPulse) {
  0% {
    opacity: 1;
    @include skewX(0deg)
  } 50% {
    opacity:0.4;
      @include skewX(360deg)
  } 100% {
    opacity:1;
    @include skewX(0deg)
  }
}




      layerHolder = document.createElement("div")
      layerHolder.appendChild layer

      $(layerHolder).keyframe('cloudPulse', 125800, 'linear', 1*Math.random(), 'infinite', 'normal', (element) =>
        console.log("should run forever?")
        $(layerHolder).css(AmoebaCD.keyframeAnimationPlugin.animationProperty, '')
      )




###