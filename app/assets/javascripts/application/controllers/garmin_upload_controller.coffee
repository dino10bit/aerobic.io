@app.controllers.GarminUploadController = class GarminUploadController extends app.controllers.ViewController
  el: "#GarminUploadController"

  initialize: (options) ->
    @options = _(options).defaults({})

    @initializeData()
    @initializeViews()
    @initializeGarmin()

    @garminUploadComponent.setState(garminIsInstalled: @garmin.isInstalled())

    # TODO: this should be refactored to some sort of promise based intitialser,
    # something along the lines of this:
    #
    # `@garmin.initialize.then(=> @fetchDevices())`
    #
    # Currently there is a race condition that exists in the setup of the garmin
    # communicator code that means that it is possible that we may start attempting
    # to invoke methods on the plugin proxy before it has been created.
    #
    # Wrapping up the initialization stuff in a promise would mean that would be a
    # lot nicer.
    @fetchDevices()

  initializeGarmin: ->
    @garmin = new Garmin(@options.garmin)

  initializeData: ->
    @devicesCollection = new app.collections.DevicesCollection([], garminDelegate: @garmin)
    @workoutsCollection = new app.collections.WorkoutsCollection([], uploadPath: @options.uploadPath)
    @exitstingWorkoutsCollection = new app.collections.WorkoutsCollection([])
    @exitstingWorkoutsCollection.reset(@options.existingMemberWorkouts)
    @progressModel = new app.models.ProgressModel()

  initializeViews: ->
    @garminUploadComponent = app.components.GarminUploadComponent(
      devicesCollection: @devicesCollection
      workoutsCollection: @workoutsCollection
      progressModel: @progressModel
      onDeviceSelectDelegate: @onDeviceSelect
      onDeviceUnselectDelegate: @onDeviceUnselect
    )
    React.renderComponent(@garminUploadComponent, document.getElementById("GarminUpload"))

  fetchDevices: ->
    @garmin.devices()
      .then (devices) =>
        @devicesCollection.reset(devices)
        @garminUploadComponent.setState(isInitializing: false)

  onDeviceSelect: (device) =>
    @progressModel.set(@progressModel.defaults)
    @garminUploadComponent.setState(hasDeviceSelected: true, deviceHasFinishedLoading: false)
    @workoutsCollection.fetch(device)
      .progress(@_updateProgress)
      .then(@_updateWorkoutCollectionWithExistingWorkouts.bind(@, device.get('id')))
      .finally(=>
        @garminUploadComponent.setState(hasDeviceSelected: true, deviceHasFinishedLoading: true)
      )

  onDeviceUnselect: =>
    @progressModel.set(@progressModel.defaults)
    @garminUploadComponent.setState(hasDeviceSelected: false, deviceHasFinishedLoading: false)
    @workoutsCollection.reset([])

  _updateProgress: (progress) =>
    unless progress.percent is @progressModel.get('percent')
      @progressModel.set(progress)
      @_lastProgressPercentage = progress.percent

  _updateWorkoutCollectionWithExistingWorkouts: (deviceId) ->
    workoutsCollectionClone = @workoutsCollection.clone()
    @exitstingWorkoutsCollection.getWorkoutsForDeviceId(deviceId).map (existingWorkout) =>
      workout = workoutsCollectionClone.get(existingWorkout.get('device_workout_id'))
      workoutIndex = workoutsCollectionClone.indexOf(workout)
      workoutsCollectionClone.remove(workout)
    @workoutsCollection.reset(workoutsCollectionClone.models)
