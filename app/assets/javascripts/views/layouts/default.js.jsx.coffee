#= require views/masthead/masthead
#= require views/components/modal
#= require views/components/flash

###* @jsx React.DOM ###

{Masthead} = Sembl.Masthead
{Modal, Flash} = Sembl.Components

Sembl.Layouts.Default = React.createClass 
  getInitialState: -> 
    newBody: null,
    body: null, 
    header: null

  render: ->
    $(window).trigger('flash.hide')

    `<div className={this.props.className}>
      <Modal />
      <Masthead>{this.state.header}</Masthead>
      <div className="content container">
        <Flash />
        {this.state.body}
      </div>
      <div className="footer container">
        <p>
          Made with ♥︎ by <a href="http://icelab.com.au">Icelab</a>
        </p>
      </div>
    </div>`

    