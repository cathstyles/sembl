###* @jsx React.DOM ###

{ResemblanceModal} = Sembl.Games.Move
@Sembl.Games.Move.Resemblance = React.createClass
  componentWillMount: ->
    $(window).on('move.resemblance.change', @handleResemblanceChange)

  componentWillUnmount: ->
    $(window).off('move.resemblance.change')

  handleClick: (event, link) ->
    $(window).trigger('move.resemblance.click', {link: @props.link, description: @state.description})

  handleResemblanceChange: (event, resemblance) ->
    if resemblance.link.id == @props.link.id
      @setState
        description: resemblance.description

  getInitialState: ->
    link = @props.link
    resemblance = link.get('viewable_resemblance')
    description = if !!resemblance then resemblance.description
    state = {description: description}

  render: () ->
    toggleEvent = 'toggle.graph.resemblance.'+@props.link.id

    child = if @state.description 
      `<div className="graph__resemblance__expanded">{this.state.description}</div>`
    else
      `<div className="graph__resemblance__empty" />`

    `<div className="move__resemblance" onClick={this.handleClick}>
      {child}
    </div>`

