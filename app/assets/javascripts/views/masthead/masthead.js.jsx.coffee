###* @jsx React.DOM ###

Sembl.Masthead.Link = React.createClass
  render: ->
    url = @props.href 
    iconClassName = @props.icon
    `<li className="masthead__link">
      <i className={"masthead__link-icon fa " +iconClassName}></i>
      <a className="masthead__link-anchor" href={url}>{this.props.children}</a>
    </li>`

{Link} = Sembl.Masthead
Sembl.Masthead.Masthead = React.createClass 
  componentDidMount: ->
    # TODO: Need to call this function on every page.
    # Currently only applies to gameplay screens and not, for example, index.
    @offsetHeaderTab();

  offsetHeaderTab: ->
    headerTabWidth = $('.heading h1').outerWidth()
    $('.heading h1').css 'margin-left', ((headerTabWidth / 2) * -1) + 'px'

  render: ->
    if Sembl.user
      profile = `<Link href={Sembl.paths.edit_profile_path} icon="fa-user">Profile</Link>`
      if Sembl.user.admin
        admin = `<Link href={Sembl.paths.admin_root_path} icon="fa-cog">Admin</Link>`
      sign_out = `<Link href={Sembl.paths.destroy_user_session_path} icon="fa-power-off ">Sign out</Link>`
    else
      sign_in = `<Link href={Sembl.paths.new_user_session_path} icon="fa-key">Sign in</Link>`
      sign_up = `<Link href={Sembl.paths.new_user_registration_path} icon="fa-user">Sign up</Link>`

    `<div className="masthead">
      <a className="masthead__logo" href="/">Sembl</a>
      <div className="masthead__inner">
        <ul className="masthead__links">
          {profile}
          {admin}
          {sign_out}
          {sign_in}
          {sign_up}
        </ul>
        {this.props.children}
      </div>
    </div>`



