### v0.3.1 - Mar 3, 2014

**features**
- add support for rails 4 and drop support for Rails 3.0 (3.1+)
- add flash notifications for Configurable updates
- added ability to cache configurables

**bug fixes**
- moved view logic back to the controller
- modernize dependency management
- modernize test suite
- support travis.yml (testing against Ruby 1.9, 2, jruby in 19 mode, rails 3.1, rails 3.2, rails 4)

### v0.2.9 - Aug 19, 2011

**features**
- add validations for keys in configurables
- Assignment of configuration with []= and method missing
- Configurables works if table doesn't exist (returns defaults)

**bug fixes**
- remove unused dependencies & development dependencies

### v0.2.8 - Jul 11, 2011

**features**
- relax dependencies to allow support for Rails 3.1

**bug fixes**
- remove unused dependencies

### v0.2.6 - Feb 9, 2011

**features**
- Sort keys alphabetically in the admin

### v0.2.5 - Feb 6, 2011

**bug fixes**
- make dependencies more accurate & less stringent
- dry up admin form

### v0.2.1 - Jan 17, 2011

**features**
- Add checkbox for booleans
- Sort keys

### v0.2.0 - Jan 10, 2011

**features**
- Add support for 'list' type
