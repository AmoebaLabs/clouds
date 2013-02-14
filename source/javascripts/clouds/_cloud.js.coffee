class window.AmoebaCD.Cloud
  constructor:(parentDiv, computedWeights, fps) ->
    @layers = []

    @cloudBase = $("<div/>")
      .addClass("cloudBase")

    @cloudBase.appendTo(parentDiv)

    x = 256 - (Math.random() * 512)
    y = 256 - (Math.random() * 512)
    z = 256 - (Math.random() * 512)
    t = "translateX(#{x}px) translateY(#{y}px) translateZ(#{z}px)"
    @cloudBase.css(transform: t)

    cnt = 5 + Math.round(Math.random() * 10)
    for j in [0...cnt]
      layer = $("<img/>")
      layer.css(opacity: 0)
      r = Math.random()
      src = "troll.png"     # SNG need this image, or fix code

      _.each(computedWeights, (weight, index) =>
        if r >= weight.min and r <= weight.max
          src = weight.src
          this._loadLayer(layer)
      )

      layer.attr(src: src)
      layer.addClass("cloudLayer")

      x = 256 - (Math.random() * 512)
      y = 256 - (Math.random() * 512)
      z = 100 - (Math.random() * 200)
      a = Math.random() * 360
      s = .25 + Math.random()
      x *= .2
      y *= .2

      data =
        x: x
        y: y
        z: z
        a: a
        s: s
        speed: ((60/Math.min(fps, 60)) * .1) * Math.random()

      t = "translateX(#{x}px) translateY(#{y}px) translateZ(#{z}px) rotateZ(#{a}deg) scale(#{s})"
      layer.css(transform: t)

      layer.appendTo(@cloudBase)
      @layers.push
        layer: layer
        data: data

  transformLayers: (angleX, angleY) =>
    _.each(@layers, (layerObj, index) =>
      layerObj.data.a += layerObj.data.speed
      t = "translateX(#{layerObj.data.x}px) translateY(#{layerObj.data.y}px) translateZ(#{layerObj.data.z}px) rotateY(#{(-angleY)}deg) rotateX(#{(-angleX)}deg) rotateZ(#{layerObj.data.a}deg) scale(#{layerObj.data.s})"

      layerObj.layer.css(transform: t)
    )

  fallFromSky: () =>
    left = Math.random() * 1000
    delay = Math.random() * 1600
    duration = 1000 + Math.random() * 1000

    t = "translateY(-1000px)"
    @cloudBase.css(
      transform: t
      left: left
    )
    t = "translateY(2000px)"
    @cloudBase.transition(
      transform: t
      duration: duration
      delay: delay
    )

  fireCloud: () =>
    delay = Math.random() * 100
    duration = 100 + Math.random() * 100

    _.each(@layers, (layerObj, index) =>
      zTrans = Math.floor(Math.random() * 500)

      t = "translateZ(#{zTrans}px)"
      layerObj.transition(
        transform: t
        duration: duration
        delay: delay
      )
      t = "translateZ(#{-zTrans}px)"
      layerObj.transition(
        transform: t
        duration: duration
        delay: delay
      )
    )

  # need the closure on layer, so made it a function
  _loadLayer: (layer) =>
    layer.load( () =>
      layer.css(opacity: 0.8)
    )
