//= require views/search_list
//= require views/search_form
/** @jsx React.DOM */
window.Sembl.SearchEdit = React.createClass({
  getInitialState: function() {
    return {
      things: [],
      query: {},
      hidden: false
    };
  },

  handleSearch: function(query) {
    var searchEdit = this;

    //TODO: Handle query errors.
    //TODO: Pagination.
    var things = $.getJSON("/search.json", query, function(data){
      searchEdit.setState({things: data});
    });
  },

  handleQueryChange: function(query) {
    var searchEdit = this;
    this.setState({query: query});
    // debounce search queries, so quick typing only does a single search at the end.
    // this differs from _.debounce in that it resets the timeout on every attempt to recall the function.
    // whereas _.debounce calls the function at least once in the timeout.
    $.doTimeout('search-query-change', 200, this.handleSearch, query);
  },

  handleToggleHidden: function() {
    this.setState({hidden : !this.state.hidden});
  },

  componentWillMount: function() {
    this.setState({hidden : this.props.hidden || false, query: this.props.query});
    this.handleSearch(this.props.query);
  },

  render: function() {
    var SearchList = Sembl.SearchList
    var SearchForm = Sembl.SearchForm
    var query_json = JSON.stringify(this.state.query);
    return (
      <div className="searchEdit">
        <input type="hidden" name={this.props.queryInputName} value={JSON.stringify(this.state.query)}/>
        <a href="#" onClick={this.handleToggleHidden}>Side/hide filter</a>
        {this.state.hidden ? null : 
          <SearchForm query={this.state.query} handleQueryChange={this.handleQueryChange} handleSearch={this.handleSearch} />
        }
        {this.state.hidden ? null : 
          <SearchList things={this.state.things} />
        }
      </div>
    );
  }
});

window.Sembl.views.searchEdit = function($el, el) {
  var query = $el.data().query;
  var hidden = $el.data().hidden;
  var queryInputName = $el.find("input").attr("name");
  React.renderComponent(Sembl.SearchEdit({query: query, hidden: hidden, queryInputName: queryInputName}), el);
};
