

module.exports =

  out_ext: 'html'

  file_options:
    _path: '/blog.html'
    post:
      _url: '/blog.html'
      content: '<p>List of blog posts</p>'

  roots:
    config:
      output_path: ->
        'domain.nz'
