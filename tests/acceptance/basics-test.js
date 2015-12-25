import { test } from 'qunit';
import moduleForAcceptance from '../../tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | basics');

test('visiting /basics', function(assert) {
  visit('/basics');

  andThen(function() {
    assert.equal(currentURL(), '/basics');
  });
});
