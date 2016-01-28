`import _x from 'autox/utils/xdash'`
`import { module, test } from 'qunit'`
`import _ from 'lodash/lodash'`

module 'Unit | Utility | xdash'

matchTest = (x) ->
  _x.match x,
    ["dog", -> "dog"],
    [/(beaver|rodent)/, ([_, x]) -> x],
    [_, -> "xxx"]

test 'it works', (assert) ->
  assert.equal matchTest("dog"), "dog"
  assert.equal matchTest("beaver"), "beaver"
  assert.equal matchTest("rodent"), "rodent"
  assert.equal matchTest("beavers and rodents"), "beaver"
  assert.equal matchTest("honey smack"), "xxx"
