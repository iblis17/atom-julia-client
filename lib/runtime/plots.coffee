{client} = require '../connection'
{views} = require '../ui'

{webview} = views.tags

module.exports =
  activate: ->
    client.handle
      plot: (x) => @show x
      plotsize: => @plotSize()
      ploturl: (url) => @ploturl url
    @create()

  create: ->
    @pane = @ink.PlotPane.fromId 'default'

  open: ->
    @pane.open split: 'right'

  ensureVisible: ->
    return Promise.resolve(@pane) if @pane.currentPane()
    @open()

  show: (view) ->
    @ensureVisible()
    v = views.render view
    @pane.show v
    v

  plotSize: ->
    @ensureVisible().then => @pane.size()

  ploturl: (url) ->
    v = @show webview
      class: 'blinkjl',
      src: url,
      style: 'width: 100%; height: 100%'
    v.addEventListener('console-message', (e) => console.log(e.message))
