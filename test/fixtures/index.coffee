
collisionFixtureA = require './collision-file-a'
collisionFixtureB = require './collision-file-b'
dynamicFixture    = require './dynamic-content'
imageFixture      = require './image-file'
rootFixture       = require './root-html'
standardFixture   = require './standard-html'


exports.collisionHtmlFileA = collisionFixtureA
exports.collisionHtmlFileB = collisionFixtureB
exports.dynamicContentFile = dynamicFixture
exports.imageFile          = imageFixture
exports.rootHtmlFile       = rootFixture
exports.standardHtmlFile   = standardFixture

exports.list = [
  dynamicFixture
  imageFixture
  standardFixture
]
