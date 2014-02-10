//= require views/search_thing
/** @jsx React.DOM */
window.Sembl.SearchRow = React.createClass({
  render: function() {
    props = this.props
    var things = this.props.things.map(function (thing) {
      return Sembl.SearchThing( {key:thing.id, thing:thing} )
    });
    return (
      <div className="searchRow">
        {things}
      </div>
    );
  }
});
