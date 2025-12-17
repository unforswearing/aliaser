# `aliaser` To Do

Tasks to complete for aliaser version 3.0.0:

## To Do

- [ ] Create 'dev_aliaser.sh' and tooling.
  - To avoid breaking things / improve developer experience.
- [ ] Add `aliaser version` command.
- [ ] Add method to bulk add new aliases from a file.
  - `aliaser import "bash_aliases.sh"`
  - Easy implmentation: only match file lines that start with 'alias', ignore everthing else.
  - This `import` command will also help to update aliaser internally (see below).
- [ ] Add an internal method to update aliaser
  - `aliaser update`
    - Curl `version` file from github
    - Extract version from aliaser script
      - Build this command into aliaser itself as `aliaser version`
    - If `version` file is more recent than `aliaser version`, an update is needed
      - Export aliases to temporary file (`aliaser clearall`)
      - Replace aliaser.sh with new version
      - Import aliases to new aliaser.sh script (`aliaser import /tmp/aliaser_clearall.bkp`)
        - The command `aliaser import <file>` is to be written.
      - Confirm success
    - If no update needed, output current script version.
- [ ] Add Linux compatibility (test on Debian 13)
  - Use correct `base64` flags
  - Make sure other linux commands work correctly on both Linux and MacOS
    - `awk`, `grep`, `tail`, `printf`, `sed`, `cat`, `eval`, `test`, etc
  - [x] Remove the dependency on `sed` / `gsed`. See above.
  - [x] Stop using hardcoded paths
    - Paths have been removed for shell commands

## Completed

- [x] Confirmation of newly created aliases should be a single function.
- [x] Remove dependency on `gsed`
  - Achieves the goal of "Linux Compatibility"
  - `gsed` has been replaced with standard `bash` commands
- [x] Consolidate dependency checks.
- [x] Add some sort of error checking.
  - [x] Error if args are missing
- [x] Remove test / check for presence of `osascript`
  - Not needed, not sure why I added this?
- [x] Make variables readonly where relevant.
