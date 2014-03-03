###* @jsx React.DOM ###

@Sembl.Games.Setup.Filter = React.createClass
  className: "games-setup__filter"

  getInitialState: () ->
    filter:
      text: this.props.filter.text
      place_filter: this.props.filter.place_filter
      access_filter: this.props.filter.access_filter

  handleChange: (event) ->
    filter = 
      text: this.refs.text.getDOMNode().value || null;
      place_filter: this.refs.place_filter.getDOMNode().value || null
      access_filter: this.refs.access_filter.getDOMNode().value || null
    this.setState
      filter: filter
    $(window).trigger("sembl.filter.change", filter)
    event.preventDefault()

  render: () ->
    filter = this.state.filter;
    `<div className={this.className}>
      Text: <input type="text" ref="text" value={filter.text} onChange={this.handleChange} /><br/>
      Place: <input type="text" ref="place_filter" value={filter.place_filter} onChange={this.handleChange} /><br/>
      Access: <input type="text" ref="access_filter" value={filter.access_filter} onChange={this.handleChange} /><br/>
    </div>`