###* @jsx React.DOM ###

@Sembl.Games.Setup.Filter = React.createClass
  className: "games-setup__filter"

  handleChange: (event) ->
    filter = 
      text: this.refs.text.getDOMNode().value;
      place_filter: this.refs.place_filter.getDOMNode().value;
      access_filter: this.refs.access_filter.getDOMNode().value
    if this.props.requests && this.props.requests.requestFilterChange
      this.props.requests.requestFilterChange(filter)
    console.log "filter", filter
    $(window).trigger("filter:update", filter)
    event.preventDefault()

  render: () ->
    filter = this.props.filter;
    filter = 
      text: "bla"
      place_filter: "bla1"
      access_filter: "bla2"

    `<div className={this.className}>
      Text: <input type="text" ref="text" value={filter.text} onChange={this.handleChange} /><br/>
      Place: <input type="text" ref="place_filter" value={filter.place_filter} onChange={this.handleChange} /><br/>
      Access: <input type="text" ref="access_filter" value={filter.access_filter} onChange={this.handleChange} /><br/>
    </div>`