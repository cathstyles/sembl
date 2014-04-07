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
    return {description: @props.description}
  
  componentDidMount: () ->
    @refs.input.getDOMNode().focus()

  render: ->
    sourceNode = @props.link.source()
    sourcePlacement = sourceNode.get('viewable_placement')
    sourceTitle = if sourcePlacement then sourcePlacement.title else 'placeholder'
    sourceImage = sourcePlacement.thing.image_admin_url
    targetTitle = @props.targetThing?.title || 'placeholder'
    targetImage = @props.targetThing?.image_admin_url
    
    `<div className="move__resemblance__edit">
      <div className="move__resemblance__nodes">
        <div className="graph__node move__resemblance__node">
          <img src={sourceImage} alt={sourceTitle} className="graph__node__image move__resemblance__node-image" />
        </div>
        <div className="graph__node move__resemblance__node move__resemblance__node--last">
          <img src={targetImage} alt={targetTitle} className="graph__node__image move__resemblance__node-image" />
        </div>
      </div>
      <p>What&rsquo;s the resemblance between <strong>{sourceTitle}</strong> and <strong>{targetTitle}</strong>?</p>
      <form onSubmit={this.handleSubmit} className="move__resemblance__edit-form">
        <input ref="input" type="text" onChange={this.handleChange} value={this.state.description}/>
        <button type="submit" className="move__edit__resemblance__close-button">
          <i className="fa fa-thumbs-up"></i> Add Sembl
        </button>
      </form>
    </div>`
