id-builder = require "id-builder"

e <-! id-builder do
  tasks:
    clean:
      enabled: true

    compile-browserify:
      enabled: false

    compile-coffeescript:
      enabled: false

    compile-copy:
      enabled: true

    compile-jade:
      enabled: false

    compile-less:
      enabled: false

    compile-livescript:
      enabled: true

    compile-stylus:
      enabled: false

    run-browsersync-server:
      enabled: false

    run-servers:
      enabled: true

    run-tests:
      enabled: true

    watch-browserify:
      enabled: false

    watch-browsersync:
      enabled: false

    watch-coffeescript:
      enabled: false

    watch-jade:
      enabled: false

    watch-less:
      enabled: false

    watch-livescript:
      enabled: true

    watch-stylus:
      enabled: false

    watch-servers:
      enabled: true

    watch-copy:
      enabled: true

    watch:
      enabled: true

console.error e.stack or e if e
