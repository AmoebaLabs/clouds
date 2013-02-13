
class window.AmoebaCD.CloudOptions
  constructor:(@textures) ->
    @modes = [
      name: 'None'
      weight: 0
    ,
      name: 'Few'
      weight: .3
    ,
      name: 'Normal'
      weight: .7
    ,
      name: 'Lot'
      weight: 1
    ]

    this._setupButtons()
    this._setupPresets()
    this._setupOtherButtons()
    this._setupFullScreenButton()

    # show the options div
    $("#options").css(display: "block");

  _setTextureUsage: (id, mode) =>
    _.each(@modes, (modeSpec, index) =>
      el = $("#btn" + modeSpec.name + id)

      if modeSpec.name is mode
        el.addClass("active")
        @textures[id].weight = modeSpec.weight
      else
        el.removeClass("active")
    )

  _setupPresets: () =>
    document.getElementById("cloudsPreset").addEventListener "click", (e) =>
      this._setTextureUsage 0, "Lot"
      this._setTextureUsage 1, "None"
      this._setTextureUsage 2, "None"
      this._setTextureUsage 3, "None"
      this._setTextureUsage 4, "None"
      this._setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

    document.getElementById("stormPreset").addEventListener "click", (e) =>
      this._setTextureUsage 0, "None"
      this._setTextureUsage 1, "None"
      this._setTextureUsage 2, "Lot"
      this._setTextureUsage 3, "None"
      this._setTextureUsage 4, "None"
      this._setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

    document.getElementById("boomPreset").addEventListener "click", (e) =>
      this._setTextureUsage 0, "None"
      this._setTextureUsage 1, "None"
      this._setTextureUsage 2, "Lot"
      this._setTextureUsage 3, "Few"
      this._setTextureUsage 4, "None"
      this._setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

    document.getElementById("bayPreset").addEventListener "click", (e) =>
      this._setTextureUsage 0, "None"
      this._setTextureUsage 1, "None"
      this._setTextureUsage 2, "Normal"
      this._setTextureUsage 3, "Lot"
      this._setTextureUsage 4, "Lot"
      this._setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

  _setupButtons: () =>
    el = document.getElementById("textureList")

    _.each(@textures, (texture, index) =>
      li = document.createElement("li")
      span = document.createElement("span")
      span.textContent = texture.name

      div = document.createElement("div")
      div.className = "buttons"

      btnNone = document.createElement("a")
      btnNone.setAttribute "id", "btnNone" + index
      btnNone.setAttribute "href", "#"
      btnNone.textContent = "None"
      btnNone.className = "left button"

      btnFew = document.createElement("a")
      btnFew.setAttribute "id", "btnFew" + index
      btnFew.setAttribute "href", "#"
      btnFew.textContent = "A few"
      btnFew.className = "middle button"

      btnNormal = document.createElement("a")
      btnNormal.setAttribute "id", "btnNormal" + index
      btnNormal.setAttribute "href", "#"
      btnNormal.textContent = "Some"
      btnNormal.className = "middle button"

      btnLot = document.createElement("a")
      btnLot.setAttribute "id", "btnLot" + index
      btnLot.setAttribute "href", "#"
      btnLot.textContent = "A lot"
      btnLot.className = "right button"

      ((id) =>
        btnNone.addEventListener "click", =>
          this._setTextureUsage id, "None"

        btnFew.addEventListener "click", =>
          this._setTextureUsage id, "Few"

        btnNormal.addEventListener "click", =>
          this._setTextureUsage id, "Normal"

        btnLot.addEventListener "click", =>
          this._setTextureUsage id, "Lot"

      ) index

      li.appendChild span
      div.appendChild btnNone
      div.appendChild btnFew
      div.appendChild btnNormal
      div.appendChild btnLot
      li.appendChild div
      el.appendChild li
      this._setTextureUsage index, "None"
    )

    this._setTextureUsage 0, "Lot"
    AmoebaCD.clouds.generate()

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

  _setupOtherButtons: () =>
    optionsContent = document.getElementById("optionsContent")
    el = document.getElementById("closeBtn").addEventListener("click", (e) =>
      unless optionsContent.style.display is "block"
        optionsContent.style.display = "block"
      else
        optionsContent.style.display = "none"
      e.preventDefault()
    )

