# DittoDatto App — Install Guide for Höddi

## One-Time Setup (PocketPickle)

1. **Make sure Tailscale is connected** on PocketPickle
2. **Enable sideloading:**
   - Open **Settings** → **Apps** → **Special access** → **Install unknown apps**
   - Allow your **browser** (Chrome/Samsung Internet) to install apps

## Download & Install

Open this URL in your phone browser:

```
http://dittodatto:8005/marketplace.apk
```

> If `dittodatto` doesn't resolve, use: `http://100.87.99.59:8005/marketplace.apk`

Tap the download → tap **Install** when prompted.

## Login

- Open the **DittoDatto** app
- Go to the **Profile** tab (bottom right)
- Tap **Logg inn**
- Use your email + password

## Getting Updates

When we push a new version, just open the same URL again and reinstall. The app will update in place — your data is safe (it lives on the server, not the phone).

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Can't install" | Enable sideloading (step 2 above) |
| "No connection" | Check Tailscale is connected on PocketPickle |
| Login spinning | Check Tailscale — the app talks directly to Saturn |
