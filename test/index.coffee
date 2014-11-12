
expect     = require('chai').expect
fixtures   = require('./fixtures')
proxyquire = require('proxyquire')
sinon      = require('sinon')
Statica    = require('../lib')()


describe 'static/lib', ()->

  statica = undefined

  beforeEach () ->
    statica = new Statica


  it 'should exist', (done) ->

    expect(Statica).to.be.an('function')
    expect(statica).to.be.an.instanceof(Statica)
    done()


  it 'should clean file path', (done) ->

    result = statica.clean_path '/page.html', '/index.html'
    expect(result).to.equal '/page/index.html'

    result = statica.clean_path '/page.html'
    expect(result).to.equal '/page'

    result = statica.clean_path '/page.html', '/index.html', true
    expect(result).to.equal 'page/index.html'

    result = statica.clean_path 'page.html', '/index.html', true
    expect(result).to.equal 'page/index.html'
    done()

  it 'should not clean file path ending with index.html', (done) ->

    result = statica.clean_path 'index.html', '/index.html', true
    expect(result).to.equal 'index.html'

    result = statica.clean_path '/blog/index.html', '/index.html', true
    expect(result).to.equal '/blog/index.html'
    done()


  describe 'write hook', () ->

    write_hook = undefined

    beforeEach () ->
      write_hook = statica.compile_hooks()['write']


    it 'should only write html files', (done) ->

      result = write_hook(fixtures.imageFile)
      expect(result).to.be.true
      done()

    it 'should add html to writable file list', (done) ->

      expect(statica.files).to.be.an('array')
      expect(statica.files.length).to.equal 0

      result = write_hook(fixtures.standardHtmlFile)
      expect(result).to.be.false
      expect(statica.files.length).to.equal 1

      result = write_hook(fixtures.dynamicContentFile)
      expect(result).to.be.false
      expect(statica.files.length).to.equal 2
      done()

    it 'should add appropriate write keys to files object', (done) ->

      fileKeys = ['content', 'path', 'previousPath']
      expect(statica.files.length).to.equal 0

      write_hook(fixtures.standardHtmlFile)
      expect(statica.files.length).to.equal 1
      expect(statica.files[0]).to.have.keys fileKeys

      done()


    it 'should not write files with colliding urls', (done) ->

      try
        write_hook(fixtures.collisionHtmlFileA)
        write_hook(fixtures.collisionHtmlFileB)

      catch err

        expect(err).to.be.an.instanceof Error
        done()


  describe 'after_file hook', () ->

    after_file_hook = undefined

    beforeEach () ->
      after_file_hook = statica.compile_hooks()['after_file']


    it 'should update dynamic content only', (done) ->

      result = after_file_hook(fixtures.imageFile)
      expect(result).to.equal(fixtures.imageFile)

      result = after_file_hook(fixtures.standardHtmlFile)
      expect(result).to.equal(fixtures.standardHtmlFile)
      done()


    it 'should update the url path', (done) ->

      url = fixtures.dynamicContentFile.file_options.post._url
      expect(url).to.equal '/dynamic-content.html'

      result = after_file_hook(fixtures.dynamicContentFile)
      expect(result).to.equal(fixtures.dynamicContentFile)

      url = fixtures.dynamicContentFile.file_options.post._url
      expect(url).to.equal '/dynamic-content'
      done()


  describe 'category after hook', () ->

    after_hook = undefined
    staticas   = undefined
    writefile  = undefined
    mockFile   =
      content: '<p>This is html content</p>'
      path:    'test-page-output.html'

    beforeEach () ->
      writefile     = sinon.spy()
      StaticaStubed = proxyquire('../lib', {'writefile': writefile})()
      staticas      = new StaticaStubed
      after_hook    = staticas.category_hooks()['after']


    it 'should write files from files array', (done) ->

      staticas.files.push mockFile

      expect(staticas.files.length).to.equal 1
      expect(writefile.callCount).to.equal 0
      after_hook()

      expect(writefile.callCount).to.equal 1

      calledWith = writefile.calledWith(mockFile.path, mockFile.content)
      expect(calledWith).to.be.true

      done()
