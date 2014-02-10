//= require views/search_row
//= require views/search_form
/** @jsx React.DOM */
window.Sembl.SearchApp = React.createClass({
  getInitialState: function() {
    return {
      things: this.props.things,
      query: {
        text: null,
        place_filter: null,
        access_filter: null
      }
    };
  },

  handleSearch: function() {
    var searchApp = this;
    var things = $.getJSON("/search.json", this.state.query, function(data){
      searchApp.setState({things: data});
    });
  },

  handleQueryChange: function(query_parameters) {
    this.setState({query: query_parameters});
  },

  render: function() {
    var row = Sembl.SearchRow({things: this.state.things});
    var form = Sembl.SearchForm({
      query: this.state.query, 
      handleQueryChange: this.handleQueryChange,
      handleSearch: this.handleSearch
    });
    return (
      <div className="searchApp">
        {form}
        {row}
      </div>
    );
  }
});
