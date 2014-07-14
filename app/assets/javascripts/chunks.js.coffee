class @PendingChunkObserver
  constructor: (@link) ->

  json_url: ->
    "#{@link}.json"

  auto_reload: ->
    setInterval @reload, 5 * 1000

  reload: =>
    $.ajax(method: 'get', dataType : 'json', url: @json_url()).done(@display)

  display: (attributes) ->
    if attributes.completion_rate >= 1
      window.location = window.location

jQuery ->
  $('body.chunks .download-pending.chunk').each (index, pending_link) ->
    new PendingChunkObserver(pending_link.href).auto_reload()
