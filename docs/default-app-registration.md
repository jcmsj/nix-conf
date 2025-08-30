To register a default app for some media in home manager:

run 
```
ls -l /run/current-system/sw/share/applications
```

then edit
```nix
mimeApps.defaultApplications 
```
as needed


references:
https://discourse.nixos.org/t/where-are-desktop-files-located/17391/3
