#= require views/masthead/masthead
#= require views/components/modal
#= require views/components/flash

###* @jsx React.DOM ###

{Masthead} = Sembl.Masthead
{Modal, Flash} = Sembl.Components
Sembl.Layouts.Default = React.createClass 
  render: ->
    flashes = this.props.flashes

    `<div className={this.props.className}>
      <Modal />
      <Masthead>{this.props.header}</Masthead>
      <div className="content container">
        <Flash />
        {this.props.children}
      </div>
      <div className="footer container">
        <p>
          Made with ♥︎ by <a href="http://icelab.com.au">Icelab</a>
        </p>
      </div>
    </div>`



    