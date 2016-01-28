`import routeSplit from '../../../utils/route-split'`
`import { module, test } from 'qunit'`

module 'Unit | Utility | route split'

# Replace this with your real tests.
test 'it works', (assert) ->
  assert.deepEqual routeSplit("manager.docks.index"),
    ["manager", "docks", "index"]

  assert.deepEqual routeSplit("api.v2.manager.load-dock.index"),
    ["api.v2.manager", "load-dock", "index"]

  assert.deepEqual routeSplit("applebees.new"),
    ["", "applebees", "new"]

  assert.deepEqual routeSplit("manager.chairs.barstool"),
    ["manager.chairs", "barstool", ""]

  assert.deepEqual routeSplit("index"),
    ["", "index", ""]