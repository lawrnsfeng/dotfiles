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
    # Default fallback - actual settings come from g:ycm_language_server in .vimrc
    features = []
    features_str = os.getenv("RUST_FEATURES", "")
    if features_str:
        features = [
            feat.strip() for feat in features_str.split(",")
        ]
    return {
        'ls': {
            'rust-analyzer': {
                'cargo': {
                    'features': features,
                    'noDefaultFeatures': False,
                }
            }
        }
    }
