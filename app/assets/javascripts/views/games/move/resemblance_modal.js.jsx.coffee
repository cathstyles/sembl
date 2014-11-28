###* @jsx React.DOM ###

@Sembl.Games.Move.ResemblanceModal = React.createClass
  handleSubmit: (event) ->
    newState = _.extend {}, @state
    newState["description"] = @refs.description.getDOMNode().value
    newState["target_description"] = @refs.target_description.getDOMNode().value
    newState["source_description"] = @refs.source_description.getDOMNode().value
    link = @props.link
    @setState newState
    $(window).trigger('move.resemblance.change',
      link: link
      description: newState.description
      target_description: newState.target_description
      source_description: newState.source_description
    )
    $(window).trigger('modal.close')
    event.preventDefault()

  getInitialState: ->
    description: @props.description
    target_description: @props.target_description
    source_description: @props.source_description

  componentDidMount: () ->
    @refs.description.getDOMNode().focus()

  render: ->
    sourceNode = @props.link.source()
    sourcePlacement = sourceNode.get('viewable_placement')
    sourceTitle = if sourcePlacement then sourcePlacement.title else 'placeholder'
    sourceImage = sourcePlacement.thing.image_admin_url
    targetTitle = @props.targetThing?.title || 'placeholder'
    targetImage = @props.targetThing?.image_admin_url

    `<div className="move__resemblance__edit">
      <form onSubmit={this.handleSubmit} className="move__resemblance__edit-form">
        <p>What&rsquo;s the resemblance between <strong>{sourceTitle}</strong> and <strong>{targetTitle}</strong>?</p>
        <div className="move__resemblance__nodes">
          <div className="game__placement move__resemblance__node move__resemblance__node--last">
            <img src={targetImage} alt={targetTitle} className="game__placement__image move__resemblance__node-image" />
          </div>
          <input className="move__resemblance__description" ref="description" type="text" defaultValue={this.state.description} placeholder="Enter your resemblance"/>
          <div className="game__placement move__resemblance__node">
            <img src={sourceImage} alt={sourceTitle} className="game__placement__image move__resemblance__node-image" />
          </div>
        </div>
        <div className="move__resemblance__optional">
          <p className="move__resemblance__optional-text">Optional — say more about each resemblance.</p>
          <div className="move__resemblance__optional-source">
            <input ref="source_description" type="text"  defaultValue={this.state.source_description} placeholder="Optional: Here’s why &#8230;"/>
          </div>
          <div className="move__resemblance__optional-target">
            <input ref="target_description" type="text" defaultValue={this.state.target_description} placeholder="Optional: &#8230; because &#8230;"/>
          </div>
        </div>
        <button type="submit" className="move__edit__resemblance__close-button">
          <i className="fa fa-thumbs-up"></i> Add Sembl
        </button>
      </form>
    </div>`
