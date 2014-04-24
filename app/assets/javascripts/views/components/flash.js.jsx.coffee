###* @jsx React.DOM ###

@Sembl.Components.Flash = React.createClass 

  getInitialState: -> 
    {
      msg: ""
      className: "hidden"
    }

  componentWillMount: -> 
    $(window).on('flash.notice', @handleNotice)
    $(window).on('flash.error', @handleError)
    $(window).on('flash.hide', @handleHide)

  componentWillUnmount: -> 
    $(window).off('flash.notice', @handleNotice)
    $(window).off('flash.error', @handleError)
    $(window).off('flash.hide', @handleHide)

  handleNotice: (event, msg) -> 
    console.log msg
    @setState msg: msg, className: 'notice' 

  handleError: (event, msg) -> 
    @setState msg: msg, className: 'error' 
  
  handleHide: (event) ->
    @setState msg: "", className: 'hidden' 

  render: ->
    console.log "rendering notice"
    className = "flash #{this.state.className}"
    `<aside className={className}>
      {this.state.msg}
    </aside>`