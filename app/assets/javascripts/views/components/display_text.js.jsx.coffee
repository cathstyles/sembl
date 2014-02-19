###* @jsx React.DOM ###

# Useful for when you want to value as a property instead of a child.
@Sembl.Components.DisplayText = React.createClass 
  render: () ->
    `<div className={this.props.className}>
      {this.props.value}
      {this.props.children}
    </div>`



