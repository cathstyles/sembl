#= require request_animation_frame

###* @jsx React.DOM ###

@Sembl.Components.SlideViewer = React.createClass
  componentWillMount: ->
    for name in ['show', 'hide', 'setChild']
      $(window).on("slideViewer.#{name}", @handleEvent)

  componentWillUnmount: ->
    for name in ['show', 'hide', 'setChild']
      $(window).off("slideViewer.#{name}", @handleEvent)

  componentDidMount: ->
    # windowHeight = $(window).height()
    ## Margin offset + height of the "Close gallery" row
    # extraOffset = 130 + 35
    # sliderOffset = $(".slide-viewer").offset().top
    # sliderCalculation = (windowHeight - sliderOffset) + extraOffset
    # $(".slide-viewer .games__gallery").css('height', sliderCalculation)

  handleEvent: (event, data) ->
    name = event.namespace
    switch name
      when 'show' then @handleShow()
      when 'hide' then @handleHide()
      when 'setChild' then @handleSetChild(data)
      else console.error "slideviewer got event #{name}"

  handleShow: ->
    requestAnimationFrame => @setState hidden: false

  handleHide: ->
    @setState hidden: true

  doHide: (e) ->
    e?.preventDefault()
    $(window).trigger "slideViewer.hide"

  handleSetChild: (data) ->
    @setState
      child: React.addons.cloneWithProps(data.child, {})
      full: if data.full? then data.full else false


  getInitialState: ->
    hidden: true
    child: null
    full: false

  render: ->
    cx = React.addons.classSet
    className = cx (
      'slide-viewer': true,
      'slide-viewer--full': @state.full,
      'slide-viewer--active': !@state.hidden,
      'slide-viewer--hidden': @state.hidden
    )
    `<div className={className}>
      <a className="slide-viewer__close-button" onClick={this.doHide} href="#hideslide">
        <span className="slide-viewer__close-button__inner">
          <i className="fa fa-times"></i>&nbsp;Close
        </span>
      </a>
      <div className="slide-viewer__inner">
        {this.state.child}
      </div>
    </div>`
