# TVM Tree Clearance Register – Supabase-connected Android project

## Important
This build adds a shared Supabase sign-in and cloud-backed record table. The same Supabase Auth user can sign in on each authorised phone. Individual entry codes remain an app-level attribution field; they are not individual authenticated identities.

## Supabase setup (do this before installing)
1. Open your Supabase project SQL Editor.
2. Run the complete contents of `supabase-schema.sql`.
3. In Authentication settings, disable public sign-ups after confirming the shared account exists.
4. On each phone, sign in using the same shared account credentials. Do not put the password or secret/service-role key into source code.
5. Keep the publishable key in the client; never embed a `sb_secret_...` key in the APK.

## Build
Open this folder in Android Studio and build `app` > `assembleDebug`, or use Gradle 8.7 with JDK 17 and Android SDK 35. APK output: `app/build/outputs/apk/debug/app-debug.apk`.

## Sync behaviour and limitations
- The app uploads records to Supabase and polls for shared changes approximately every 15 seconds while signed in; use Sync now for an immediate refresh.
- Existing local records are uploaded automatically only if the cloud table is empty on the first login. If the cloud already contains records, cloud data is treated as authoritative. Export/back up any important local-only records before rollout.
- The app stores its Supabase session in WebView local storage. Sign out on shared/public phones when no longer authorised.
- This first cloud build uses whole-record upserts. Avoid editing the same tower location simultaneously on multiple phones; a later revision should implement conflict-safe per-tree updates and audit logging.
- Entry codes and CSV download code are client-side controls and are not a substitute for database security. Supabase RLS restricts table access to authenticated users.
- No live WebSocket subscription is included; changes appear on other phones on the next polling cycle.
- Test using two phones and non-sensitive sample data before operational deployment. Obtain organisation approval before storing transmission-line or other critical-infrastructure data in an external cloud service.
