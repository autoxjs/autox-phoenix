`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`
`import Faker from 'faker'`
{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/appointment/:id/import-batches/new")
  material: fillable("input[name=material]")
  weight: fillable("input[name=weight]")
  submit: clickable("button[type=submit]")
  createBatch: ->
    @material Faker.name.firstName()
    .weight Math.round Math.random() * 1000
    .submit()

`export default Page`