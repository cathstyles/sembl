#= views/components/toggle_component

###* @jsx React.DOM ###

{ToggleComponent} = Sembl.Components
@Sembl.Games.Move.EditResemblance = React.createClass
  triggerChange: (description)->
    $(window).trigger('move.resemblance.change', { link: @props.link, description: description  })

  handleChange: (event)->
    @setState
      description: event.target.value
    $.doTimeout('timeout.move.resemblance.change', 200, @triggerChange, event.target.value);

  handleSubmit: (event) ->
    $(window).trigger('move.resemblance.close', @props.link)
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
  render: ->
    filled = if @props.description 
      `<div className="graph__resemblance__filled">{this.props.description}</div>`

    `<div className="move__resemblance__display">
      {filled}
    </div>`

{EditResemblance, DisplayResemblance} = Sembl.Games.Move
@Sembl.Games.Move.Resemblance = React.createClass
  componentWillMount: ->
    $(window).on('graph.resemblance.click', @handleResemblanceClick)
    $(window).on('move.resemblance.close', @handleResemblanceClose)
    $(window).on('move.resemblance.change', @handleResemblanceChange)

  componentWillUnmount: ->
    $(window).off('graph.resemblance.click')
    $(window).off('move.resemblance.close')
    $(window).off('move.resemblance.change')

  handleResemblanceClick: (event, link) ->
    if link.id == @props.link.id && @refs.toggle.state.toggle == false
      @refs.toggle.handleToggle()

  handleResemblanceChange: (event, resemblance) ->
    if resemblance.link.id == @props.link.id
      @setState
        description: resemblance.description

  handleResemblanceClose: (event, link) ->
    if link.id == @props.link.id && @refs.toggle.state.toggle == true
      @refs.toggle.handleToggleOff()

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
      onProps:
        description: @state.description
        link: @props.link
      offProps:
        description: @state.description
        link: @props.link
    `<div className="move__resemblance">
      {toggle}
    </div>`


