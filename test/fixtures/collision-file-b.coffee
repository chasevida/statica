

module.exports =

  out_ext: 'html'

  file_options:
    _path: '/blog/index.html'
    post:
      _url: '/blog/index.html'
      content: '<p>A misplaced blog post</p>'

  roots:
    config:
      output_path: ->
        'domain.nz'
