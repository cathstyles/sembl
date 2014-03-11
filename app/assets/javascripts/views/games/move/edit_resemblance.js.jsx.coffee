###* @jsx React.DOM ###

@Sembl.Games.Move.EditResemblance = React.createClass
  triggerChange: (description)->
    $(window).trigger('move.editResemblance.change', { link: @props.link, description: description  })

  handleChange: (event)->
    $.doTimeout('timeout.move.editResemblance.change', 200, @triggerChange, event.target.value);

  handleSubmit: (event) ->
    $(window).trigger('move.editResemblance.close')
    event.preventDefault()

  getInitialState: ->
    resemblance = @props.link.get('viewable_resemblance')
    description = if !!resemblance then resemblance.description
    return {description: description}

  render: () ->
    sourceNode = @props.link.source()
    sourcePlacement = sourceNode.get('viewable_placement')
    targetNode = @props.link.target()
    targetPlacement = targetNode.get('viewable_placement')
    
    `<div className="move__edit__resemblance">
      <p>What&rsquo;s the resemblance between <strong>{sourcePlacement.title}</strong> and <strong>{targetPlacement ? targetPlacement.title : 'placeholder'}</strong>?</p>
      <form onSubmit={this.handleSubmit}>
        <input type="text" onChange={this.handleChange} value={this.state.description}/>
        <button type="submit" className="move__edit__resemblance__close-button">
          <i className="fa fa-times"></i> Close
        </button>
      </form>
    </div>`
