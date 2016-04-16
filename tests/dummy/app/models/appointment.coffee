`import DS from 'ember-data'`

Appointment = DS.Model.extend
  name: DS.attr "string",
    label: "Appointment Reference Name"
    description: "The human readable name of your appointment"
    modify: ["new", "edit"]
    display: ["show", "index"]
  material: DS.attr "string",
    label: "Appointment Materials"
    description: "Materials expected to be dropped off or picked up by this appointment"
    modify: ["new", "edit"]
    display: ["show", "index"]

  importBatches: DS.hasMany "batch",
    async: true
    inverse: "importAppointment"
  exportBatches: DS.hasMany "batch",
    async: true
    inverse: "exportAppointment"

`export default Appointment`
