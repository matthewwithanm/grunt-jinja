grunt = require 'grunt'
fs = require 'fs'
coffee = require '../tasks/jinja'

#  ======== A Handy Little Nodeunit Reference ========
#  https://github.com/caolan/nodeunit
#
#  Test methods:
#    test.expect(numAssertions)
#    test.done()
#  Test assertions:
#    test.ok(value, [message])
#    test.equal(actual, expected, [message])
#    test.notEqual(actual, expected, [message])
#    test.deepEqual(actual, expected, [message])
#    test.notDeepEqual(actual, expected, [message])
#    test.strictEqual(actual, expected, [message])
#    test.notStrictEqual(actual, expected, [message])
#    test.throws(block, [error], [message])
#    test.doesNotThrow(block, [error], [message])
#    test.ifError(value)


# A few helpers borrowed from https://github.com/namuol/grunt-coffeecup/
readFile = (file) ->
  contents = grunt.file.read file
  contents = contents.replace /\r\n/g, '\n'  if process.platform is 'win32'
  contents
assertFileEquality = (test, pathToActual, pathToExpected, message) ->
  actual = readFile pathToActual
  expected = readFile pathToExpected
  test.equal expected, actual, message


exports.jinja =

  compileSimple: (test) ->
    test.expect 1

    assertFileEquality test,
      'tmp/simple/index.html',
      'test/expected/simple/index.html',
      'Should compile Jinja templates'

    test.done()

  compileWithContext: (test) ->
    test.expect 1

    assertFileEquality test,
      'tmp/context/index.html',
      'test/expected/context/index.html',
      'Should compile Jinja templates with context files'

    test.done()
