import os

def find_workspace_dir(file_path):
    """
    Recursively find the workspace directory by looking for a root marker.
    """
    root_markers = ['.git', 'pyproject.toml']
    current_dir = os.path.dirname(file_path)

    while current_dir and current_dir != os.path.dirname(current_dir):  # Stop at root
        for marker in root_markers:
            if os.path.exists(os.path.join(current_dir, marker)):
                return current_dir
        current_dir = os.path.dirname(current_dir)

    # Fallback to the file's directory if no markers are found
    return os.path.dirname(file_path)


def Settings(**kwargs):
    filename = kwargs.get("filename")
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
                    'extraPaths': (
                        [
                            find_workspace_dir(filename)
                        ]
                        if filename
                        else []
                    ),
                    "autoImportCompletions": False,
                    "autoSearchPaths": False,
                    "useLibraryCodeForTypes": False,
                    "typeCheckingMode": "off",
                    "diagnosticMode": "openFilesOnly",
                    "logLevel": "Error",
                },
            },
        },
    }
