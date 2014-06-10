###* @jsx React.DOM ###

ESC_KEY = 27

@Sembl.Components.Modal = React.createClass
  componentWillMount: ->
    $(window).on('modal.open', @handleOpen)
    $(window).on('modal.close', @handleClose)
    $('body').on('click', @handleBackgroundClick)

  componentWillUnmount: ->
    $(window).off('modal.open', @handleOpen)
    $(window).off('modal.close', @handleClose)
    $('body').off('click', @handleBackgroundClick)

  handleOpen: (event, modalChild) ->
    @setState
      modalChild: if typeof(modalChild) == "function" then modalChild() else modalChild
    $('html').addClass('modal-is-active');

  handleBackgroundClick: (event) ->
    if not $.contains(@getDOMNode(), event.target)
      @handleClose()

  handleClose: ->
    @setState
      modalChild: null
    $('html').removeClass('modal-is-active')

  getInitialState: ->
    modalChild: null

  render: ->
    if this.state.modalChild
      `<div className="modal modal--visible" onClick={this.handleClose}>
        <div className="modal__wrapper">
          <div className="modal__inner metadata-is-not-visible">
            <span className="move__thing__modal__button" onClick={this.handleClose}>
              <i className="fa fa-times"></i>
            </span>
            {this.state.modalChild}
          </div>
        </div>
      </div>`
    else
      `<div className="modal modal--hidden"/>`
