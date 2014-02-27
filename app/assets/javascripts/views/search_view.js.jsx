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
    var things = $.getJSON("/api/search.json", query, function(data){
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

window.Sembl.views.searchView = function($el, el) {
  var query = $el.data().query;
  var hidden = $el.data().hidden;
  React.renderComponent(Sembl.SearchView({query: query, hidden: hidden}), el);
};
