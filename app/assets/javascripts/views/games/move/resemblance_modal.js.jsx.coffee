###* @jsx React.DOM ###

@Sembl.Games.Move.ResemblanceModal = React.createClass
  handleChange: (fieldName, event) ->
    newState = _.extend {}, @state
    newState[fieldName] = event.target.value
    link = @props.link
    @setState newState
    $.doTimeout('timeout.move.resemblance.change', 50, ->
      $(window).trigger('move.resemblance.change',
        link: link
        description: newState.description
        target_description: newState.target_description
        source_description: newState.source_description
      )
    )

  handleSubmit: (event) ->
    $(window).trigger('modal.close')
    event.preventDefault()

  getInitialState: ->
    description: @props.description
    target_description: @props.target_description
    source_description: @props.source_description

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
        <div className="game__placement move__resemblance__node move__resemblance__node--last">
          <img src={targetImage} alt={targetTitle} className="game__placement__image move__resemblance__node-image" />
        </div>
        <div className="game__placement move__resemblance__node">
          <img src={sourceImage} alt={sourceTitle} className="game__placement__image move__resemblance__node-image" />
        </div>
      </div>
      <p>What&rsquo;s the resemblance between <strong>{sourceTitle}</strong> and <strong>{targetTitle}</strong>?</p>
      <form onSubmit={this.handleSubmit} className="move__resemblance__edit-form">
        <input name="resemblance-input" ref="input" type="text" onChange={this.handleChange.bind(this, "description")} value={this.state.description}/>
        <input name="resemblance-input" ref="target_description" type="text" onChange={this.handleChange.bind(this, "target_description")} value={this.state.target_description}/>
        <input name="resemblance-input" ref="source_description" type="text" onChange={this.handleChange.bind(this, "source_description")} value={this.state.source_description}/>
        <button type="submit" className="move__edit__resemblance__close-button">
          <i className="fa fa-thumbs-up"></i> Add Sembl
        </button>
      </form>
    </div>`
