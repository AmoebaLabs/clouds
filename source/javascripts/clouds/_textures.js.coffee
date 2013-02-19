
class window.AmoebaCD.Textures
  constructor:() ->
    @currentWeights = this.preset('clouds')

  textures: (preset='current') =>
    weights = this.preset(preset)

    result = [
      name: "white cloud"
      file: "/images/cloud.png"
      weight: weights[0]
    ,
      name: "dark cloud"
      file: "/images/darkCloud.png"
      weight: weights[1]
    ,
      name: "smoke cloud"
      file: "/images/smoke.png"
      weight: weights[2]
    ,
      name: "explosion"
      file: "/images/explosion.png"
      weight: weights[3]
    ,
      name: "explosion 2"
      file: "/images/explosion2.png"
      weight: weights[4]
    ,
      name: "box"
      file: "/images/box.png"
      weight: weights[5]
    ]

    return result

  weightedTextures: (preset='current') =>
    textures = this.textures(preset)

    total = 0
    _.each(textures, (texture, index) =>
      total += texture.weight  if texture.weight > 0
    )

    result = []
    accum = 0
    _.each(textures, (texture, index) =>
      if texture.weight > 0
        w = texture.weight / total

        result.push
          src: texture.file
          min: accum
          max: accum + w

        accum += w
    )

    return result

  setCurrentWeights: (weights) =>
    @currentWeights = weights[..]  # copies array

  preset: (preset='current') =>
    weights = [1,0,0,0,0,0]

    switch preset
      when 'current'
        weights = @currentWeights[..]  # copies array
      when 'clouds'
        weights = [1,0,0,0,0,0]
      when 'storm'
        weights = [0,0,1,0,0,0]
      when 'boom'
        weights = [0,0,1,0.3,0,0]
      when 'bay'
        weights = [0,0,0.7,1,1,0]
      when 'fire'
        weights = [0,0,0,1,1,0]
      else
        console.log("not a valid preset: #{preset}")

    return weights
