# RxJS, for Angular + Closure Compiler - EXPERIMENTAL

## Third-party repackaging - EXPERIMENTAL

This is an experimental, third-party repackaging of the RxJS code. Don't use
this for production code!

## Background

As of March 2017, there is considerable interest in performing Angular
production builds using (only!) Angular AOT ("ngc") and Google Closure Compiler:

https://github.com/angular/angular/issues/8550

This would be an all-Google build pipeline, and Closure is generally believed
to be the best available (and perhaps the longest available) solution to produce
small fast JavaScript output for web deployment.

One missing piece is a version of RxJS that can be consumed with full type
support by Closure Compiler. Note that this is not absolutely necessary, it is
possible to use an ES2015-module build of RxJS, which is likely to land in the
official RxJS distribution much sooner. However, much of Closure's magic
("ADVANCED_OPTIMIZATIONS") is enabled by its understanding of data types in the
code it processes. The RxJS ES2015-module packaging will not provide this, but
the alternative packaging here does.

As of this writing, I've not yet done side-by-side comparisons to see how much
smaller the output is with full typing provided to Closure Compiler.

(For the best possible results of course, Angular itself would also need to
arrive at Closure with types intact. That is probably considerably more complex
than this effort - it may only happen if someone inside Google does it.)

## How to consume this

Get this code:

```
npm install rxjs-closure
```

This package is intended for people already working with Angular, AOT, and
Closure Compiler. If you're in that group, you probably familiar with a script
somewhat like the one below, used to call Closure to perform the second half of
the build process.

```
#!/bin/bash
set -ex

OPTS=(
  "--language_in=ES6_STRICT"
  "--language_out=ES5"
  "--compilation_level=ADVANCED_OPTIMIZATIONS"
  "--js_output_file=output.js"

  # Various file paths elided here, to bring in Angular itself,
  # Zone, CoreJS, etc.

  # Bring in this package's RxJS files.
  $(find node_module/rxjs-closure/rxjs -name *.js)

  $(find my_app_built_code -name *.js)

  "--entry_point=built.main"
  "--dependency_mode=STRICT"
)

closureFlags=$(mktemp)
echo ${OPTS[*]} > $closureFlags
java -jar node_modules/google-closure-compiler/compiler.jar --flagfile $closureFlags
```

Of course your details may vary and be considerably more complex; important
thing is that this code is intended for consumption via Closure, not by any
other build stack.

Also, while it may be possible to consume this code and build a Regular project
using the new JavaScript implementation of Closure, I have not yet succeeded in
doing so. It lacks some of the switches I have been using with Closure, Java
edition.

## How this is produced

This package is bleeding edge, not done yet, and possibly wrong in multiple ways.

It is produced using the current master (as of March 7, commit cfc9d139) tsickle:

https://github.com/angular/tsickle

tsickle is a tool to consume TypeScript code, and produce Closure compatible
JavaScript code with types from TypeScript embedded as Closure JSDoc-like
comment. I have contributed a total of two lines of code to tsickle, I am just
digging through including all these pieces together, all of the hard work here
came from smart people who mostly work at Google.

# TODO

* Publish a demo repo that consumes this one.
* Ship a side-by-side comparison of the results using this versus the (less
  tricky to obtain) ES2015-bundle version of RxJS.
