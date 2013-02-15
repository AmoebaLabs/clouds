class window.AmoebaCD.EffectsBase
  constructor: (parentDiv, @fps) ->
    @stopped = false
    @containerDiv = $('<div/>')
      .addClass('effectsStage')
      .appendTo(parentDiv)

    this.setup()

  setup:() =>
    console.log('subclasses should override setup')

  stop:() =>
    @stopped = true

  # subclasses must call when done
  _tearDown: () =>
    console.log('trea downn')
    setTimeout(() =>
      if not @containerDiv?
        debugger

      @containerDiv.remove()
      @containerDiv = undefined
    , 1000)

