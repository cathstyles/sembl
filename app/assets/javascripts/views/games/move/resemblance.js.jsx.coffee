#= views/components/toggle_component

###* @jsx React.DOM ###

{ToggleComponent} = Sembl.Components
@Sembl.Games.Move.EditResemblance = React.createClass
  triggerChange: (description) ->
    $(window).trigger('move.resemblance.change', { link: @props.link, description: description  })

  handleChange: (event) ->
    @setState
      description: event.target.value
    $.doTimeout('timeout.move.resemblance.change', 200, @triggerChange, event.target.value);

  handleSubmit: (event) ->
    $(window).trigger('move.resemblance.close', @props.link)
    $(window).trigger(@props.toggleEvent)
    event.preventDefault()

  getInitialState: ->
    return {description: this.props.description}
  
  componentDidMount: () ->
    @refs.input.getDOMNode().focus()

  render: ->
    sourceNode = @props.link.source()
    sourcePlacement = sourceNode.get('viewable_placement')
    sourceTitle = if sourcePlacement then sourcePlacement.title else 'placeholder'
    targetNode = @props.link.target()
    targetPlacement = targetNode.get('viewable_placement')
    targetTitle = if targetPlacement then targetPlacement.title else 'placeholder'
    
    `<div className="move__resemblance__edit">
      <p>What&rsquo;s the resemblance between <strong>{sourceTitle}</strong> and <strong>{targetTitle}</strong>?</p>
      <form onSubmit={this.handleSubmit}>
        <input ref="input" type="text" onChange={this.handleChange} value={this.state.description}/>
        <button type="submit" className="move__edit__resemblance__close-button">
          <i className="fa fa-times"></i> Close
        </button>
      </form>
    </div>`

@Sembl.Games.Move.DisplayResemblance = React.createClass
  handleClick: (event, link) ->
    $(window).trigger(@props.toggleEvent)

  render: ->
    child = if @props.description 
      `<div className="graph__resemblance__filled">{this.props.description}</div>`
    else
      `<div className="graph__resemblance__empty" />`

    `<div className="move__resemblance__display" onClick={this.handleClick}>
      {child}
    </div>`

{EditResemblance, DisplayResemblance} = Sembl.Games.Move
@Sembl.Games.Move.Resemblance = React.createClass
  componentWillMount: ->
    $(window).on('move.resemblance.change', @handleResemblanceChange)

  componentWillUnmount: ->
    $(window).off('move.resemblance.change')

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
    toggle = ToggleComponent
      ref: "toggle"
      OnClass: EditResemblance
      OffClass: DisplayResemblance
      description: @state.description
      link: @props.link
      toggleEvent: 'toggle.graph.resemblance.'+@props.link.id
    `<div className="move__resemblance">
      {toggle}
    </div>`


