###* @jsx React.DOM ###

@app.components.WorkoutsComponent = React.createClass
  displayName: 'app.components.WorkoutsComponent'
  propTypes:
    collection: React.PropTypes.instanceOf(app.collections.WorkoutsCollection).isRequired
    progressModel: React.PropTypes.instanceOf(app.models.ProgressModel).isRequired
    hasDeviceSelected: React.PropTypes.bool.isRequired
    deviceHasFinishedLoading: React.PropTypes.bool.isRequired

  classes: ->
    React.addons.classSet
      "workouts-list": true

  onClick: (event) ->
    event.preventDefault()
    @props.collection.uploadSelectedWorkouts()

  render: ->
    WorkoutListHeaderComponent = app.components.WorkoutListHeaderComponent
    WorkoutListComponent = app.components.WorkoutListComponent

    if @props.hasDeviceSelected and @props.deviceHasFinishedLoading
      `<div>
        <WorkoutListHeaderComponent collection={this.props.collection} onClickHandler={this.onClick} />
        <WorkoutListComponent collection={this.props.collection} />
      </div>`
    else if @props.hasDeviceSelected and not @props.deviceHasFinishedLoading
      `<div className="uploader-status-text">
        Reading workouts — hang tight!
      </div>`
    else
      `<div className="uploader-status-text">
        Select a device above to start adding workouts!
      </div>`
