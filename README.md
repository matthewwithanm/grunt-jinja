# grunt-jinja

> A grunt plugin for compiling Jinja2 templates with James Long's awesome
> [nunjucks templating system][nunjucks].

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-jinja --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-jinja');
```

## The "jinja" task

### Overview
In your project's Gruntfile, add a section named `jinja` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  jinja: {
    options: {
      // Task-specific options go here.
    },
    your_target: {
      // Target-specific file lists and/or options go here.
    },
  },
})
```

### Options

#### options.templateDirs
Type: `Array`
Default value: `[path.join(process.cwd(), 'templates')]`

A an array of paths in which your templates can be found. If not provided, this
will default to the "templates" directory at the same level as your Gruntfile.

#### options.contextRoot
Type: `String`
Default value: `path.join(process.cwd(), 'template-context')`

The directory in which your template context files can be found. grunt-jinja
will look in this directory to find JSON documents or node modules that
correspond to your template names and use them for that template. For example,
if you use a template "products/phones.html", you can create a
"products/phones.json" or "products/phones.js" file in the context root and it
will be used as context when rendering the template. To add context to all of
your templates, create an "_all.json" or "_all.js" file in the context root.

#### options.filters
Type: `Object`
Default value: `{}`

An object whose keys are filter names and values are functions. Each pair will
be registered with the template environment using the [addFilter][] method.

### Other options

Other options are passed directly to the [nunjucks environment object][1].
Currently, valid options are as follows:

#### options.dev
Type: `Boolean`
Default value: `false`

A boolean which, if true, puts nunjucks into development mode which means that
error stack traces will not be cleaned up.

### options.autoescape
Type: `Boolean`
Default value: `true`

A boolean which, if true, will escape all output by default See
[Autoescaping][2].

### options.tags
Type: `Object`
Default value: {}

An object specifying custom block start and end tags. See [Customizing Variable
and Block Tags][3].


### Usage Examples

#### Default Options
In this example, the default options are used to compile a templates in the
"templates/" directory to the "built" directory:

```js
grunt.initConfig({
  jinja: {
    files: {
      'built/index.html': 'templates/index.html'
    },
  },
})
```

This example compiles all templates that don't begin with an underscore:

```js
grunt.initConfig({
  jinja: {
    dist: {
      files: [{
        expand: true,
        dest: 'built/',
        cwd: 'templates/',
        src: ['**/!(_)*.html']
      }]
    }
  }
})
```

#### Custom Options
In this example, custom options are used to load the templates from directories
other than "templates":

```js
grunt.initConfig({
  jinja: {
    dist: {
      options: {
        templateDirs: ['src/templates']
      },
      files: {
        'built/index.html': 'src/templates/index.html'
      }
    }
  }
})
```

[nunjucks]: https://github.com/jlongster/nunjucks
[1]: http://nunjucks.jlongster.com/api#Environment
[2]: http://nunjucks.jlongster.com/api#Autoescaping
[3]: http://nunjucks.jlongster.com/api#Customizing-Variable-and-Block-Tags
[addFilter]: http://nunjucks.jlongster.com/api#Custom-Filters
