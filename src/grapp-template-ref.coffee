Polymer

  is: 'grapp-template-ref'

  properties:
    ref: {type: String, observer: '_refChanged'}
    bind: {type: Object, observer: '_bindChanged'}
    as: {type: String, observer: '_bindChanged'}

  attached: ->
    @_stamp()

  detached: ->
    @_removeChildren()

  _refChanged: (newRef, oldRef)->
    if oldRef
      @_removeChildren()
      @_stamp()

  _bindChanged: (newBind, oldBind) ->
    if oldBind
      @_removeChildren()
      @_stamp()

  _stamp: ->
    @_parent = Polymer.dom(@).parentNode
    root = @_parent
    while Polymer.dom(root).parentNode
      root = Polymer.dom(root).parentNode
    template = Polymer.dom(root).querySelector "template##{@ref}"
    unless template
      template = document.querySelector "template##{@ref}"
    bind = {}
    if @as then bind[@as] = @bind else bind = @bind
    templateRoot = (new template.ctor(bind, template)).root
    @_children = Array.prototype.slice.call templateRoot.childNodes
    Polymer.dom(@_parent).insertBefore templateRoot, @

  _removeChildren: ->
    if @_children
      Polymer.dom(@_parent).removeChild(child) for child in @_children
