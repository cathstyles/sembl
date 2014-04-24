###* @jsx React.DOM ###

@Sembl.Components.SlideViewer = React.createClass
  componentWillMount: ->
    $(window).on('slideViewer.show', @handleShow)
    $(window).on('slideViewer.hide', @handleHide)

  componentWillUnmount: ->
    $(window).off('slideViewer.show', @handleShow)
    $(window).off('slideViewer.hide', @handleHide)

  handleShow: (event, child) ->
    @setState
      hidden: false

  handleHide: ->
    @setState
      hidden: true

  componentDidUpdate: ->
    for child in @props.children
      child.triggerRender()

  getInitialState: ->
    hidden: true

  render: ->
    className = "slide-viewer"
    className += " slide-viewer--hidden" if @state.hidden
    `<div className={className}>
      <div className="slide-viewer__inner">
        <span className="slide-viewer__close-button" onClick={this.handleHide}><i className="fa fa-times"></i></span>
        {this.props.children}
      </div>
    </div>`
