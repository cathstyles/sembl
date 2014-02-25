Sembl.Gameboard//= require views/search_thing
/** @jsx React.DOM */
window.Sembl.SearchList = React.createClass({
  render: function() {
    var SearchThing = Sembl.SearchThing;
    var things = this.props.things.map(function (thing) {
      return <SearchThing key={thing.id} thing={thing} />
    });
    return (
      <div className="searchList">
        {things}
      </div>
    );
  }
});
