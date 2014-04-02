###* @jsx React.DOM ###

@Sembl.Components.Flash = React.createClass 

  getInitialState: -> 
    {
      msg: ""
      className: "hidden"
    }

  componentWillMount: -> 
    $(window).on 'flash.notice', (event, msg) => 
      @setState msg: msg, className: 'notice' 

    $(window).on 'flash.error', (event, msg) => 
      @setState msg: msg, className: 'error' 

    $(window).on 'flash.hide', (event) => 
      @setState msg: "", className: 'hidden' 

  componentWillUnmount: -> 
    $(window).off('flash.notice')
    $(window).off('flash.error')
    $(window).off('flash.hide')

  render: ->
    className = "flash #{this.state.className}"
    `<aside className={className}>
      {this.state.msg}
    </aside>`