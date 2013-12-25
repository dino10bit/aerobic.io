###* @jsx React.DOM ###

@app.components.WorkoutComponent = React.createClass
  mixins: [@lib.BackboneMixin]

  getInitialState: ->
    checked: false

  toggleChecked: (event) ->
    event.preventDefault()
    @setState(checked: !@state.checked)
    @props.model.set(checked: !@state.checked)

  classes: ->
    React.addons.classSet
      "workouts__list__item": true
      "panel": true
      "is-checked": @state.checked

  render: ->
    checked = @state.checked
    `<li key={this.props.model.cid} className={this.classes()} onClick={this.toggleChecked}>
      <div className="panel__content">
        <input type="checkbox" checked={checked} onChange={this.toggleChecked} />
        {this.props.model.date().toString()} - {this.props.model.get('status')}
      </div>
    </li>`
