/** @jsx React.DOM */
window.Sembl.SearchThing = React.createClass({
  render: function() {
    var thing = this.props.thing;
    return (
      <div className="searchThing">
        {thing.title}<br/>
        <img src={thing.image.url} height="200" width="200" />
      </div>
    );
  }
});

