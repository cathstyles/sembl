#= require views/masthead/masthead
#= require views/components/modal
#= require views/components/flash
#= require views/components/slide_viewer
#= require views/utils/animation_item

###* @jsx React.DOM ###

{Masthead} = Sembl.Masthead
{Modal, Flash, SlideViewer} = Sembl.Components
{AnimationItem} = Sembl.Utils
ReactCSSTransitionGroup = React.addons.TransitionGroup

Sembl.Layouts.Default = React.createClass
  getInitialState: ->
    key = Date.now()
    body: [AnimationItem(key: "body-#{key}", prefix: "body", component: @props.body)]
    header: [AnimationItem(key: "header-#{key}", prefix: "header", component: @props.header)]
    className: null,
    key: key

  componentWillReceiveProps: (nextProps) ->
    # Push into a new array
    key = Date.now()
    @setState
      body: [AnimationItem(key: "body-#{key}", prefix: "body", component: nextProps.body)]
      header: [AnimationItem(key: "header-#{key}", prefix: "header", component: nextProps.header)]
      className: nextProps.className
      key: key
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

