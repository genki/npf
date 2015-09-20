sinon = require 'sinon'
argv = require "argv"
http = require 'cheerio-httpcli'

describe 'Cli', ->
  it 'can search', ->
    cli = require(__dirname+'/../src/cli')
    sinon.stub argv, 'option'
      .returns run: -> targets:['foo'], options:{}
    mock = sinon.mock http
    mock.expects('fetch').once()
    do cli.run
    do mock.verify
