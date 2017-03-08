# RxJS for Closure Compiler - EXPERIMENTAL

## Third-party repackaging - EXPERIMENTAL

This is an experimental, third-party repackaging of the RxJS code. Don't use
this for production code!

## Who?

Kyle Cordes, I work at <https://oasisdigital.com/> and teach at
<https://angularbootcamp.com/>.

## Why care about Closure Compiler?

Our customers are mostly big, writing sprawling Angular applications. They have
legal departments whose job it is to be nervous about tool stacks with many
different dependencies. A shorter build tool stack that produces small results
is very appealing.

Eventually I expect to be possible used typed code all the way from application
and library source through Closure Compiler. If/when all these pieces come
together, that should result in the smallest/fastest bundles for Angular
deployment.

That's a ways off though, this is just one piece.

## Background

As of March 2017, there is considerable interest in performing Angular
production builds using (only!) Angular AOT ("ngc") and Google Closure Compiler:

https://github.com/angular/angular/issues/8550

This would be an all-Google build pipeline, and Closure is generally believed
to be the best available (and perhaps the longest available) solution to produce
small fast JavaScript output for web deployment.

One missing piece is a packaging of RxJS that can be consumed with full type
support by Closure Compiler. Note that this is not absolutely necessary, it is
possible to use an ES2015-module build of RxJS, which is likely to land in the
official RxJS distribution much sooner. However, some of Closure's magic (the
most advanced parts of "ADVANCED_OPTIMIZATIONS") are enabled by its
understanding of data types in the code it processes. The RxJS ES2015-module
packaging will not provide this, but the alternative packaging here does.

The other, more problematic missing piece is a packaging of Angular itself in a
way that provides Closure types. So far there is no packaging that does this.
That is probably considerably more complex than this effort.

## How to consume this

Get this code:

```
npm install @oasisdigital/rxjs-closure
```

Consult the `package.json` `devDependencies` to see what version of RxJS has
been packaged. For the initial release it is 5.2.0.

This package is intended for people already working with Closure Compiler. If
you're in that group, you probably familiar with a script somewhat like the one
below, used to call Closure to perform the second half of the build process.

```
#!/bin/bash
set -ex

OPTS=(
  "--language_in=ES6_STRICT"
  "--language_out=ES5"
  "--compilation_level=ADVANCED_OPTIMIZATIONS"
  "--js_output_file=output.js"

  # Bring in this package's RxJS files.
  $(find node_modules/@oasisdigital/rxjs-closure/rxjs -name *.js)

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

This packaging consists of "goog" modules, which are not (at least not
trivially) interoperable with ES2015 modules in Closure.  That is an obstacle to
any immediate benefit with Angular.

Also note that this is the Java implementation of Closure, not the newer (in
short a few commandline options) JavaScript limitation.

## How this is produced

This package is bleeding edge, not done yet, and possibly wrong in multiple ways.

It is produced using the current master (as of March 7 2017, commit cfc9d139)
tsickle:

https://github.com/angular/tsickle

tsickle is a tool to consume TypeScript code, and produce Closure compatible
JavaScript code with types from TypeScript embedded as Closure JSDoc-like
comment. I have contributed a total of two lines of code to tsickle, I am just
digging through including all these pieces together, all of the hard work here
came from smart people who mostly work at Google.

Importantly, so far tsickle can only produce "goog" modules, not ES2015 modules
which Closure is now capable of consuming.

# TODO

* Publish a demo repo that consumes this one.
* Keep an eye on changes that would enable a fully typed, Closure-ready Angular
  packaging.
* If this RxJS experiment turns out to have little value, delete it.
* If it turns out to be useful, hope the core RxJS ships it instead... then
  delete this third-party experimental package.
