import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
from main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_health(client):
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.get_json() == {"status": "ok"}


def test_list_tasks_includes_seed_task(client):
    resp = client.get("/api/tasks")
    assert resp.status_code == 200
    titles = [t["title"] for t in resp.get_json()]
    assert "Set up CI/CD pipeline" in titles


def test_create_task_requires_title(client):
    resp = client.post("/api/tasks", json={})
    assert resp.status_code == 400


def test_create_task_success(client):
    resp = client.post("/api/tasks", json={"title": "Write tests"})
    assert resp.status_code == 201
    body = resp.get_json()
    assert body["title"] == "Write tests"
    assert body["done"] is False
