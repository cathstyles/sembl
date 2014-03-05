#= require views/layouts/default
#= require views/games/rate/rate_move_view

###* @jsx React.DOM ###
{RateMoveView} = Sembl.Games.Rate
Layout = Sembl.Layouts.Default

@Sembl.Games.Rate.RatingView = React.createClass

  atMove: 0

  firstMove: -> 
    @props.moves.first

  render: ->
    `<Layout>
      <div className="rate">Rating!
        <RateMoveView move={this.firstMove} />
      </div>
    </Layout> `