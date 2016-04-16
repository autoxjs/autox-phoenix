`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import Faker from 'faker'`
`import ImportBatchesNew from 'dummy/tests/pages/appointment/import-batches/new'`
`import BatchShow from 'dummy/tests/pages/batch/index'`

moduleForAcceptance 'Acceptance: ChildrenRouteTest'

test "children index and creation", (assert) ->
  store = @application.__container__.lookup("service:store")
  fsm = @application.__container__.lookup("service:finite-state-machine").reset()
  appointment = null
  visit "/"
  andThen ->
    store.createRecord "appointment", 
      name: Faker.name.firstName()
      material: Faker.name.lastName()
    .save()
    .then (a) -> appointment = a

  andThen ->
    assert.ok appointment.id, 
      "we should have an appointment"
    ImportBatchesNew.visit id: appointment.id

  andThen ->
    assert.equal currentPath(), "appointment.import-batches.new",
      "we should be on the new import batches page"
    ImportBatchesNew.createBatch()

  andThen ->
    assert.equal currentPath(), "batch.index",
      "we should be redirected to the batch show page"
    assert.ok BatchShow.material,
      "we should have material"
    assert.ok BatchShow.weight,
      "we should have weight"
    assert.equal BatchShow.importAppointment, appointment.get("id"),
      "We should be the child of the proper parent"
    assert.notOk BatchShow.exportAppointment,
      "This should not be there"