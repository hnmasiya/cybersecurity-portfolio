import importlib.util
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]


def load_module(relative_path, module_name=None):
    """Import a standalone script (whose directory names aren't valid
    Python package identifiers, e.g. 'Security-Automation') by file path.
    """
    path = REPO_ROOT / relative_path
    module_name = module_name or path.stem.replace("-", "_")
    spec = importlib.util.spec_from_file_location(module_name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)
    return module
