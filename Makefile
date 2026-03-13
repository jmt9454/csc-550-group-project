FRONTEND_DIR := frontend
BACKEND_DIR := backend
DATABASE_DIR := database

# --- OS Detection ---
ifeq ($(OS),Windows_NT)
    SHELL := cmd.exe
    # Use 'rd' for Windows and 'rm -rf' for others in the clean target
    RM_RF := rd /s /q
    # A fix for the find command on Windows
    CLEAN_PY := del /s /q *.pyc && for /d /r . %%d in (__pycache__ .pytest_cache) do @if exist "%%d" rd /s /q "%%d"
else
    SHELL := /bin/sh
    RM_RF := rm -rf
    CLEAN_PY := find . -type d -name "__pycache__" -exec rm -rf {} + && find . -type d -name ".pytest_cache" -exec rm -rf {} +
endif

.PHONY: install install-frontend install-backend dev dev-frontend dev-backend db-up db-down db-reset db-diff db-diff-force clean

# ==========================================
# Installation Commands
# ==========================================
install: install-backend install-frontend
	@echo All dependencies installed successfully! Use command 'make dev' to start the development servers.

install-backend:
	@echo Installing Backend dependencies...
	cd $(BACKEND_DIR) && uv sync
	@echo Backend dependencies installed.

install-frontend:
	@echo Installing Frontend dependencies...
	cd $(FRONTEND_DIR) && pnpm install
	@echo Frontend dependencies installed.

# ==========================================
# Database Commands
# ==========================================
db-up:
	@echo Starting PostgreSQL...
	docker compose up -d

db-down:
	@echo Stopping PostgreSQL...
	docker compose down

db-reset:
	@echo Resetting PostgreSQL database...
	docker compose down -v
	docker compose up -d
	@echo PostgreSQL reset complete.

db-diff:
ifndef name
	$(error Error: Provide a name. Usage: make db-diff name=migration_name)
endif
	@echo Generating database migration...
	cd $(DATABASE_DIR) && atlas migrate diff $(name) --env local
	@echo Migration generated. Please review and apply it.

db-diff-force:
ifndef name
	$(error Error: Provide a name. Usage: make db-diff-force name=migration_name)
endif
	@echo Forcing database migration generation...
	cd $(DATABASE_DIR) && atlas migrate diff $(name) --env local --allow-destructive
	@echo Migration generated with force. Please review and apply it.

db-apply:
	@echo Pushing migrations to localhost:5432...
	cd $(DATABASE_DIR) && atlas migrate apply --env local

db-status:
	@echo Current migration state:
	cd $(DATABASE_DIR) && atlas migrate status --env local

db-hash:
	@echo Recomputing Atlas integrity hash...
	cd $(DATABASE_DIR) && atlas migrate hash --env local

# ==========================================
# Development Server Commands
# ==========================================
dev-backend:
	@echo Starting FastAPI backend...
	cd $(BACKEND_DIR) && uvicorn main:app --reload --host 127.0.0.1 --port 8000

dev-frontend:
	@echo Starting Vue.js...
	cd $(FRONTEND_DIR) && pnpm run dev

dev:
	@echo Starting both servers...
	$(MAKE) -j 2 dev-backend dev-frontend

# ==========================================
# Cleanup
# ==========================================
clean:
	@echo Cleaning up node_modules and Python cache...
	@if exist $(FRONTEND_DIR)\node_modules $(RM_RF) $(FRONTEND_DIR)\node_modules
	$(CLEAN_PY)