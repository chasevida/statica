# Statica

**Statica** is a [roots v3](https://www.npmjs.org/package/roots) plugin that converts boring `.html` files into pretty links. The new links are transformed based on your directory structure and file naming.

Basically it helps you drop the `.html` by transforming `blog/some-article.html` to `blog/some-article/index.html` so you can link straight to `blog/some-article`. It will also update the pages url at compile time so any dependent links will not be affected.

**Statica** is helpful if you are building a simple html based site (say for github pages) with roots but you want to keep your links pretty.

[![Build Status](https://travis-ci.org/chasevida/statica.svg)](https://travis-ci.org/chasevida/statica.svg)
[![Coverage Status](https://img.shields.io/coveralls/chasevida/statica.svg)](https://coveralls.io/r/chasevida/statica?branch=master)

> **Note:** This plugin is in early development and as such is not considered stable. Early releases may change significantly.

## Setup
In your `app.coffee` make sure you require `statica` and add it to the extension list.

```
statica = require 'statica'

module.exports =
  extensions: [statica()]
```

For local development purposes you can set `relative` linking to true. This will remove the leading `/` from any generated links. It is not recomended for production as it will not resolve nested links to the project root. This is really only helpful if you're wanting to load up your html files locally without roots.

```
statica = require 'statica'

module.exports =
  extensions: [statica({
    relative: true
  })]
```

##Gotchas
There are a few things to watch out for.

* Hard coded links are not updated. This plugin works great with [roots dynamic content](https://www.npmjs.org/package/dynamic-content) as it is able to access and update a files url to match it's new location allowing proper linking. However, with static content it cannot do the same. So please keep in mind how this plugin transforms pages when adding any hard coded links.
* If you have a file `blog.html` and another `blog/index.html` you will get a error alerting you to a collision. Statica will stop roots compiling to let you resolve this conflict.
