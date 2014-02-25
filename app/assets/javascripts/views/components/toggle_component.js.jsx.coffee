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

  handleToggle: () ->
    this.setState
      toggle: !this.state.toggle


  render: () ->
    OnClass = this.props.OnClass
    OffClass = this.props.OffClass
    
    child =
      if this.state.toggle
        if OnClass
          OnClass this.props.onProps
      else 
        if OffClass
          OffClass this.props.offProps

    `<div className={this.className}>
      {child}
    </div>`



