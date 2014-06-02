class PageTitle
  baseTitle: "— Sembl"
  set: (pageTitle) ->
    document.title = "#{pageTitle} #{@baseTitle}"

@Sembl.Utils.PageTitle = new PageTitle()
