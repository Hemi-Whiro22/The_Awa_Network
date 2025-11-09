# Compatibility layer for Render deployment
# This allows the old backend.core.main:app to work with new Te_Po structure

import sys
import os

# Add the current directory to Python path so Te_Po can be imported
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Import the actual app from Te_Po
from Te_Po.core.main import app

# Export it so uvicorn backend.core.main:app works
__all__ = ['app']