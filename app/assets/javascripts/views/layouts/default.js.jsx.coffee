#= require views/masthead/masthead
#= require views/components/modal
#= require views/components/flash
#= require views/components/slide_viewer

###* @jsx React.DOM ###

{Masthead} = Sembl.Masthead
{Modal, Flash, SlideViewer} = Sembl.Components
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

Sembl.Layouts.Default = React.createClass
  getInitialState: ->
    key = Date.now()
    body: [@wrapWithDiv(@props.body, "body", key)],
    header: [@wrapWithDiv(@props.header, "header", key)],
    className: null,
    key: key

  componentWillReceiveProps: (nextProps) ->
    # Push into a new array
    key = Date.now()
    @setState
      body: [@wrapWithDiv(nextProps.body, "body", key)]
      header: [@wrapWithDiv(nextProps.header, "header", key)]
      className: nextProps.className
      key: key

  wrapWithDiv: (component, prefix, key) ->
    key = key || this.state.key
    `<div className="animation-wrapper" key={prefix + '-' + key}>{component}</div>`

  render: ->
    console.log 'clear flash message on layout render'
    $(window).trigger('flash.hide')

    `<div className={this.state.className}>
      <Modal />
      <Masthead>
        <ReactCSSTransitionGroup transitionName="header">
          {this.state.header}
        </ReactCSSTransitionGroup>
      </Masthead>
      <div className="content container">
        <Flash />
        <ReactCSSTransitionGroup transitionName="body">
          {this.state.body}
        </ReactCSSTransitionGroup>
      </div>
      <SlideViewer />
    </div>`

