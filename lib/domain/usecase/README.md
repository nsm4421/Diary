# Domain Use Case Guide

Every scenario now emits trace logs for each major step and escalates any unexpected condition through `logUseCaseFailure`, ensuring `Failure.description` strings stay in English for UI consumption. Below is a quick reference for how each use case reacts on success versus failure.

## Diary Scenarios

### Create Diary Entry
- **Success**: Validates title/content, optionally uploads media, persists the entry, and logs each step (validation, upload, DB write) as trace/success messages.
- **Failure**: Returns a `Failure.validation` when inputs are empty or exceed character limits; upload or persistence issues are converted via `failureFromApiError` and logged with `logUseCaseFailure` before bubbling up.

### Get Diary Detail
- **Success**: Trims the diary id, queries the repository, then logs whether the detail existed or not while returning the mapped entity.
- **Failure**: Empty ids trigger `Failure.validation`; repository errors convert to `Failure` objects, get logged, and are returned to the caller.

### Fetch Diary Entries
- **Success**: Validates the requested limit, executes the proper search strategy, builds a `Pageable` cursor, and logs the item count in the result.
- **Failure**: Invalid limits produce validation failures; repository errors are mapped/logged with context about the fetch phase.

### Update Diary Entry
- **Success**: Validates id/content, normalizes text, performs the update, and emits trace logs for the repository call and its completion.
- **Failure**: Missing id/content or oversized content return validation failures; repository errors become `Failure` instances and are logged before being returned.

### Delete Diary Entry
- **Success**: Ensures the id is non-empty, calls delete, and logs the successful completion.
- **Failure**: Empty ids cause validation failures; repository issues are mapped/logged via `logUseCaseFailure`.

### Watch Diary Entries
- **Success**: Emits trace logs whenever the stream delivers a new list of diaries (including the count) and forwards the success side of the `Either` unchanged.
- **Failure**: Any stream event carrying an error is converted to `Failure`, logged, and pushed downstream as a `Left`.

## Security Scenarios

### Save Password Hash
- **Success**: Trims the hash, persists it, and logs the save attempt/result.
- **Failure**: Empty hashes trigger `Failure.validation`; repository issues are mapped to `Failure` and logged before returning left.

### Fetch Password Hash
- **Success**: Reads the stored value, logs whether a hash existed, and returns it in the right side.
- **Failure**: Repository errors are turned into `Failure`, logged with a “fetch” hint, and surfaced to the caller.

### Clear Password
- **Success**: Requests deletion from the repository, logs completion, and returns `Right(unit)`.
- **Failure**: Any underlying error is mapped/logged via `logUseCaseFailure` and returned as left.

## Setting Scenarios

### Get Dark Mode State
- **Success**: Queries the repository, logs the resolved boolean flag, and returns it as a success value.
- **Failure**: Repository errors use `failureFromApiError`, get logged with the “lookup” context, and propagate as failures.

### Set Dark Mode State
- **Success**: Issues the toggle command, logs the target state, and confirms completion with a success log.
- **Failure**: Persistence issues are converted into `Failure`, logged, and surfaced to the caller.
