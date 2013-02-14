#= require jquery-1.8.2
#= require jquery.transit
#= require underscore
#= require_self
#= require_tree ./clouds
#= require_tree ./options
#= require_tree .

window.AmoebaCD ?=
  Clouds: {}

jQuery ($) ->
  AmoebaCD.controller = new window.AmoebaCD.CloudsController()