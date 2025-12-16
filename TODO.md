# `aliaser` To Do

Tasks to complete for aliaser version 3.0.0:

## To Do

- [ ] Remove dependency on `gsed`
  - Achieves the goal of "Linux Compatibility" (see below)
- [ ] Create 'dev_aliaser.sh' and tooling.
  - To avoid breaking things / improve developer experience.
- [ ] Confirmation of newly created aliases should be a single function.
- [ ] Add method to bulk add new aliases from a file.
  - `aliaser import "bash_aliases.sh"`
  - Easy implmentation: only match file lines that start with 'alias', ignore everthing else.
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
  - Check for GNU `sed`
    - Note: Attempting to remove the dependency on `sed` / `gsed`. See above.
  - Use correct `base64` flags
  - Stop using hardcoded paths
  - Etc?

## Completed

- [x] Consolidate dependency checks.
- [x] Add some sort of error checking.
  - [x] Error if args are missing
- [x] Remove test / check for presence of `osascript`
  - Not needed, not sure why I added this?
- [x] Make variables readonly where relevant.
