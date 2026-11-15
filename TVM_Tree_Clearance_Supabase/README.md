# TVM Tree Clearance Register – Supabase-connected Android project

## Supabase setup

1. Confirm the shared Supabase Auth account already exists.
2. Open the Supabase project SQL Editor.
3. Run the original `supabase-schema.sql` only if the table and authenticated-user RLS policies have not already been created.
4. Run the complete `supabase-safe-sync-migration.sql` once. It adds revision and deletion-marker columns and the compare-and-save RPC used by the updated app.
5. Keep public sign-ups disabled. The same shared account is used on the authorised phones.
6. Keep only the Supabase project URL and publishable key in the Android client. Never embed a secret/service-role key.

## Updated sync behaviour

- Local edits are saved immediately on the phone and queued for cloud upload.
- Queued changes retry when connectivity returns and during periodic sync.
- Each cloud write uses a revision check. A stale write is rejected instead of silently overwriting a newer cloud version.
- Cloud deletions use tombstones so another phone does not resurrect a deleted record.
- If two phones edit the same record from the same revision, the later write is not silently accepted. The local copy is preserved and the sync status reports a conflict. This version does not yet provide a screen to merge conflicting edits; resolve those cases before relying on the register operationally.
- Cloud updates are polled approximately every 15 seconds while signed in. Use Sync now for an immediate attempt.
- The same shared account means all authenticated phones have the same database permissions. Entry codes are attribution fields, not separate user identities.

## Build and test

Do not distribute the APK until the migration is applied and two-device tests pass. Test with sample records: create a record on phone A and confirm it appears on phone B; update a tree status and confirm it synchronises; take one phone offline, create a record, reconnect, and confirm it uploads; test deletion markers; and test simultaneous edits to confirm a conflict is reported rather than overwritten.

Open this folder in Android Studio. Build with JDK 17 and Android SDK 35. APK output after a successful build: `app/build/outputs/apk/debug/app-debug.apk`.

## Security note

The app uses a shared Supabase login and client-side entry/download codes. Anyone with the shared login can access the shared register. Do not store sensitive infrastructure data in an external cloud service without the appropriate organisational authorisation and security review.
