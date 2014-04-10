###* @jsx React.DOM ###

@Sembl.Components.Tooltip = React.createClass 

  getInitialState: -> 
    {
      hidden: false
    }

  handleHide: -> 
    @setState hidden: true

  render: -> 
    hidden = if @state.hidden then "hidden" else ""

    `<div 
      className={this.props.className + " tooltip " + hidden}
      onClick={this.handleHide}>
      {this.props.children}
    </div>`
