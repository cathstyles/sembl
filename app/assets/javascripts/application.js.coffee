#= require jquery
#= require jquery.color
#= require jquery.ba-dotimeout
#= require underscore
#= require backbone
#= require react
#= require react.backbone
#= require_self
#= require models/game
#= require models/user
#= require models/move
#= require routers/game_router
#= require viewloader
#= require views/uploader/contributions_view

@Sembl =
  version: "0.1"

_.extend Sembl, Backbone.Events

@Sembl.Components = @Sembl.Components || {}
@Sembl.Games = @Sembl.Games || {}
@Sembl.Games.Setup = @Sembl.Games.Setup || {}
@Sembl.Games.Gameboard = @Sembl.Games.Gameboard || {}
@Sembl.Games.Move = @Sembl.Games.Move || {}
@Sembl.Layouts = @Sembl.Layouts || {}
@Sembl.Masthead = @Sembl.Masthead || {}
@Sembl.views = @Sembl.views || {}


init = ->
  viewloader.execute Sembl.views

$(document).on("page:change", init).ready init
