`import DS from 'ember-data'`

Batch = DS.Model.extend
  material: DS.attr "string",
    label: "Material Name"
    description: "The stuff in this batch"
    modify: ["children#new", "edit"]
    display: ["show", "index"]
  weight: DS.attr "number",
    label: "Batch Weight"
    description: "The weight (in pounds) of this pallet batch of material"
    modify: ["children#new", "edit"]
    display: ["show", "index"]

  importAppointment: DS.belongsTo "appointment",
    label: "Import Appointment"
    description: "The appointment that this batch come in"
    display: ["show"]
    async: true
  exportAppointment: DS.belongsTo "appointment",
    label: "Export Appointment"
    description: "The appointment that this batch will ship out in"
    display: ["show"]
    async: true
`export default Batch`
