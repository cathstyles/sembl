#= require views/utils/utils

class @Sembl.Handlers.TransloaditBoredInstance
  constructor: (@successCallback) ->
    @api = "#{window.Sembl.Utils.PROTOCOL}://api2.transloadit.com/"
    @getBoredInstance()

  getBoredInstance: ->
    $.ajax
      context: this
      dataType: 'jsonp'
      url: "#{@api}instances/bored?callback=?"
      success: (data) ->
        if data.error
          @getBoredInstanceAgain()
        else
          @successCallback data.api2_host
      error: ->
        @getBoredInstanceAgain()

  getBoredInstanceAgain: ->
    setTimeout @getBoredInstance, 1000 # TODO debounce

class @Sembl.Handlers.TransloaditSignature
  constructor: (@templateName, @successCallback, @postData) ->
    @getTransloaditSignature()


  getTransloaditSignature: ->
    $.ajax
      cache: false
      context: this
      data: if @postData then @postData else null
      dataType: 'json'
      type: if @postData then 'POST' else 'GET'
      url: '/transloadit_signatures/' + @templateName.camelToUnderscore()
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
      success: (data) ->
        @successCallback data

