#= stub application

#= require jquery
#= require jquery_ujs
#= require bootstrap

#= require raphael
#= require backbone-raphael
#= require models/board
#= require views/board_view

$ ->
  if $(document.body).is(".admin-boards-new, .admin-boards-create, .admin-boards-edit, .admin-boards-update, .admin-games-new, .admin-games-create, .admin-games-edit, .admin-games-update")
    board = $(".game-board")
    form = board.closest("form")

    nodesInput = form.find(":input[name$=\"[nodes_attributes]\"]")
    linksInput = form.find(":input[name$=\"[links_attributes]\"]")

    nodesAttributes = try
      JSON.parse(nodesInput.val())
    catch
      {}
    linksAttributes = try
      JSON.parse(linksInput.val())
    catch
      {}

    Sembl.board = new Sembl.Board(nodes: nodesAttributes, links: linksAttributes)
    Sembl.boardView = new Sembl.BoardView(el: board, model: Sembl.board)

    updateNodesInput = ->
      nodesInput.val(JSON.stringify(Sembl.board.nodes.toJSON()))
    updateLinksInput = ->
      linksInput.val(JSON.stringify(Sembl.board.links.toJSON()))

    form.submit ->
      updateNodesInput()
      updateLinksInput()

    Sembl.board.nodes.on "add change remove", ->
      unless nodesInput.is(":focus")
        updateNodesInput()
    Sembl.board.links.on "add change remove", ->
      unless linksInput.is(":focus")
        updateLinksInput()

    nodesInput.on "input", ->
      try
        json = JSON.parse(nodesInput.val())
      catch
        return
      Sembl.board.nodes.set(json)
    linksInput.on "input", ->
      try
        json = JSON.parse(linksInput.val())
      catch
        return
      Sembl.board.links.set(json)
