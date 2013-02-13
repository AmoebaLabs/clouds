class window.AmoebaCD.Clouds
  constructor:(@world, @fps) ->
    @textures = this._buildTextures()

    @clouds = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0
    @numClusters = 5

    this._animate()  # starts the requestAnimationFrame loop

  generate: () =>
    if @world.hasChildNodes()
      while @world.childNodes.length >= 1
        @world.removeChild(@world.firstChild)

    total = 0
    _.each(@textures, (texture, index) =>
      total += texture.weight  if texture.weight > 0
    )

    computedWeights = []
    accum = 0
    _.each(@textures, (texture, index) =>
      if texture.weight > 0
        w = texture.weight / total

        computedWeights.push
          src: texture.file
          min: accum
          max: accum + w

        accum += w
    )

    @clouds = []
    for i in [0...@numClusters]
      @clouds.push(new window.AmoebaCD.Cloud(@world, computedWeights, @fps))

  updateWorld:(worldXAngle, worldYAngle, translateZ) =>
    @worldXAngle = worldXAngle
    @worldYAngle = worldYAngle
    @translateZ = translateZ

    t = "translateZ( " + @translateZ + "px ) rotateX( " + @worldXAngle + "deg) rotateY( " + @worldYAngle + "deg)"
    $(@world).css(transform: t)

  _animateLayer: () =>
    # call this first
    requestAnimationFrame(this._animate);

    _.each(@clouds, (cloud, index) =>
      # could add this later
      # cloud.style.webkitFilter = 'blur(5px)';

      cloud.transformLayers(@worldXAngle, @worldYAngle)
    )

  # called by requestAnimationFrame to set the next state of animation
  _animate: () =>
    if @fps >= 60
      this._animateLayer()
    else
      setTimeout(() =>
        this._animateLayer()
      ,1000 / @fps)

  _buildTextures: () =>
    result = [
      name: "white cloud"
      file: "/images/cloud.png"
      opacity: 1
      weight: 1
    ,
      name: "dark cloud"
      file: "/images/darkCloud.png"
      opacity: 1
      weight: 0
    ,
      name: "smoke cloud"
      file: "/images/smoke.png"
      opacity: 1
      weight: 0
    ,
      name: "explosion"
      file: "/images/explosion.png"
      opacity: 1
      weight: 0
    ,
      name: "explosion 2"
      file: "/images/explosion2.png"
      opacity: 1
      weight: 0
    ,
      name: "box"
      file: "/images/box.png"
      opacity: 1
      weight: 0
    ]

    return result