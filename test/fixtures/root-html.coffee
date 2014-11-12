
module.exports =

  out_ext: 'html'
  file_options:
    _path: '/index.html'

  content: '<p>html content</p>'

  roots:
    config:
      output_path: ->
        'domain.nz'
