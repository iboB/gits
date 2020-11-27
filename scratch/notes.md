# Notes

## Glossary

"dep" is a dependency.

Each dep has a type, a category, and a source

### Types of deps

* **package**: a git repo which has tags which match a version: `[v]<integers separated by dots>` (say "1.31", "v1.3.2", "v0")
    * always shallow clone
    * will look for gits.yml for deps in cloned dir
* **repo**: a git repo which doesn't have this (or one that has but has ben coerced to this manually)
    * always deep clone
    * won't look inside cloned dir

### Categories

* **own**: needed by the package
* **dev**: dev-only. Only cloned if gits.yml is root. dev deps of a dep are not deps of ours

### Source

* **root**: manually requested by the user
* **indirect**: deps of a manually requested ones (or deps of deps of deps... etc)

## Commands

* `gits list`
    * show installed deps
* `gits remove name`
    * Remove from root deps and all indirect orphans. You can't remove from indirect deps.
* `gits fetch`
    * if there is no gits.lock.yml, fetch based on gits.yml (fresh clone)
    * if there is gits.lock.yml, use it to save traffic (gits.yml updated)
* `gits update dep-name`
    * same args as add, including
    * `--rev=` - update to specific revision for package, or specific sha, or tag, or branch (HEAD) for repos
    * `--all` - instead of dep name, update all root deps
    * basically do the same as add
* `gits repair`
    * fetch ignoring gits.lock.yml and gits/ dir (same as `$ rm -rf gits.yml.lock gits/ && gits install` )
* `gits infer`
    * build gits.yml and gits.lock.yml based on gits dir

## Questions and TODOs

* flavors? - current flavors are own and dev. support more? (for example depending on os or target)

* repo compatiblity
    * always error on different hashes
    * Future: perhaps think of using commit ancenstry to do something about it?
        * if commit A is an ancestor of commit B, assume B is a later version of the same repo. If there are no ancestors, assume versions are incompatible
* install command: run something after fetch
* Allow cli runner to be reused for other tools (allow external config of tool name, yml files and dir)

