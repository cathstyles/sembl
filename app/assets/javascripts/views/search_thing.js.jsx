/** @jsx React.DOM */
window.Sembl.SearchThing = React.createClass({
  getInitialState: function() {
    return {
      selected: false
    };
  },

  handleSelect: function(event) {
    this.setState({selected: !this.state.selected})
  },

  render: function() {
    var thing = this.props.thing;
    var classString = this.state.selected ? 'searchThing selected' : 'searchThing';
    return (
      <div className={classString}>
        {thing.title}<br/>
        <img src={thing.image.url} height="200" width="200" onClick={this.handleSelect} />
      </div>
    );
  }
});

