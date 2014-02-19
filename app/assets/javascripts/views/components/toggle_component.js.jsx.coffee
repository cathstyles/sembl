#= require views/components/autofocus_input
###* @jsx React.DOM ###

@Sembl.Components.ToggleComponent = React.createClass 
  className: "toggle-component"

  getInitialState: () ->
    _.extend {toggle: false}

  handleToggleOn: () ->
    this.setState
      toggle: true

  handleToggleOff: () ->
    this.setState
      toggle: false

  render: () ->
    OnClass = this.props.OnClass
    OffClass = this.props.OffClass
    
    child =
      if this.state.toggle
      then OnClass this.props.onProps
      else OffClass this.props.offProps

    `<div className={this.className}>
      {child}
    </div>`



