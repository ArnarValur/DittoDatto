"""Integration tests for Establishment adapter against live SurrealDB.

Tests the full CRUD lifecycle: create → read → update → soft-delete → list.
Uses the company_test database (not company_sawasdee).
"""

from __future__ import annotations

import pytest

from mercury_core.models import Establishment
from mercury_engine.dependencies import CompanyRepos

pytestmark = [
    pytest.mark.integration,
    pytest.mark.asyncio(loop_scope="session"),
]


# ─── Factory helper ──────────────────────────────────────────────────────────


def make_establishment(**overrides) -> Establishment:
    """Create a minimal valid Establishment for testing."""
    defaults = {
        "name": "Test Spa",
        "slug": "test-spa",
        "address": "Test Street 1",
        "city": "Oslo",
        "zip": "0100",
        "country": "NO",
        "is_published": True,
        "is_active": True,
    }
    defaults.update(overrides)
    return Establishment(**defaults)


# ─── CRUD Tests ──────────────────────────────────────────────────────────────


async def test_create_and_read_establishment(repos: CompanyRepos):
    """Create an establishment, then read it back by ID."""
    est = make_establishment(name="Sawasdee Test", slug="sawasdee-test")
    created = await repos.establishments.create(est)

    assert created.id is not None
    assert created.name == "Sawasdee Test"
    assert created.slug == "sawasdee-test"
    assert created.created_at is not None

    # Read back by ID
    fetched = await repos.establishments.get(created.id)
    assert fetched is not None
    assert fetched.id == created.id
    assert fetched.name == "Sawasdee Test"
    assert fetched.country == "NO"


async def test_list_active_establishments(repos: CompanyRepos):
    """List should return only active, non-deleted establishments."""
    # Create 2 active + 1 that we'll soft-delete
    await repos.establishments.create(make_establishment(name="Spa A", slug="spa-a"))
    await repos.establishments.create(make_establishment(name="Spa B", slug="spa-b"))
    to_delete = await repos.establishments.create(make_establishment(name="Spa C", slug="spa-c"))

    await repos.establishments.delete(to_delete.id)

    active = await repos.establishments.list_active()
    assert len(active) == 2
    names = {e.name for e in active}
    assert names == {"Spa A", "Spa B"}


async def test_update_establishment(repos: CompanyRepos):
    """Update should merge new fields without replacing the whole record."""
    created = await repos.establishments.create(
        make_establishment(name="Before Update", slug="before-update")
    )

    updated_model = make_establishment(name="After Update", slug="before-update")
    updated = await repos.establishments.update(created.id, updated_model)

    assert updated.name == "After Update"
    assert updated.slug == "before-update"
    assert updated.id == created.id


async def test_soft_delete(repos: CompanyRepos):
    """Soft delete sets deleted_at; get() should return None for deleted records."""
    created = await repos.establishments.create(
        make_establishment(name="To Delete", slug="to-delete")
    )

    result = await repos.establishments.delete(created.id)
    assert result is True

    # get() should return None for soft-deleted
    fetched = await repos.establishments.get(created.id)
    assert fetched is None


async def test_get_by_slug(repos: CompanyRepos):
    """Find establishment by unique slug."""
    await repos.establishments.create(
        make_establishment(name="Slug Test", slug="unique-slug")
    )

    found = await repos.establishments.get_by_slug("unique-slug")
    assert found is not None
    assert found.name == "Slug Test"

    not_found = await repos.establishments.get_by_slug("nonexistent")
    assert not_found is None


async def test_count_establishments(repos: CompanyRepos):
    """Count should return the number of non-deleted records."""
    await repos.establishments.create(make_establishment(name="Count A", slug="count-a"))
    await repos.establishments.create(make_establishment(name="Count B", slug="count-b"))
    await repos.establishments.create(make_establishment(name="Count C", slug="count-c"))

    total = await repos.establishments.count()
    assert total == 3


async def test_list_published(repos: CompanyRepos):
    """list_published() should only return published + active establishments."""
    await repos.establishments.create(
        make_establishment(name="Published", slug="pub", is_published=True, is_active=True)
    )
    await repos.establishments.create(
        make_establishment(name="Draft", slug="draft", is_published=False, is_active=True)
    )

    published = await repos.establishments.list_published()
    assert len(published) == 1
    assert published[0].name == "Published"
