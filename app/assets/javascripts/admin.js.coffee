#= stub application

#= require jquery

#= require models/board
#= require views/board_view

$ ->
  if $(document.body).is(".admin-boards-new, .admin-boards-create, .admin-boards-edit, .admin-boards-update, .admin-games-new, .admin-games-create, .admin-games-edit, .admin-games-update")
    board = $(".game-board")
    input = $(":input[name='#{board.data("input")}']")
    form = input.parents("form")

    try
      attributes = JSON.parse(input.val())
    catch
      attributes = {}

    Sembl.board = new Sembl.Board(attributes)
    Sembl.boardView = new Sembl.BoardView(el: board, model: Sembl.board)

    reallyUpdateInput = ->
      input.val(JSON.stringify(Sembl.board))

    form.submit ->
      reallyUpdateInput()

    updateInput = ->
      unless input.is(":focus")
        reallyUpdateInput()

    Sembl.board.on "change", updateInput
    Sembl.board.nodes.on "change", updateInput
    Sembl.board.links.on "change", updateInput

    input.on "input", ->
      try
        json = JSON.parse(input.val())
      catch
        return

      Sembl.board.nodes.set(json.nodes)
      Sembl.board.links.set(json.links)
