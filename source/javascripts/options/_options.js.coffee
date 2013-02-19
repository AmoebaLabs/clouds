
class window.AmoebaCD.CloudOptions
  constructor:() ->
    @weights = [ 0, 0.3, 0.7, 1]

    this._setupButtons()
    this._setupPresets()
    this._setupFullScreenButton()

    this._refresh()

    # show the options div
    $("#options").css(display: "block");

  _setTextureUsage: (textureIndex, mode) =>
    weights = AmoebaCD.textures.preset()

    weights[textureIndex] = @weights[mode]

    AmoebaCD.textures.setCurrentWeights(weights)

  _refresh: () =>
    this._syncButtons()
    AmoebaCD.cloudWorld.generate()

  _setupPresets: () =>
    document.getElementById("cloudsPreset").addEventListener "click", (e) =>
      AmoebaCD.textures.setCurrentWeights(AmoebaCD.textures.preset('clouds'))
      this._refresh()
      e.preventDefault()

    document.getElementById("stormPreset").addEventListener "click", (e) =>
      AmoebaCD.textures.setCurrentWeights(AmoebaCD.textures.preset('storm'))
      this._refresh()
      e.preventDefault()

    document.getElementById("boomPreset").addEventListener "click", (e) =>
      AmoebaCD.textures.setCurrentWeights(AmoebaCD.textures.preset('boom'))
      this._refresh()
      e.preventDefault()

    document.getElementById("bayPreset").addEventListener "click", (e) =>
      AmoebaCD.textures.setCurrentWeights(AmoebaCD.textures.preset('bay'))
      this._refresh()
      e.preventDefault()

  _syncButtons: () =>
    _.each(AmoebaCD.textures.textures(), (texture, textureIndex) =>
      _.each(@weights, (weight, weightIndex) =>
        el = $("#btn#{weightIndex}#{textureIndex}")

        if (texture.weight == weight)
          el.addClass("active")
        else
          el.removeClass("active")
      )
    )

  _setupButtons: () =>
    el = document.getElementById("textureList")

    _.each(AmoebaCD.textures.textures(), (texture, index) =>
      li = document.createElement("li")
      span = document.createElement("span")
      span.textContent = texture.name

      div = document.createElement("div")
      div.className = "buttons"

      btnNone = document.createElement("a")
      btnNone.setAttribute "id", "btn0" + index
      btnNone.setAttribute "href", "#"
      btnNone.textContent = "None"
      btnNone.className = "left button"

      btnFew = document.createElement("a")
      btnFew.setAttribute "id", "btn1" + index
      btnFew.setAttribute "href", "#"
      btnFew.textContent = "A few"
      btnFew.className = "middle button"

      btnNormal = document.createElement("a")
      btnNormal.setAttribute "id", "btn2" + index
      btnNormal.setAttribute "href", "#"
      btnNormal.textContent = "Some"
      btnNormal.className = "middle button"

      btnLot = document.createElement("a")
      btnLot.setAttribute "id", "btn3" + index
      btnLot.setAttribute "href", "#"
      btnLot.textContent = "A lot"
      btnLot.className = "right button"

      ((id) =>
        btnNone.addEventListener "click", =>
          this._setTextureUsage id, 0
          this._refresh()
        btnFew.addEventListener "click", =>
          this._setTextureUsage id, 1
          this._refresh()
        btnNormal.addEventListener "click", =>
          this._setTextureUsage id, 2
          this._refresh()
        btnLot.addEventListener "click", =>
          this._setTextureUsage id, 3
          this._refresh()
      ) index

      li.appendChild span
      div.appendChild btnNone
      div.appendChild btnFew
      div.appendChild btnNormal
      div.appendChild btnLot
      li.appendChild div
      el.appendChild li
    )

  _setupFullScreenButton: () =>
    el = document.getElementById("fullscreenBtn")
    if el
      options = document.getElementById("options")
      el.addEventListener "click", ((e) =>
        if document.body.webkitRequestFullScreen
          document.body.onwebkitfullscreenchange = (e) =>

            #    options.style.display = 'none';
            document.body.style.width = window.innerWidth + "px"
            document.body.style.height = window.innerHeight + "px"
            document.body.onwebkitfullscreenchange = =>


              #		options.style.display = 'block';
          document.body.webkitRequestFullScreen()

        #document.body.onmozfullscreenchange = function( e ) {
        #                 options.style.display = 'none';
        #                 document.body.onmozfullscreenchange = function( e ) {
        #                 options.style.display = 'block';
        #                 };
        #                 };
        document.body.mozRequestFullScreen()  if document.body.mozRequestFullScreen
        e.preventDefault()
      ), false

