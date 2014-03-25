###* @jsx React.DOM ###

@Sembl.Components.ToggleComponent = React.createClass 
  className: "toggle"

  componentDidMount: ->
    $(window).on(@props.toggleEvent, @handleToggle)

  componentWillUnmount: ->
    $(window).off(@props.toggleEvent)  

  getInitialState: () ->
    flag: @props.flag || false

  handleToggleOn: () ->
    @setState
      flag: true

  handleToggleOff: () ->
    @setState
      flag: false

  handleToggle: (event, data) ->
    flag = if (data && data.flag) then data.flag else !@state.flag
    @setState
      flag: flag
    
  render: () ->
    OnClass = @props.OnClass
    OffClass = @props.OffClass
    child =
      if @state.flag
        if OnClass
          if typeof(OnClass) == "function" then OnClass @props else OnClass
      else 
        if OffClass
          if typeof(OffClass) == "function" then OffClass @props else OffClass

    `<div className={this.className}>
      {child}
    </div>`



