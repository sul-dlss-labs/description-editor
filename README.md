# Description Editor

A proof-of-concept for editing Cocina descriptive metadata.

The basic flow is:
1. User provides a druid.
2. If a draft does not already exist, DE retrieves Cocina item from dor-services-app and creates a draft. (A draft is a copy of the Cocina description stored in DE.) If a draft already exists, user is asked to discard the draft or continue editing it.
3. User edits the draft. Every time the user saves, the draft is updated.
4. When completed with the draft, the user clicks "Updates description".
5. DE updates the Cocina item with dor-services-app.

Current status:
* Title is partially implemented (not handling uniform titles). Note: The user will be warned if data will be lost due to incomplete implementation.
* No tests.
* Rubocop violations.
