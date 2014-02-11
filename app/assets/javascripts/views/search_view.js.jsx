//= require views/search_list
/** @jsx React.DOM */
window.Sembl.SearchView = React.createClass({
  getInitialState: function() {
    return {
      things: []
    };
  },

  handleSearch: function() {
    var searchView = this;
    var query = this.props.query
    var things = $.getJSON("/search.json", query, function(data){
      searchView.setState({things: data});
    });
  },

  componentWillMount: function() {
    this.handleSearch();
  },

  render: function() {
    var SearchList = Sembl.SearchList
    return (
      <div className="searchView">
        <SearchList things={this.state.things} selected={this.state.things} />
      </div>
    );
  }
});
