

module.exports =

  out_ext: 'html'

  file_options:
    _path: '/dynamic-content.html'
    post:
      _url: '/dynamic-content.html'
      content: '<p>html content</p>'

  roots:
    config:
      output_path: ->
        'domain.nz'
