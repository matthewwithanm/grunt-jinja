#
# grunt-jinja
# https://github.com/matthewwithanm/grunt-jinja
#
# Copyright (c) 2013 Matthew Tretter
# Licensed under the MIT license.
#

'use strict'

path = require 'path'

module.exports = (grunt) ->
  _ = require 'lodash'
  nunjucks = require 'nunjucks'

  removeInvalidFiles = (files) ->
    files.src.filter (filepath) ->
      # Warn on and remove invalid source files (if nonull was set).
      unless grunt.file.exists filepath
        grunt.log.warn "Source file \"#{ filepath }\" not found."
        false
      else
        true

  grunt.registerMultiTask 'jinja', 'A grunt plugin for compiling Jinja2 templates with nunjucks.', ->
    # Merge task-specific and/or target-specific options with these defaults.
    options = @options
      templateDirs: [path.join process.cwd(), 'templates']
      contextRoot: path.join process.cwd(), 'template-context'
      filters: {}

    loadContext = (templateName, removeExtension = true) ->
      ext = path.extname(templateName)
      contextName = if ext then templateName[...-ext.length] else templateName
      try
        context = require path.resolve(options.contextRoot, contextName)
      catch err
        return {}
      grunt.log.writeln "Using context #{ contextName }"
      context

    templateDirs = options.templateDirs or []
    loaders = (new nunjucks.FileSystemLoader(dir) for dir in templateDirs)

    unless loaders.length
      throw new Error 'You must set either the "templateDirs" or "loaders" option (or both).'

    # Filter out the task-specific options and pass the rest on to the nunjucks
    # environment.
    envOptions = {}
    for own k, v of options
      unless k in ['templateDirs', 'contextRoot', 'filters']
        envOptions[k] = v

    env = new nunjucks.Environment loaders, envOptions

    # Add custom filters
    for own k, v of options.filters
      env.addFilter k, v

    # Iterate over all specified file groups.
    @files.forEach (f) ->
      # Concat specified files.
      validFiles = removeInvalidFiles f

      if validFiles.length > 1
        grunt.fail.warn "Can't compile multiple sources into a single destination: #{ ', '.join validFiles }"

      validFiles.forEach (src) ->
        # Get the template name from the filepath
        templateName = do ->
          for dir in templateDirs
            fullPath = path.normalize src
            relPath = path.relative dir, fullPath
            unless relPath[0] is '.'
              return relPath
          throw new Error "Couldn't find \"#{ src }\" in template dirs: #{ templateDirs.join ', ' }"

        context = _.extend {}, loadContext('_all', false), loadContext(templateName)
        tmpl = env.getTemplate templateName
        try
          output = tmpl.render context
        catch err
          grunt.log.error err
          grunt.fail.warn "Couldn't render Jinja template."
        grunt.file.write f.dest, output
        grunt.log.writeln "File \"#{ f.dest }\" created."
