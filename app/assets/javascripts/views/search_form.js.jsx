/** @jsx React.DOM */
window.Sembl.SearchForm = React.createClass({
  handleSubmit: function(event) {
    this.props.handleSearch();
    return false;
  },

  handleChange: function(event) {
    var text = this.refs.text.getDOMNode().value;
    var place_filter = this.refs.place_filter.getDOMNode().value;
    var access_filter = this.refs.access_filter.getDOMNode().value;
    var query = {text: text, place_filter: place_filter, access_filter: access_filter};
    this.props.handleQueryChange(query);
  },

  render: function() {
    var query = this.props.query;
    return (
      <div className="searchForm">
        <form onSubmit={this.handleSubmit}>
          Text: <input type="text" ref="text" value={query.text} onChange={this.handleChange} /><br/>
          Place: <input type="text" ref="place_filter" value={query.place_filter} onChange={this.handleChange} /><br/>
          Access: <input type="text" ref="access_filter" value={query.access_filter} onChange={this.handleChange} /><br/>
        </form>
      </div>
    );
  }
});
