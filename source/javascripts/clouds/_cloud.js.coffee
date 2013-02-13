class window.AmoebaCD.Cloud
  constructor:(parentDiv, computedWeights, fps) ->
    @layers = []

    div = document.createElement("div")
    div.className = "cloudBase"

    parentDiv.appendChild(div)

    x = 256 - (Math.random() * 512)
    y = 256 - (Math.random() * 512)
    z = 256 - (Math.random() * 512)
    t = "translateX( " + x + "px ) translateY( " + y + "px ) translateZ( " + z + "px )"
    $(div).css(transform: t)

    cnt = 5 + Math.round(Math.random() * 10)
    for j in [0...cnt]
      layer = document.createElement("img")
      layer.style.opacity = 0
      r = Math.random()
      src = "troll.png"     # SNG need this image, or fix code

      _.each(computedWeights, (weight, index) =>
        if r >= weight.min and r <= weight.max
          ((img) ->
            img.addEventListener "load", ->
              img.style.opacity = .8

          ) layer
          src = weight.src
      )

      layer.setAttribute "src", src
      layer.className = "cloudLayer"

      x = 256 - (Math.random() * 512)
      y = 256 - (Math.random() * 512)
      z = 100 - (Math.random() * 200)
      a = Math.random() * 360
      s = .25 + Math.random()
#      x *= .2
#      y *= .2

      data =
        x: x
        y: y
        z: z
        a: a
        s: s
        speed: ((60/Math.min(fps, 60)) * .1) * Math.random()

      t = "translateX( " + x + "px ) translateY( " + y + "px ) translateZ( " + z + "px ) rotateZ( " + a + "deg ) scale( " + s + " )"
      $(layer).css(transform: t)

      div.appendChild layer
      @layers.push
        layer: $(layer)
        data: data

  transformLayers: (angleX, angleY) =>
    _.each(@layers, (layerObj, index) =>
      layerObj.data.a += layerObj.data.speed
      t = "translateX( " + layerObj.data.x + "px ) translateY( " + layerObj.data.y + "px ) translateZ( " + layerObj.data.z + "px ) rotateY( " + (-angleY) + "deg ) rotateX( " + (-angleX) + "deg ) rotateZ( " + layerObj.data.a + "deg ) scale( " + layerObj.data.s + ")"

      layerObj.layer.css(transform: t)
    )
