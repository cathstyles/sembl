#= require views/masthead/masthead
#= require views/components/modal
#= require views/components/flash
#= require views/components/slide_viewer
#= require views/utils/animation_item

###* @jsx React.DOM ###

{Masthead} = Sembl.Masthead
{Modal, Flash, SlideViewer} = Sembl.Components
{AnimationItem} = Sembl.Utils
ReactTransitionGroup = React.addons.TransitionGroup

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
        <ReactTransitionGroup transitionName="header">
          {this.state.header}
        </ReactTransitionGroup>
      </Masthead>
      <div className="main">
        <div className="content container">
          <Flash />
          <ReactTransitionGroup transitionName="body">
            {this.state.body}
          </ReactTransitionGroup>
        </div>
        <SlideViewer />
      </div>
    </div>`

