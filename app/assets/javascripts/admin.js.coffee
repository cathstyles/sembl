#= require jquery
#= require jquery_ujs
#= require underscore
#= require bootstrap
#= require d3


$ ->
  if (form = $(".admin-boards .simple_form")).length
    input = $(":input[name='board[game_attributes]']")
    board = $(".game-board")

    width = board.width()
    height = board.height()

    newLinkSource = null

    sanitize = (game) ->
      # Make sure both collections are present
      game.nodes ||= []
      game.links ||= []

      # Pre-populate node positions at center of the board
      for node in game.nodes when not (node.x and node.y)
        node.x = width / 2
        node.y = height / 2

      # Links between non-existent nodes break d3
      game.links = (link for link in game.links when game.nodes[link.source] and game.nodes[link.target])

      game

    # Click on the game board creates a node
    clickBoard = ->
      if d3.event.toElement is this
        if newLinkSource
          cancelLink()
        else
          point = d3.mouse(this)
          game.nodes.push x: point[0], y: point[1], round: "0"
          update()

    # Creates an SVG canvas
    svg = d3.select(board.empty()[0]).append("svg")
      .attr("viewBox", "0 0 #{width} #{height}")
      .attr("preserveAspectRatio", "xMidYMid meet")
      .on("click", clickBoard)

    # Keep the SVG the same size as its container
    $(window).on "resize", ->
      svg.attr("viewBox", "0 0 #{board.width()} #{board.height()}")

    # Parse the initial game state, or fall back to an empty board
    try
      game = sanitize(JSON.parse(input.val()))
    catch e
      console?.log e
      game = nodes: [{x: width / 2, y: height / 2, round: 0}], links: []

    drag = d3.behavior.drag()
      # Dragging a ndoe changes its position
      .on "dragstart", ->
        d3.select(this).classed("dragging", true)
      .on "drag", (d) ->
        [d.x, d.y] = d3.mouse(this)
        update()
      .on "dragend", ->
        d3.select(this).classed("dragging", false)

    # Click on a node starts a link
    clickNode = (d) ->
      unless d3.event?.defaultPrevented
        thisSelector = d3.select(this)
        thisIndex = _(game.nodes).indexOf(thisSelector.datum())

        if newLinkSource
          newLinkSourceSelector = d3.select(newLinkSource)
          newLinkSourceIndex = _(game.nodes).indexOf(d3.select(newLinkSource).datum())

        if not newLinkSource
          newLinkSource = this
          thisSelector.classed("new-link-source-node", true)
        else if newLinkSource is this
          cancelLink()
        else if (index = existingLinkIndex(newLinkSourceIndex, thisIndex)) isnt -1
          game.links.splice(index, 1)
          update()
          cancelLink()
        else if newLinkSource and this
          game.links.push source: newLinkSourceIndex, target: thisIndex
          update()
          cancelLink()

    existingLinkIndex = (oneIndex, twoIndex) ->
      for link, index in game.links
        return index if (link.source is oneIndex and link.target is twoIndex) or
          (link.target is oneIndex and link.source is twoIndex)
      -1

    cancelLink = ->
      if newLinkSource
        d3.select(newLinkSource).classed("new-link-source-node", false)
        newLinkSource = null

    # Double click on a node edits the node
    doubleClickNode = (d) ->
      cancelLink()
      d3.event.stopPropagation()
      if newRound = prompt "Round", d.round
        d3.select(this).datum().round = newRound
        update()

    # Right-click on a node removes the node
    rightClickNode = (d) ->
      d3.event.preventDefault()

      removeIndex = _(game.nodes).indexOf(d)

      game.nodes.splice(removeIndex, 1)

      for link, index in game.links
        if link.source is removeIndex or link.target is removeIndex
          game.links.splice(index, 1)
        else
          link.source -= 1 if link.source > removeIndex
          link.target -= 1 if link.target > removeIndex

      update()

    # Update the whole visualisation
    update = ->
      # Grab the existing links and nodes, populate with new data
      link = svg.selectAll(".link").data(game.links)
      nodeGroups = svg.selectAll(".node-group").data(game.nodes)

      ## Links

      # Enter
      link.enter().insert("line", ".node-group").attr("class", "link")

      # Exit
      link.exit().remove()

      # Update
      link
        .attr("x1", (d) -> game.nodes[d.source].x)
        .attr("y1", (d) -> game.nodes[d.source].y)
        .attr("x2", (d) -> game.nodes[d.target].x)
        .attr("y2", (d) -> game.nodes[d.target].y)

      ## Nodes

      # Enter
      nodeGroupsEnter = nodeGroups.enter()
        .append("g")
          .attr("class", "node-group")
      nodeGroupsEnter.append("circle")
        .attr("class", "node")
        .attr("r", 30)
      nodeGroupsEnter.append("text")
        .attr("class", "label")
      nodeGroupsEnter.call(drag)
        .on("click", clickNode)
        .on("dblclick", doubleClickNode)
        .on("contextmenu", rightClickNode)

      # Exit
      nodeGroups.exit().remove()

      # Update
      nodeGroups
        # Propegate data out to children
        .each (datum) ->
          d3.select(this).selectAll(".node, .label").datum(datum)
      # Then update positioning
      nodeGroups.selectAll(".node")
        .attr("cx", (d) -> d.x)
        .attr("cy", (d) -> d.y)
      nodeGroups.selectAll(".label")
        .attr("x", (d) -> d.x)
        .attr("y", (d) -> d.y + 8)
        .text((d) -> d.round)

      unless input.is(":focus")
        input.val(JSON.stringify(game))

    updateFromInput = ->
      try
        parsedGame = sanitize JSON.parse input.val()
      catch e
        console?.log e

      if parsedGame
        game = parsedGame
        update()

    input.on input: updateFromInput

    updateFromInput()
