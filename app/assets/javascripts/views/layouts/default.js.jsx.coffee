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
    header: null,
    className: null

  render: ->
    console.log "rendering layout"
    $(window).trigger('flash.hide')

    `<div className={this.state.className}>
      <Modal />
      <Masthead>{this.state.header}</Masthead>
      <div className="content container">
        <Flash />
        {this.state.body}
      </div>
    </div>`

    