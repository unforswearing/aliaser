# `aliaser` To Do

Tasks to complete for aliaser version 3.0.0:

## To Do

- [ ] Consolidate dependency checks.
- [ ] Confirmation of newly created aliases should be a single function.
- [ ] Add some sort of error checking.
  - Error if more args than expected
  - Error if args are missing
  - Check exit status
  - Run shellcheck against newly created aliases?
  - Etc?
- [ ] Add method to bulk add new aliases from a file.
  - `aliaser import "bash_aliases.sh"`
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
  - Use correct `base64` flags
  - Stop using hardcoded paths
  - Etc?

## Completed

- [x] Remove test / check for presence of `osascript`
  - Not needed, not sure why I added this?
- [x] Make variables readonly where relevant.
