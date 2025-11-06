# `aliaser` To Do

Tasks to complete for aliaser version 3.0.0:

## To Do

- [ ] Consolidate dependency checks.
- [ ] Confirmation of newly created aliases should be a single function.
- [ ] Make variables readonly where relevant.
- [ ] Add some sort of error checking.
  - Error if more args than expected
  - Error if args are missing
  - Check exit status
  - Run shellcheck against newly created aliases?
  - Etc?
- [ ] Add method to bulk add new aliases from a file.
  - `aliaser addbulk "bash_aliases.sh"`
- [ ] Add an internal method to update aliaser
  - `aliaser updateself`
    - Curl script from github
    - Check if update is needed (via script version, or etc (TBD))
    - If update needed
      - Export aliases to temporary file
      - Replace aliaser.sh with new version
      - Import aliases to new aliaser.sh script
      - Confirm success
    - If no update needed, confirm script is latest version.
- [ ] Add Linux compatibility (test on Debian 13)
  - Check for GNU `sed`
  - Use correct `base64` flags
  - Stop using hardcoded paths
  - Etc?

## Completed

- [x] Remove test / check for presence of `osascript`
  - Not needed, not sure why I added this?
