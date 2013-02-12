
class window.AmoebaCD.CloudOptions
  constructor:(@textures) ->
    this.setup()

  setup: () =>
    setTextureUsage = (id, mode) =>
      modes = ["None", "Few", "Normal", "Lot"]
      weights =
        None: 0
        Few: .3
        Normal: .7
        Lot: 1

      j = 0

      while j < modes.length
        el = document.getElementById("btn" + modes[j] + id)
        el.className = el.className.replace(" active", "")
        if modes[j] is mode
          el.className += " active"
          @textures[id].weight = weights[mode]
        j++
    el = document.getElementById("textureList")
    j = 0

    while j < @textures.length
      li = document.createElement("li")
      span = document.createElement("span")
      span.textContent = @textures[j].name
      div = document.createElement("div")
      div.className = "buttons"
      btnNone = document.createElement("a")
      btnNone.setAttribute "id", "btnNone" + j
      btnNone.setAttribute "href", "#"
      btnNone.textContent = "None"
      btnNone.className = "left button"
      btnFew = document.createElement("a")
      btnFew.setAttribute "id", "btnFew" + j
      btnFew.setAttribute "href", "#"
      btnFew.textContent = "A few"
      btnFew.className = "middle button"
      btnNormal = document.createElement("a")
      btnNormal.setAttribute "id", "btnNormal" + j
      btnNormal.setAttribute "href", "#"
      btnNormal.textContent = "Some"
      btnNormal.className = "middle button"
      btnLot = document.createElement("a")
      btnLot.setAttribute "id", "btnLot" + j
      btnLot.setAttribute "href", "#"
      btnLot.textContent = "A lot"
      btnLot.className = "right button"
      ((id) ->
        btnNone.addEventListener "click", ->
          setTextureUsage id, "None"

        btnFew.addEventListener "click", ->
          setTextureUsage id, "Few"

        btnNormal.addEventListener "click", ->
          setTextureUsage id, "Normal"

        btnLot.addEventListener "click", ->
          setTextureUsage id, "Lot"

      ) j
      li.appendChild span
      div.appendChild btnNone
      div.appendChild btnFew
      div.appendChild btnNormal
      div.appendChild btnLot
      li.appendChild div
      el.appendChild li
      setTextureUsage j, "None"
      j++
    setTextureUsage 0, "Lot"
    AmoebaCD.clouds.generate()
    document.getElementById("cloudsPreset").addEventListener "click", (e) ->
      setTextureUsage 0, "Lot"
      setTextureUsage 1, "None"
      setTextureUsage 2, "None"
      setTextureUsage 3, "None"
      setTextureUsage 4, "None"
      setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

    document.getElementById("stormPreset").addEventListener "click", (e) ->
      setTextureUsage 0, "None"
      setTextureUsage 1, "None"
      setTextureUsage 2, "Lot"
      setTextureUsage 3, "None"
      setTextureUsage 4, "None"
      setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

    document.getElementById("boomPreset").addEventListener "click", (e) ->
      setTextureUsage 0, "None"
      setTextureUsage 1, "None"
      setTextureUsage 2, "Lot"
      setTextureUsage 3, "Few"
      setTextureUsage 4, "None"
      setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

    document.getElementById("bayPreset").addEventListener "click", (e) ->
      setTextureUsage 0, "None"
      setTextureUsage 1, "None"
      setTextureUsage 2, "Normal"
      setTextureUsage 3, "Lot"
      setTextureUsage 4, "Lot"
      setTextureUsage 5, "None"
      AmoebaCD.clouds.generate()
      e.preventDefault()

    optionsContent = document.getElementById("optionsContent")
    el = document.getElementById("closeBtn").addEventListener("click", (e) ->
      unless optionsContent.style.display is "block"
        optionsContent.style.display = "block"
      else
        optionsContent.style.display = "none"
      e.preventDefault()
    )
    textureControls = document.getElementById("textureControls")
    el = document.getElementById("showTextureControlsBtn").addEventListener("click", (e) ->
      unless textureControls.style.display is "block"
        textureControls.style.display = "block"
      else
        textureControls.style.display = "none"
      e.preventDefault()
    )
    el = document.getElementById("fullscreenBtn")
    if el
      options = document.getElementById("options")
      el.addEventListener "click", ((e) ->
        if document.body.webkitRequestFullScreen
          document.body.onwebkitfullscreenchange = (e) ->

            #    options.style.display = 'none';
            document.body.style.width = window.innerWidth + "px"
            document.body.style.height = window.innerHeight + "px"
            document.body.onwebkitfullscreenchange = ->


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
