###* @jsx React.DOM ###

@Sembl.Components.Tooltip = React.createClass

  getInitialState: ->
    hidden: false

  handleHide: (event) ->
    event.preventDefault()
    @setState hidden: true

  render: ->
    hidden = if @state.hidden then "hidden" else ""

    `<a
      href="#tooltop"
      className={this.props.className + " tooltip " + hidden}
      onClick={this.handleHide}>
      <div className="tooltip__inner">{this.props.children}</div>
    </a>`
