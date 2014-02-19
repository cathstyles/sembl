class Sembl.NodeEditorView extends Backbone.View
  className: "modal fade"

  template: ->
    """
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Edit node</h3>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <div class="control-group">
            <div class="control-label">Round</div>
            <div class="controls">
              <input type="text" name="round" />
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <a href="#" class="close btn">Close</a>
        <a href="#" class="save btn btn-primary">Save</a>
      </div>
    """

  events:
    "hidden": "onHidden"
    "submit form": "onSubmitForm"
    "click .save.btn": "onClickSave"
    "click .close.btn": "onClickClose"

  initialize: ->
    @$el.html(@template())
    @form = @$("form")
    @roundInput = @$(":input[name=round]")
    @listenTo @model, "change", @render
    @render()

  show: ->
    @$el.appendTo(document.body).modal("show")

  hide: ->
    @$el.modal("hide")

  render: ->
    @roundInput.val(@model.get("round"))

  onHidden: ->
    @remove()

  onSubmitForm: (event) ->
    event.preventDefault()

    @model.set(round: @roundInput.val())
    @hide()

  onClickSave: (event) ->
    event.preventDefault()

    @form.submit()

  onClickClose: (event) ->
    event.preventDefault()

    @hide()
