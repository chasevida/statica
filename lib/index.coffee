
fs        = require 'fs'
path      = require 'path'
writefile = require 'writefile'
util      = require 'util'


conflictErrorText = fs.readFileSync(
  path.join(__dirname, '../docs/conflict-error.txt'),
  'utf8'
)

module.exports = (opts = {}) ->

  class Statica

    constructor: ->
      @files = []

    clean_path: (filepath, ext = '', relative = false) ->

      if filepath.match(/index.html$/)?.length > 0
        return filepath

      filepath = filepath.replace '.html', ext

      if relative and filepath.indexOf('/') is 0
        filepath = filepath.substring(1)

      filepath

    path_exists: (filepath) ->

      for file in @files

        if file.path is filepath
          return file

      false

    compile_hooks: ->

      after_file: (ctx) =>

        if ctx.out_ext isnt 'html'
          return ctx

        url = ctx.file_options.post?._url

        unless url
          return ctx

        ctx.file_options.post._url = @clean_path(url, '', opts.relative?)
        ctx

      write: (ctx) =>

        if ctx.out_ext isnt 'html'
          return true

        file =
          content:  ctx.file_options.post?.content or ctx.content
          path: path.join(
            ctx.roots.config.output_path(),
            @clean_path(ctx.file_options._path, '/index.html')
          )
          previousPath: ctx.file_options._path

        collision = @path_exists file.path

        if collision

          throw new Error util.format(
            conflictErrorText,
            ctx.file_options._path,
            collision.previousPath,
            collision.path
          )

        @files.push file

        false

    category_hooks: ->

      after: =>

        for file in @files

          writefile(file.path, file.content)
