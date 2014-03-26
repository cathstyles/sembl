###* @jsx React.DOM ###

@Sembl.Games.Move.ResemblanceModal = React.createClass
  handleChange: (event) ->
    description = event.target.value
    link = @props.link
    @setState
      description: description
    $.doTimeout('timeout.move.resemblance.change', 50, ->
      $(window).trigger('move.resemblance.change', { link: link, description: description})
    )

  handleSubmit: (event) ->
    $(window).trigger('modal.close')
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
      <form onSubmit={this.handleSubmit} className="move__resemblance__edit-form">
        <input ref="input" type="text" onChange={this.handleChange} value={this.state.description}/>
        <button type="submit" className="move__edit__resemblance__close-button">
          <i className="fa fa-thumbs-up"></i> Add Sembl
        </button>
      </form>
    </div>`
