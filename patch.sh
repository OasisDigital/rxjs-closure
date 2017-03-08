#!/bin/bash

# This is a temporary measure to get past an incompatibility in RxJS TypeScript
# cpde with Closure Compiler requirements. It would be preferable to have RxJS
# upstream change this line of code.

sed -i.bak "s/throw /\/\/ Elided to appease Closure... /g"  rxjs/util/root.js

rm rxjs/util/root.js.bak

# TODO Possibly patch for the handful of remaining Closure warnings.
