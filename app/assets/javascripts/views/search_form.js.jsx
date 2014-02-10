/** @jsx React.DOM */
window.Sembl.SearchForm = React.createClass({
  handleSubmit: function(event) {
    this.props.handleSearch();
    return false;
  },

  handleChange: function(event) {
    var text = this.refs.text.getDOMNode().value.trim();
    var place_filter = this.refs.place_filter.getDOMNode().value.trim();
    var access_filter = this.refs.access_filter.getDOMNode().value.trim();
    this.props.handleQueryChange({text: text, place_filter: place_filter, access_filter: access_filter});
  },

  render: function() {
    var query = this.props.query;
    console.log(query);
    return (
      <div className="searchForm">
        <form onSubmit={this.handleSubmit}>
          Text: <input type="text" ref="text" value={query.text} onChange={this.handleChange} /><br/>
          Place: <input type="text" ref="place_filter" value={query.place_filter} onChange={this.handleChange} /><br/>
          Access: <input type="text" ref="access_filter" value={query.access_filter} onChange={this.handleChange} /><br/>
          <input type="submit" value="Submit"/>
        </form>
      </div>
    );
  }
});
