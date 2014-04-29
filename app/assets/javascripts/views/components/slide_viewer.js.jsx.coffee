###* @jsx React.DOM ###

@Sembl.Components.SlideViewer = React.createClass
  componentWillMount: ->
    for name in ['show', 'hide', 'setChild']
      $(window).on("slideViewer.#{name}", @handleEvent)

  componentWillUnmount: ->
    for name in ['show', 'hide', 'setChild']
      $(window).off("slideViewer.#{name}", @handleEvent)

  componentDidMount: ->
    windowHeight = $(window).height()
    # Margin offset + height of the "Close gallery" row
    extraOffset = 130 + 35
    sliderOffset = $(".slide-viewer").offset().top
    sliderCalculation = (windowHeight - sliderOffset) + extraOffset
    $(".slide-viewer .games__gallery").css('height', sliderCalculation)

  handleEvent: (event, data) ->
    name = event.namespace
    switch name
      when 'show' then @handleShow()
      when 'hide' then @handleHide()
      when 'setChild' then @handleSetChild(data)
      else console.error "slideviewer got event #{name}"

  handleShow: ->
    @setState hidden: false

  handleHide: ->
    @setState hidden: true

  handleSetChild: (child) ->
    @setState child: React.addons.cloneWithProps(child, {})

  getInitialState: ->
    hidden: true
    child: null

  render: ->
    cx = React.addons.classSet
    className = cx (
      'slide-viewer': true,
      'slide-viewer--active': !@state.hidden,
      'slide-viewer--hidden': @state.hidden
    )
    `<div className={className}>
      <div className="slide-viewer__inner">
        <span className="slide-viewer__close-button" onClick={this.handleHide}>
          <span className="slide-viewer__close-button__inner">
            <i className="fa fa-times"></i>&nbsp;Hide the gallery
          </span>
        </span>
        {this.state.child}
      </div>
    </div>`
