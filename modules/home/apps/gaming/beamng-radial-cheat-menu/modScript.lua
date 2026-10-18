-- Auto-load CheatMenu GE extension with manual unload mode so it persists across maps
log('W', 'CheatMenu_modScript', 'Executing modScript: loading cheatMenuu')
extensions.load('cheatMenuu')
setExtensionUnloadMode('cheatMenuu', 'manual')
