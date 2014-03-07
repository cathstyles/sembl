###* @jsx React.DOM ###

@Sembl.Games.Move.EditResemblance = React.createClass
  triggerChange: (description)->
    $(window).trigger('move.editResemblance.change', { link: @props.link, description: description  })

  handleChange: (event)->
    $.doTimeout('timeout.move.editResemblance.change', 200, @triggerChange, event.target.value);

  render: () ->
    sourceNode = @props.link.source()
    sourcePlacement = sourceNode.get('viewable_placement')
    targetNode = @props.link.target()
    targetPlacement = targetNode.get('viewable_placement')
    `<div className="move__edit__resemblance">
      <p>What's the resemblance between {sourcePlacement.title} and {targetPlacement ? targetPlacement.title : 'placeholder'}?</p>
      <input type="text" onChange={this.handleChange}/>
      <button>Close</button>
    </div>`
