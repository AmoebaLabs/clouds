class window.AmoebaCD.EffectsBase
  constructor: (parentDiv, @fps) ->
    @stopped = false
    @numExpectedCallbacks = 0

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
    setTimeout(() =>
      @containerDiv.remove()
      @containerDiv = undefined
    , 1000)

