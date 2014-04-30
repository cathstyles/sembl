#= require react
#= require jquery
#= require views/utils/transition_ender

###* @jsx React.DOM ###

@Sembl.Utils.AnimationItem = React.createClass
  componentWillEnter: (done) ->
    @$el = $(@getDOMNode())
    @$el.addClass("#{@props.prefix}-enter")

    setTimeout =>
      @$el.addClass("#{@props.prefix}-enter-active")
      new Sembl.Utils.TransitionEnder(@$el, done)
    , 0
  componentDidEnter: ->
    @$el
      .removeClass("#{@props.prefix}-enter")
      .removeClass("#{@props.prefix}-enter-active")

  componentWillLeave: (done) ->
    @$el = $(@getDOMNode())
    @$el.addClass("#{@props.prefix}-leave")
    setTimeout =>
      @$el.addClass("#{@props.prefix}-leave-active")
      new Sembl.Utils.TransitionEnder(@$el, done)
    , 0
  componentDidLeave: ->
    @$el
      .removeClass("#{@props.prefix}-leave")
      .removeClass("#{@props.prefix}-leave-active")
  render: ->
    `<div className="animation-item" key={this.props.key}>{this.props.component}</div>`
