`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import Faker from 'faker'`
`import AppointmentsIndex from 'dummy/tests/pages/appointments/index'`
`import AppointmentShow from 'dummy/tests/pages/appointment/index'`
`import BatchShow from 'dummy/tests/pages/batch/index'`
`import BatchesIndex from 'dummy/tests/pages/appointment/import-batches/index'`

moduleForAcceptance 'Acceptance: RelationLinkTest'

test "proper working relational links", (assert) ->
  store = @application.__container__.lookup("service:store")
  fsm = @application.__container__.lookup("service:finite-state-machine").reset()
  apptId = null
  AppointmentsIndex.visit()

  andThen ->
    assert.equal currentPath(), "appointments.index",
      "we should be on the right path"

    assert.ok AppointmentsIndex.hasAppointments(),
      "we should have some appointments here"

    AppointmentsIndex.clickFirst()

  andThen ->
    assert.equal currentPath(), "appointment.index",
      "we should be on the appointment show page"

    assert.ok (apptId = AppointmentShow.id),
      "we should be on a proper appointment page"

    AppointmentShow.clickImportBatches()

  andThen ->
    assert.equal currentPath(), "appointment.import-batches.index",
      "we should be on the correct index page"