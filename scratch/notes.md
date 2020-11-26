# Notes

## Glossary

* *project repos* - ones manually added by the user
    * *repos* - explicit deps of this project
    * *dev repos* - repos which are only added if project is root
* *dep repos* - repos requested indirectly by project deps

## Commands

* `gits add repo-link`
    * `--name=` - give specific id (otherwise it's inferred from the repo)
    * `--branch=`, `--tag=` - clone specific branch
    * `--commit=sha` - clone specific commit
    * `--shallow` - set "always shallow" for this repo specifically
    * Add new project repo
* `gits remove name`
    * Remove from project repos and all indirect orphans. You can't remove from dep repos.
* `gits update`
    * `--shallow` - perform a shallow update
    * update based on gits.yml
* `gits

## Questions and TODOs

* deps?
* flavors?
* depth, recursion?
*
