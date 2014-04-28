@Sembl.Utils.genUUID = ->
  time = new Date().getTime()

  uuid = 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace /[xy]/g, (char) ->
    random = (time + Math.random() * 16) % 16 | 0
    time = Math.floor(time / 16)
    (if char is 'x' then random else (random & 0x7 | 0x8)).toString(16)

  uuid

@Sembl.Utils.PROTOCOL = if document.location.protocol is 'https:' then 'https' else 'http'

String.prototype.camelToUnderscore = ->
  @replace /([a-z][A-Z])/g, (g) -> g[0] + '_' + g[1].toLowerCase()

