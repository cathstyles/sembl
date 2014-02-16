###* @jsx React.DOM ###

@Sembl.Games.Setup.Metadata = React.createClass
  className: "games-setup__metadata"
  render: () ->
    `<div className={this.className}>
      <p>TITLE AND DESCRIPTION</p>
      <div className={this.className + "__title"}>
        {this.props.title}
      </div>  
      <div className={this.className + "__description"}>
        {this.props.description}
      </div>
    </div>`
