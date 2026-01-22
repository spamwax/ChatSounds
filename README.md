# ChatSounds Addon

ChatSounds adds customizable audio cues for chat events (Guild, Party, Raid, whispers, BN whispers, and custom channels). Each event can play either one of the bundled .mp3 clips or one of the built-in Blizzard sounds defined in `SoundList.lua`.

## Installation
1. Drop the `ChatSounds` folder into your `Interface/AddOns` directory.
2. Ensure `ChatSounds.toc` and `ChatSounds.lua` (plus the supporting XML and sound assets) are present.
3. Restart or `/reload` the WoW UI.

## Usage
- Type `/chatsounds` to open the options panel or `/chatsounds !help` for command references.
- Select distinct incoming/outgoing sounds per channel via the Interface Options entry that now appears under `AddOns > ChatSounds`.
- Use `/chatsounds <custom channel>` to toggle custom channel blacklisting.

## Recent updates
### Nov 28, 2025
- Registered the options window through `InterfaceOptions_AddCategory` and made `/chatsounds` invoke `InterfaceOptionsFrame_OpenToCategory` when available.
- Replaced removed UI templates (`OptionsButtonTemplate`, `OptionsCheckButtonTemplate`, `TitleRegion`) with modern equivalents and safely guarded the bag-button helpers/text widgets that may not exist anymore.
- Made sure the configuration tables are initialized before showing or saving settings so the new interface code no longer hits nil globals.
### Dec 3, 2025
- Delay `hooksecurefunc("ChatFrame_OnEvent")` until the core chat frame handler exists, with a `PLAYER_LOGIN` fallback so the hook runs without causing the `hooksecurefunc(): ChatFrame_OnEvent is not a function` error.

## Notes
- Sounds live under the `Sounds/` directory; add your own by editing `SoundList.lua` and placing files in that folder.
- The addon now syncs with Blizzard's current API, so the options panel should load cleanly on Retail clients.
