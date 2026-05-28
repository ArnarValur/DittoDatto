"""SurrealDB database layer for MercuryEngine.

Provides:
- SurrealDBClient: Dual-connection manager (titan + enceladus)
- Record ID serialization utilities
- Concrete repository adapters (in adapters/ subpackage)
"""

from .client import SurrealDBClient
from .record import make_record_id, model_to_record, parse_record_id, record_to_model

__all__ = [
    "SurrealDBClient",
    "make_record_id",
    "model_to_record",
    "parse_record_id",
    "record_to_model",
]
