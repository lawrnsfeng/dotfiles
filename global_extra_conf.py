def Settings(**kwargs):
    return {
        "ls": {
            "pyright": {
                "disableLanguageServices": False,
                "disableOrganizeImports": True,
                "disableTaggedHints": True,
                "useLibraryCodeForTypes": False,
                "openFilesOnly": True,
            },
            "python": {
                "analysis": {
                    "autoImportCompletions": False,
                    "autoSearchPaths": False,
                    "useLibraryCodeForTypes": False,
                    "typeCheckingMode": "off",
                    "diagnosticMode": "openFilesOnly",
                    "logLevel": "Error",
                }
            }
        }
    }
