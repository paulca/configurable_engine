### v0.4.8 - March 4, 2015
**bug fix**
Cacheing was just totally broken.  Whoops! (thanks, @antoshalee)

### v0.4.7 - November 4, 2014
**bug fix**
Configurable broke for users using cacheing.

### v0.4.6 - October 28, 2014
**cleanup**
When using Configurable with cache, destroying a configurable instance erases it from cache

### v0.4.5 - October 13, 2014
**bug fixes**
Configurable can store false values when the default is true (https://github.com/paulca/configurable_engine/pull/24, thanks @lilliealbert)

### v0.4.4 - May 21, 2014
**bug fixes**
list types can *actually* deserialize comma delimeted nested and non-nested lists
tested end-to-end but need better specs.  sorry about the mess.


### v0.4.3 - May 21, 2014
**bug fixes**
list types can deserialize comma delimeted nested and non-nested lists

**in other news**
... time to learn how to release beta versions.  If I have to release another fix today, I'll do that.

### v0.4.2 - May 21, 2014
**bug fixes**
list types can serialize comma delimeted nested and non-nested lists

### v0.4.1 - May 21, 2014
**bug fixes**
if cacheing was enabled, configurable engine would never return default for unset values.

### v0.4.0 - May 21, 2014
**features**
Configurable.[]= will serialize arrays set to list-type params.
BREAKING CHANGE: Configurable#value and Configurable.[] should return similarly cast values (previously #value was always the string value)

### v0.3.3 - May 21, 2014
**bug fixes**
No longer uses mass assignment internally.

### v0.3.2 - Mar 12, 2014
**features**
re-releasing gem without test files included to shrink it.  Should have no code changes.

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
