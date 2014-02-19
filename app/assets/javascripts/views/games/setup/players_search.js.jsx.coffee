###* @jsx React.DOM ###

@Sembl.Games.Setup.PlayersSearch = React.createClass
  className: "games-setup__select-players-search"

  getInitialState: () ->
    query: ""
    users: []

  handleSearch: (event) ->
    playersSearch = this
    query_params = { type: "user", email: event.target.value}
    $.getJSON("/search.json", query_params, (data) ->
      playersSearch.setState({users: data});
    )
    event.preventDefault()

  render: () ->
    active_search = true
    users = this.state.users.map (user) ->
      `<div>{user.email}</div>`

    `<div className={this.className}>
      <input type="text" />
      <div>
        {active_search ? users : null}
      </div>
    </div>`

