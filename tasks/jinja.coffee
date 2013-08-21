#
# grunt-jinja
# https://github.com/matthewwithanm/grunt-jinja
#
# Copyright (c) 2013 Matthew Tretter
# Licensed under the MIT license.
#

module.exports = (grunt) ->

  grunt.registerMultiTask 'jinja', 'A grunt plugin for compiling Jinja2 templates with nunjucks.', ->
    # Merge task-specific and/or target-specific options with these defaults.
    options = @options
      punctuation: '.'
      separator: ', '

    # Iterate over all specified file groups.
    @files.forEach (f) ->
      # Concat specified files.
      src = f.src.filter (filepath) ->
        # Warn on and remove invalid source files (if nonull was set).
        unless grunt.file.exists filepath
          grunt.log.warn """Source file "#{ filepath }" not found."""
          return false
        else
          return true

      .map (filepath) ->
        # Read file source.
        return grunt.file.read filepath
      .join grunt.util.normalizelf(options.separator)

      # Handle options.
      src += options.punctuation

      # Write the destination file.
      grunt.file.write f.dest, src

      # Print a success message.
      grunt.log.writeln """File "#{ f.dest }" created."""
