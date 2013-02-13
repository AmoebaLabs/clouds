#= require jquery-1.8.2
#= require underscore
#= require_self
#= require_tree ./clouds
#= require_tree ./options
#= require_tree .

window.AmoebaCD ?=
  Clouds: {}

jQuery ($) ->
  AmoebaCD.clouds = new window.AmoebaCD.Clouds()

  showUI = true

  if showUI
    AmoebaCD.options = new window.AmoebaCD.CloudOptions(AmoebaCD.clouds.textures)
  else
    AmoebaCD.clouds.generate()

  this._addClickHandlersToATags()

  # add some event listeners
  window.addEventListener "keydown", (e) =>
    switch (e.keyCode)
      when 32
        AmoebaCD.clouds.generate()
      when 67  # 'c' key
        if $("#options").css('display') is 'none'
          $("#options").css(display: "block");
        else
          $("#options").css(display: "none");
      else
        console.log(e.keyCode)

  _addClickHandlersToATags:() =>
    links = document.querySelectorAll("a[rel=external]")

    _.each(links, (a, index) =>
      a.addEventListener("click", (e) ->
        window.open @href, "_blank"
        e.preventDefault()
      )
    )




