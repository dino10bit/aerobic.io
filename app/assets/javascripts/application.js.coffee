#= require vendor
#= require app
#= require_tree ./lib
#= require_tree ./config
#= require application/controllers/view_controller
#= require_tree ./application/models
#= require_tree ./application/collections
#= require_tree ./application/components
#= require_tree ./application/controllers

$ ->
  new app.controllers.NprogressController(el: $(document))
